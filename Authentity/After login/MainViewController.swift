//
//  MainViewController.swift
//  Authentity
//
//  Created by LiudasBar on 2020-05-05.
//
//
//  Copyright (c) 2020 Liudas Baronas - Authentity
//
//  Copyright (c) 2014-2020 Matt Rubin and the OneTimePassword authors - OneTimePassword
//
//  Copyright (c) 2015 - 2020 Evgenii Neumerzhitckii - KeychainSwift
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
import KeychainSwift

class MainViewController: UIViewController, FoundQR {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var authentityButton: UIButton!
    @IBOutlet weak var noItemsLabel: UILabel!
    
    let myContext = LAContext()
    let myLocalizedReasonString = "Unlock Authentity"
    
    //Array used to store Keychain Keys
    var authArray: [String] = []
    
    //Keychain (KeychainSwift)
    let keychain = KeychainSwift()
    
    //Timer related
    var timer = Timer()
    
    //Feedback Generator
    var generator = UIImpactFeedbackGenerator()
    
    //Add Entry button related
    @IBOutlet weak var addButton: UIButton!
    @IBAction func addButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "addSegue", sender: nil)
    }
    
    //Face ID button related
    @IBOutlet weak var faceIdButton: UIButton!
    @IBAction func faceIdButtonAction(_ sender: UIButton) {
        if faceIdButton.tintColor == UIColor.green {
            faceIdButton.tintColor = UIColor.darkGray
            keychain.set(false, forKey: "authentityFaceID")
        } else {
            faceIdButton.tintColor = UIColor.green
            keychain.set(true, forKey: "authentityFaceID")
            self.dismiss(animated: true, completion: nil)
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
        //Convert QR code String to URL
        let urlString = URL(string: url)
        
        //Convert QR code URL to Token (for creating a unique identifier)
        let token = Token(url: urlString!)

        //Create unique identifier for Keychain item
        let key: String = token!.name + token!.issuer + token!.currentPassword!
        
        //Save QR code String to Keychain
        keychain.set(url, forKey: key)
        
        //Check if QR code String saved to Keychain
        if keychain.set(url, forKey: key) {
            
            //Append unique identifier to authArray
            authArray.append(key)
            
            //Update unique identifiers array into UserDefaults
            UserDefaults.standard.set(authArray, forKey: "authArray")
            
        } else {
            let alert = UIAlertController(title: "Error!", message: "Entry not saved: Keychain error", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
                  switch action.style{
                  case .default:
                    print("Continue")
                  default:
                    print("Error")
                }}))
            self.present(alert, animated: true, completion: nil)
        }
        
        tableView.reloadData()
        
        checkNoItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.tintColor = UIColor.green
        
        tableView.layer.cornerRadius = 37
        tableView.layer.masksToBounds = true
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        if keychain.getBool("authentityFaceID")! {
            faceIdButton.tintColor = UIColor.green
        } else {
            faceIdButton.tintColor = UIColor.darkGray
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Table view element offset
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        authArray = UserDefaults.standard.stringArray(forKey: "authArray") ?? []
        
        tableView.reloadData()
        
        checkNoItems()
        
        //Hide tableview entries and stop timer when entered background
        NotificationCenter.default.addObserver(self, selector: #selector(self.background), name: UIApplication.willResignActiveNotification, object: nil)
        
        //Start timer when entered foreground
        NotificationCenter.default.addObserver(self, selector: #selector(self.foreground), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        checkInitialSeconds()
        scheduledTimerWithTimeInterval()
    }
    
    
    @objc func background(_ notification: Notification) {
        if keychain.getBool("authentityFaceID")! {
            self.dismiss(animated: true, completion: nil)
        }
        timer.invalidate()
    }
    
    @objc func foreground(_ notification: Notification) {
        timer.invalidate()
        checkInitialSeconds()
        scheduledTimerWithTimeInterval()
    }
    
    func checkNoItems() {
        if authArray.count > 0 {
            noItemsLabel.alpha = 0
        } else {
            noItemsLabel.alpha = 1
        }
    }
    
    func checkInitialSeconds() {
        let seconds = currentSeconds()
        if seconds > 30 {
            authentityButton.alpha = 1 - 0.033*CGFloat(seconds-30)
        } else {
            authentityButton.alpha = 1 - 0.033*CGFloat(seconds)
        }
    }
    
    func scheduledTimerWithTimeInterval() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        
        let seconds = currentSeconds()
        
        if (seconds>0 && seconds<25) || (seconds>30 && seconds<55) {
            //Disappearing button gradually up for 25 seconds after the last change
            authentityButton.alpha -= 0.033
        } else if (seconds>=25 && seconds<30) || (seconds>=55 && seconds<=59) {
            //Medium feedback and disappearing button gradually after 25 seconds for 5 seconds after the last change
            generator = UIImpactFeedbackGenerator(style: .medium)
            authentityButton.alpha -= 0.033
            generator.impactOccurred()
        } else if seconds == 30 || seconds == 0 {
            //Heavy feedback and button fully appears
            generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
            self.tableView.reloadData()
            UIView.animate(withDuration: 0.5) {
                self.authentityButton.alpha = 1
            }
        }
    }
    
    func currentSeconds() -> (Int) {
        let date = Date()
        let calendar = Calendar.current
        let seconds = calendar.component(.second, from: date)
        return seconds
    }
    
    func getTokenFromKeychain(indexpathRow: Int) -> (String, String, String) {
        //Get secured keychain item associated with authArray's identifiers
        let keychainItem = keychain.get(authArray[indexpathRow]) ?? "NONE"
        
        //Convert Keychain item String to URL
        let url = URL(string: keychainItem)
        
        //Convert URL to Token
        if let token = Token(url: url!) {
            
            //Used for splitting Token's current password's number: XXXXXX -> XXX XXX
            var newText = String()
            for (index, character) in token.currentPassword!.enumerated() {
                if index != 0 && index % 3 == 0 {
                    newText.append(" ")
                }
                newText.append(character)
            }
            
            return(newText, token.name, token.issuer)
        } else {
            print("Invalid token URL")
            
            return("", "", "")
        }
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "authCell", for: indexPath) as! TableViewCell
        
        let token = getTokenFromKeychain(indexpathRow: indexPath.row)
        
        cell.numberLabel.text = token.0
        cell.nameLabel.text = token.1
        cell.issuerLabel.text = token.2
        
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
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
            let dataChangedAlert = UIAlertController(title: "Warning!", message: "Are you sure you want this entry to be removed? This action cannot be undone.", preferredStyle: .alert)
            self.present(dataChangedAlert, animated: true, completion: nil)
            
            dataChangedAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in }))
            
            dataChangedAlert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { action in
                //Remove Keychain item associated with authArray's identificator
                self.keychain.delete(self.authArray[indexPath.row])
                
                //Remove associated identificator from authArray
                self.authArray.remove(at: indexPath.row)
                
                //Save authArray to UserDefaults
                UserDefaults.standard.set(self.authArray, forKey: "authArray")
                
                tableView.reloadData()
                
                self.checkNoItems()
            }))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let copiedToken = getTokenFromKeychain(indexpathRow: indexPath.row).0
        UIPasteboard.general.string = copiedToken.replacingOccurrences(of: " ", with: "")
        performSegue(withIdentifier: "copiedSegue", sender: nil)
    }
}
