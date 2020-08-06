//
//  SplashScreenViewController.swift
//  Authentity
//
//  Created by LiudasBar on 2020-05-05.
//  Copyright © 2020 LiudasBar. All rights reserved.
//

import UIKit
import AVFoundation
import KeychainSwift

class SplashScreenViewController: UIViewController {

    var delegate: cameraPermissions?
    
    let keychain = KeychainSwift()
    
    @IBOutlet weak var continueButton: UIButton!
    @IBAction func continueButtonAction(_ sender: UIButton) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                print("Camera permissions granted")
            } else {
                self.delegate?.cameraPermissionsRequest()
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keychain.set(false, forKey: "authentityFaceID")

        continueButton.layer.cornerRadius = 10
        continueButton.layer.masksToBounds = true
    }
}

protocol cameraPermissions: AnyObject {
    func cameraPermissionsRequest()
}

