//
//  TestAnimatoredViewController.swift
//  CommonWheels
//
//  Created by PanJiuLong on 2020/3/23.
//  Copyright © 2020 Utimes-MacbookPro. All rights reserved.
//

import UIKit

class TestAnimatoredViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .blue
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
