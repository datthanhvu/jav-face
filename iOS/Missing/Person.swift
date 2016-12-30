//
//  Person.swift
//  Missing
//
//  Created by Gabriel Freire on 20/06/16.
//  Copyright © 2016 maslor. All rights reserved.
//

import Foundation
import UIKit
import ProjectOxfordFace

class Person {
    var faceId : String?
    var personImage: UIImage?
    var personImageUrl: String?
    
    init(personImageUrl: String) {
        self.personImageUrl = personImageUrl
    }
    
    func downloadFaceId() {
        if let img = personImage, let imageData=UIImageJPEGRepresentation(img,0.8) {
            FaceService.instance.client.detectWithData(imageData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces:[MPOFace]!, err: NSError!) in
                
                if err == nil {
                    var faceId : String?
                    for face in faces {
                        faceId = face.faceId
                        print("Face id: \(faceId)")
                        break
                    }
                    
                    self.faceId = faceId
                }
            })
        }
    }
    
}