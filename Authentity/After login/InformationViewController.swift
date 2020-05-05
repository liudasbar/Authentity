//
//  InformationViewController.swift
//  Authentity
//
//  Created by LiudasBar on 2020-05-05.
//  Copyright © 2020 LiudasBar. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    @IBOutlet weak var githubButton: UIButton!
    @IBAction func githubButtonAction(_ sender: UIButton) {
        guard let url = URL(string: "https://github.com/liudasbar/Authentity") else { return }
        UIApplication.shared.open(url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        githubButton.layer.cornerRadius = 10
        githubButton.layer.masksToBounds = true
    }
}
