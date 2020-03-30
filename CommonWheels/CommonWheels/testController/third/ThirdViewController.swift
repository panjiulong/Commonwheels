//
//  ThirdViewController.swift
//  CommonWheels
//
//  Created by PanJiuLong on 2020/3/23.
//  Copyright © 2020 Utimes-MacbookPro. All rights reserved.
//

import UIKit
import RxSwift

class ThirdViewController: UIViewController {

    let disposebag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    @IBAction func sendRequest(_ sender: Any) {
        ExampleService().getExampleInfo(id: 0).subscribe(onSuccess: { (model) in
            print("cg")
        }) { (error) in
            print("sb")
            print("\(UserDefaults.standard.value(forKey: "token"))")
        }.disposed(by: disposebag)
    }

}
