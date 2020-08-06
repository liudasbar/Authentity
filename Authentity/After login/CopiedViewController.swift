//
//  CopiedViewController.swift
//  Authentity
//
//  Created by LiudasBar on 2020-08-06.
//  Copyright © 2020 LiudasBar. All rights reserved.
//

import UIKit

class CopiedViewController: UIViewController {

    @IBOutlet weak var copiedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        copiedView.layer.cornerRadius = 30
        copiedView.clipsToBounds = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
