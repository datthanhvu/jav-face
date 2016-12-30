//
//  ViewController.swift
//  Missing
//
//  Created by Gabriel Freire on 07/06/16.
//  Copyright © 2016 maslor. All rights reserved.
//

import UIKit
import ProjectOxfordFace

let baseURL = "http://localhost:6069/img/"

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var displayResult: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var selectedImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    var hasSelectedImage : Bool = false
    var selectedPerson : Person?
    
    let persons = [
        Person(personImageUrl: "person1.jpg"),
        Person(personImageUrl: "person2.jpg"),
        Person(personImageUrl: "person3.jpg"),
        Person(personImageUrl: "person4.jpg"),
        Person(personImageUrl: "person5.jpg"),
        Person(personImageUrl: "person6.jpg")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(loadPicker(_:)))
        tap.numberOfTapsRequired = 1
        selectedImage.addGestureRecognizer(tap)
        
    }

    
    func showErrorAlert() {
        let alert  = UIAlertController(title: "Select Person", message: "Please select a missing person to check and an image from your album", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func checkForMatch(_: AnyObject) {
        if selectedPerson == nil || !hasSelectedImage {
            showErrorAlert()
        } else {
            if let myImg = selectedImage.image, let imgData = UIImageJPEGRepresentation(myImg, 0.8) {
                
                FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces: [MPOFace]!, err: NSError!) in
                    
                    if err == nil {
                        var faceId: String?
                        for face in faces {
                            faceId = face.faceId
                            break
                        }
                        
                        if faceId != nil {
                            FaceService.instance.client.verifyWithFirstFaceId(self.selectedPerson!.faceId, faceId2: faceId, completionBlock: { (result: MPOVerifyResult!, err: NSError!) in
                                
                                if err == nil {
                                    print(result.confidence.floatValue * 100)
                                    print(result.isIdentical)
                                    if result.isIdentical {
                                        self.displayResult.text = "It's a match with \(result.confidence.floatValue * 100)% confidence!"
                                    } else {
                                        self.displayResult.text = "It's not a match with \(100 - result.confidence.floatValue * 100)% confidence."
                                    }
                                } else {
                                    print(err.debugDescription)
                                }
                            })
                        }
                    }
                })
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedPerson = persons[indexPath.row]
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PersonCell
        cell.setSelected()
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return persons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonCell", forIndexPath: indexPath) as! PersonCell
        let person = persons[indexPath.row]
        let url = "\(baseURL)\(persons[indexPath.row])"
        cell.configureCell(person)
        return cell
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage.image = pickedImage
            hasSelectedImage = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadPicker(gesture: UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }

}

