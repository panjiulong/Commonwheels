//
//  TestViewController.swift
//  CommonWheels
//
//  Created by PanJiuLong on 2020/3/18.
//  Copyright © 2020 Utimes-MacbookPro. All rights reserved.
//

import UIKit
import Contacts
import AVFoundation
import Photos
import CoreTelephony
import CoreLocation
import UserNotifications

class TestViewController: UIViewController,Authorityable {

    var locationManager: CLLocationManager = CLLocationManager.init()

    var cellularData: CTCellularData?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func video(_ sender: Any) {
        requestAuthority(authType: .video, authorizedBlock: {
            print("video成功")
        }) { (title, detail) -> (Void) in
            print("\(title)\\n\(detail)")
        }

    }
    @IBAction func photo(_ sender: Any) {
        requestAuthority(authType: .photos, authorizedBlock: {
            print("photo成功")
        }) { (title, detail) -> (Void) in
            print("\(title)\\n\(detail)")
        }
    }
    @IBAction func audio(_ sender: Any) {
        requestAuthority(authType: .audio, authorizedBlock: {
            print("audio成功")
        }) { (title, detail) -> (Void) in
            print("\(title)\\n\(detail)")
        }
    }
    @IBAction func contact(_ sender: Any) {
        requestAuthority(authType: .contact, authorizedBlock: {
            print("contact成功")
        }) { (title, detail) -> (Void) in
            print("\(title)\\n\(detail)")
        }
    }
    @IBAction func locationAlways(_ sender: Any) {
        requestAuthority(authType: .locationAlways, authorizedBlock: {
            print("locationAlways成功")
        }) { (title, detail) -> (Void) in
            print("\(title)\\n\(detail)")
        }
    }
    @IBAction func locationWhenInUse(_ sender: Any) {
        requestAuthority(authType: .locationWhenInUse, authorizedBlock: {
            print("locationWhenInUse成功")
        }) { (title, detail) -> (Void) in
            print("\(title)\\n\(detail)")
        }
    }
    @IBAction func notifications(_ sender: Any) {
        requestAuthority(authType: .notifications, authorizedBlock: {
            print("notifications成功")
        }) { (title, detail) -> (Void) in
            print("\(title)\\n\(detail)")
        }
    }
    @IBAction func cellularNetwork(_ sender: Any) {
        requestAuthority(authType: .cellularNetwork, authorizedBlock: {
            print("cellularNetwork成功")
        }) { (title, detail) -> (Void) in
            print("\(title)\\n\(detail)")
        }

    }


}
