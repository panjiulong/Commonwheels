//
//  SecondViewController.swift
//  CommonWheels
//
//  Created by PanJiuLong on 2020/3/23.
//  Copyright © 2020 Utimes-MacbookPro. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func animatot(_ sender: Any) {
        let vc = UIStoryboard(name: "TestStoryboard", bundle: nil).instantiateViewController(identifier: "animator")
        navigationController?.pushViewController(vc, animated: true)

    }
}
