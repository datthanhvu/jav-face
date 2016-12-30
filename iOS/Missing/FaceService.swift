//
//  FaceService.swift
//  Missing
//
//  Created by Gabriel Freire on 20/06/16.
//  Copyright © 2016 maslor. All rights reserved.
//

import Foundation
import ProjectOxfordFace

class FaceService {
    static let instance = FaceService()
    let client = MPOFaceServiceClient(subscriptionKey: "2fa87cd0bd364fefb8733624228a7319")
}
