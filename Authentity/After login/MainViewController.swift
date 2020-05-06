//
//  MainViewController.swift
//  Authentity
//
//  Created by LiudasBar on 2020-05-05.
//  Copyright © 2020 LiudasBar. All rights reserved.
//

//  Copyright (c) 2014-2020 Matt Rubin and the OneTimePassword authors
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit
import OneTimePassword
import LocalAuthentication

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FoundQR {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "authCell", for: indexPath) as! TableViewCell
        
        let url = URL(string: authArray[indexPath.row])
        
        if let token = Token(url: url!) {
            
            var newText = String()
            for (index, character) in token.currentPassword!.enumerated() {
                if index != 0 && index % 3 == 0 {
                    newText.append(" ")
                }
                newText.append(character)
            }
            
            cell.numberLabel.text = newText
            
            cell.nameLabel.text = token.name
            cell.issuerLabel.text = token.issuer
        } else {
            print("Invalid token URL")
        }
        
        cell.mainView.layer.cornerRadius = 15
        cell.mainView.layer.borderColor = UIColor.clear.cgColor
        cell.mainView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = 14.0
        cell.layer.shadowOpacity = 0.1
        cell.layer.masksToBounds = false
        //cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.authArray.remove(at: indexPath.row)
            
            UserDefaults.standard.set(authArray, forKey: "authArray")
            
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var authentityButton: UIButton!
    
    let myContext = LAContext()
    let myLocalizedReasonString = "Unlock Authentity"
    
    var authArray: [String] = []
    var faceIdBool: Bool = Bool()
    var timer = Timer()
    
    //Add Entry button related
    @IBOutlet weak var addButton: UIButton!
    
    //Face ID button related
    @IBOutlet weak var faceIdButton: UIButton!
    @IBAction func faceIdButtonAction(_ sender: UIButton) {
        if faceIdButton.tintColor == UIColor.green {
            faceIdButton.tintColor = UIColor.darkGray
            UserDefaults.standard.set(false, forKey: "faceID")
        } else {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Unlock Authentity"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [weak self] success, authenticationError in
                    
                    DispatchQueue.main.async {
                        if success {
                            self!.faceIdButton.tintColor = UIColor.green
                            UserDefaults.standard.set(true, forKey: "faceID")
                        } else {
                            
                        }
                    }
                }
            } else {
                //No biometry
                let alert = UIAlertController(title: "Biometrics not enabled", message: "Biometrics authentication attempts possibly exceeded or permissions not granted", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
                      switch action.style{
                      case .default:
                            print("")
                      default:
                        print("error")
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //For making the connection with AddViewController so it could pass data back
        if segue.destination is AddViewController {
            let vc = segue.destination as? AddViewController
            vc?.delegate = self
        }
    }
    
    //Executed when QR code is found and entry is added
    func qrFound(url: String) {
        authArray.append(url)
        tableView.reloadData()
        UserDefaults.standard.set(authArray, forKey: "authArray")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.tintColor = UIColor.green
        
        tableView.layer.cornerRadius = 37
        tableView.layer.masksToBounds = true
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        faceIdBool = UserDefaults.standard.bool(forKey: "faceID")
        if faceIdBool {
            faceIdButton.tintColor = UIColor.green
            UserDefaults.standard.set(true, forKey: "faceID")
        } else {
            faceIdButton.tintColor = UIColor.darkGray
            UserDefaults.standard.set(false, forKey: "faceID")
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Table view element offset
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        self.authArray = UserDefaults.standard.stringArray(forKey: "authArray") ?? []
        
        //Hide tableview entries when entered background
        NotificationCenter.default.addObserver(self, selector: #selector(background), name: UIApplication.willResignActiveNotification, object: nil)
        //Show tableview entries when entered background
        NotificationCenter.default.addObserver(self, selector: #selector(foreground), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        scheduledTimerWithTimeInterval()
    }
    
    
    @objc func background(_ notification: Notification) {
        authArray.removeAll()
        tableView.reloadData()
    }
    
    @objc func foreground(_ notification: Notification) {
        self.authArray = UserDefaults.standard.stringArray(forKey: "authArray") ?? []
        tableView.reloadData()
    }
    
    
    func scheduledTimerWithTimeInterval() {
        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        UIView.animate(withDuration: 0.3) {
            self.authentityButton.alpha = 0.5
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.reloadData()
            UIView.animate(withDuration: 0.5) {
                self.authentityButton.alpha = 1
            }
        }
    }
}
