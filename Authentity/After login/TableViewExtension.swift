//
//  TableViewExtension.swift
//  Authentity
//
//  Created by LiudasBar on 2021-01-11.
//  Copyright © 2021 LiudasBar. All rights reserved.
//

import Foundation
import UIKit

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
