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

class TestViewController: UIViewController,Authorityable,LocationAuthorityable,CellularNetworkAuthorityable {
    var locationAuthorizedBlock: SystemAuthAuthorizedBlock? = {
        print("contact成功")
    }

    lazy var locationAuthDeniedBlock: SystemAuthDeniedBlock? = {
        return {[weak self](title,detail) in
            self?.authFailed(title: title, detail: detail)
        }

    }()
    var locationManager: CLLocationManager?

    var cellularData: CTCellularData? = CTCellularData()


    let animator = PresentAnimator(animatorType: .scaleCenter, hasBackground: true)

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func video(_ sender: Any) {
        requestAuthority(authType: .video, authorizedBlock: {
            print("video成功")
        })  {  [weak self] (title, detail) -> (Void)in
            self?.authFailed(title: title, detail: detail)
        }

    }
    @IBAction func photo(_ sender: Any) {
        requestAuthority(authType: .photos, authorizedBlock: {
            print("photo成功")
        })  {  [weak self] (title, detail) -> (Void)in
            self?.authFailed(title: title, detail: detail)
        }
    }
    @IBAction func audio(_ sender: Any) {
        requestAuthority(authType: .audio, authorizedBlock: {
            print("audio成功")
        })  {  [weak self] (title, detail) -> (Void)in
            self?.authFailed(title: title, detail: detail)
        }
    }
    @IBAction func contact(_ sender: Any) {
        requestAuthority(authType: .contact, authorizedBlock: {
            print("contact成功")
        })  {  [weak self] (title, detail) -> (Void)in
            self?.authFailed(title: title, detail: detail)
        }
    }
    @IBAction func locationAlways(_ sender: Any) {
        getLocationAlwaysAuthority(authorizedBlock: {
            print("locationAlways成功")
        }){  [weak self] (title, detail) -> (Void)in
            self?.authFailed(title: title, detail: detail)
        }
    }
    @IBAction func locationWhenInUse(_ sender: Any) {
        getLocationWhenInUseAuthority(authorizedBlock: {
            print("locationWhenInUse成功")
        }){  [weak self] (title, detail) -> (Void)in
            self?.authFailed(title: title, detail: detail)
        }
    }
    @IBAction func notifications(_ sender: Any) {
        requestAuthority(authType: .notifications, authorizedBlock: {
            print("notifications成功")
        })  {  [weak self] (title, detail) -> (Void)in
            self?.authFailed(title: title, detail: detail)
        }
    }
    @IBAction func cellularNetwork(_ sender: Any) {
        getCellularNetworkAuthority(authorizedBlock: { () -> (Void) in
            print("cellularNetwork成功")
        }) {  [weak self] (title, detail) -> (Void)in
            self?.authFailed(title: title, detail: detail)
        }
    }

    func authFailed(title:String,detail:String) {
        print("\(title)\(detail)")
        print(Thread.current)
        let vc = createAlertVC(title: title, detail: detail)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = animator
        present(vc, animated: true, completion: nil)
        
    }

    func createAlertVC(title:String,detail:String) -> UtimesAlertController{
        let alertVC = UtimesAlertController(title: title, desc: detail, leftTitle: "取消", rightTitle: "去设置")
        alertVC.delegate = self
        alertVC.alertView.descLabel.textColor = UIColor.darkText
        return alertVC
    }

}
extension TestViewController{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:break
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            locationAuthorizedBlock?()
        default:
            runDeniedBlock(with: .locationWhenInUse, deniedBlock: locationAuthDeniedBlock)
        }
    }
}
extension TestViewController:UtimesAlertControllerDelegate{
    func didTapLeft(on controller: UtimesAlertController){

    }
    func didTapRight(on controller: UtimesAlertController){
        //        Permission.cellularData?.cellularDataRestrictionDidUpdateNotifier = nil
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
