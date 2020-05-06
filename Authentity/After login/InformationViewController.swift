//
//  InformationViewController.swift
//  Authentity
//
//  Created by LiudasBar on 2020-05-05.
//  Copyright © 2020 LiudasBar. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBAction func privacyPolicyButtonAction(_ sender: UIButton) {
        guard let url = URL(string: "https://github.com/liudasbar/Authentity/blob/master/README.md#privacy-policy") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBOutlet weak var githubButton: UIButton!
    @IBAction func githubButtonAction(_ sender: UIButton) {
        guard let url = URL(string: "https://github.com/liudasbar/Authentity") else { return }
        UIApplication.shared.open(url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        privacyPolicyButton.layer.cornerRadius = 10
        privacyPolicyButton.layer.masksToBounds = true
        
        githubButton.layer.cornerRadius = 10
        githubButton.layer.masksToBounds = true
        
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionLabel.text = "Version: \(appVersion!), Build: \(buildNumber!)"
    }
}
