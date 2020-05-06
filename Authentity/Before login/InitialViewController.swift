//
//  InitialViewController.swift
//  Authentity
//
//  Created by LiudasBar on 2020-05-05.
//  Copyright © 2020 LiudasBar. All rights reserved.
//

import UIKit
import LocalAuthentication

class InitialViewController: UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    @IBAction func continueButtonAction(_ sender: UIButton) {
        if continueButton.titleLabel!.text == "Try again" {
            biometrics()
        } else if continueButton.titleLabel!.text == "Continue" {
            performSegue(withIdentifier: "loginSegue", sender: nil)
        } else if continueButton.titleLabel!.text == "Quit Authentity" {
            exit(0)
        }
    }
    
    @IBOutlet weak var removeDataButton: UIButton!
    @IBAction func removeDataButtonAction(_ sender: UIButton) {
        let authArray: [String] = []
        
        UserDefaults.standard.set(authArray, forKey: "authArray")
        UserDefaults.standard.set(false, forKey: "faceID")
        
        
        
        
        
        let alert = UIAlertController(title: "Warning!", message: "Before you enable Biometrics authentication, lock and unlock your device!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
              switch action.style{
              case .default:
                self.continueButton.alpha = 0
                self.removeDataButton.alpha = 0
                self.infoLabel.alpha = 0
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
              default:
                print("error")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var infoLabel: UILabel!
    
    let myContext = LAContext()
    let myLocalizedReasonString = "Unlock Authentity"
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    
    override func viewDidAppear(_ animated: Bool) {
        continueButton.setTitle("Continue", for: .normal)
        continueButton.alpha = 0
        removeDataButton.alpha = 0
        infoLabel.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.biometrics()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueButton.layer.cornerRadius = 10
        continueButton.layer.masksToBounds = true
        
        removeDataButton.layer.cornerRadius = 10
        removeDataButton.layer.masksToBounds = true
        
        continueButton.setTitle("Continue", for: .normal)
        
        continueButton.alpha = 0
        removeDataButton.alpha = 0
        infoLabel.alpha = 0
        
        infoLabel.text = ""
    }
}

extension InitialViewController {
    
    func biometrics() {
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if launchedBefore  {
            if UserDefaults.standard.bool(forKey: "faceID") {
                
                let context = LAContext()
                var error: NSError?
                
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    let reason = "Unlock Authentity"
                    
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                        [weak self] success, authenticationError in
                        
                        DispatchQueue.main.async {
                            if success {
                                UIView.animate(withDuration: 0.5) {
                                    self!.continueButton.alpha = 0
                                    self!.removeDataButton.alpha = 0
                                    self!.infoLabel.alpha = 0
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    self!.continueButton.setTitle("Continue", for: .normal)
                                    self!.performSegue(withIdentifier: "loginSegue", sender: nil)
                                }
                            } else {
                                self!.continueButton.setTitle("Try again", for: .normal)
                                self!.infoLabel.text = "Authentication failed"
                                UIView.animate(withDuration: 0.5) {
                                    self!.continueButton.alpha = 1
                                    self!.infoLabel.alpha = 1
                                }
                            }
                        }
                    }
                    self.myContext.localizedFallbackTitle = ""  //No password available
                    
                } else {
                    //No biometry
                    infoLabel.text = "No biometry available. To continue using Authentity, quit Authentity, lock and unlock your phone"
                    
                    UIView.animate(withDuration: 1) {
                        self.removeDataButton.alpha = 1
                        self.continueButton.alpha = 1
                        self.continueButton.setTitle("Quit Authentity", for: .normal)
                        self.infoLabel.alpha = 1
                    }
                }
            } else {
                performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        } else {
            performSegue(withIdentifier: "splashScreenSegue", sender: nil)
            continueButton.setTitle("Continue", for: .normal)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UIView.animate(withDuration: 0.5) {
                self.continueButton.alpha = 1
            }
        }
    }
}
