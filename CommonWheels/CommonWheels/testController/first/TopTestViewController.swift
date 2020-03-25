//
//  TopTestViewController.swift
//  CommonWheels
//
//  Created by PanJiuLong on 2020/3/24.
//  Copyright © 2020 Utimes-MacbookPro. All rights reserved.
//

import UIKit

class TopTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func push(_ sender: Any) {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        navigationController?.pushViewController(vc, animated: true)
    }


    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
