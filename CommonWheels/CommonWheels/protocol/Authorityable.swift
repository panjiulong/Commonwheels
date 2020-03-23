//
//  Authorityable.swift
//  LayoutTest
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

public typealias SystemAuthAuthorizedBlock = () -> (Void)
public typealias SystemAuthDeniedBlock = (String,String) -> (Void)
public typealias SystemAuthSettingBlock = ()-> (Void)
//MARK: - AuthType
enum AuthType {
    case video                  //相机
    case photos                 //相册
    case audio                  //麦克风
    case contact                //联系人
    case locationAlways         //定位
    case locationWhenInUse      //定位
    case notifications          //通知
    case cellularNetwork        //蜂窝网络

    func alertTitleText() -> String {
        let displayName =  Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
        switch self {
        case .audio:
            return displayName + "无法获取麦克风权限"
        case .photos:
            return displayName + "无法访问相册"
        case .video:
            return displayName + "无法访问相机"
        case .contact:
            return displayName + "无法获取到联系人"
        case .locationAlways:
            fallthrough
        case .locationWhenInUse:
            return displayName + "无法获取到位置信息"
        case .notifications:
            return displayName + "无法给您发送通知"
        case .cellularNetwork:
            return displayName + "无线数据已关闭"
        }
    }
    func alertDetailText() -> String {
        let topStr = "您可以在“设置”中"
        switch self {
        case .audio:
            return "为此应用打开麦克风权限"
        case .photos:
            return topStr + "为此应用打开相册权限"
        case .video:
            return topStr + "为此应用打开相机权限"
        case .contact:
            return topStr + "允许应用访问联系人"
        case .locationAlways:
            fallthrough
        case .locationWhenInUse:
            return topStr + "允许应用访问位置信息"
        case .notifications:
            return topStr + "为此应用打开通知权限"
        case .cellularNetwork:
            return topStr + "为此应用打开无线数据"
        }
    }
}

//MARK: - AuthorityAlertable
protocol AuthorityAlertable {}
extension AuthorityAlertable{
    func runDeniedBlock(with type:AuthType,deniedBlock:SystemAuthDeniedBlock?) {
        deniedBlock?(type.alertTitleText(),type.alertDetailText())
    }
}

//MARK: - LocationAuthorityable
protocol LocationAuthorityable:CLLocationManagerDelegate,AuthorityAlertable{
    var locationManager: CLLocationManager?{get set}
    var locationAuthorizedBlock:SystemAuthAuthorizedBlock?{get set}
    var locationAuthDeniedBlock:SystemAuthDeniedBlock?{get set}
}

extension LocationAuthorityable{
    func getLocationAlwaysAuthority(authorizedBlock: @escaping SystemAuthAuthorizedBlock, deniedBlock: @escaping SystemAuthDeniedBlock){
        locationAuthorizedBlock = authorizedBlock
        locationAuthDeniedBlock = deniedBlock
        let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        locationManager = CLLocationManager.init()
        locationManager?.delegate = self
        switch authStatus {
        case .notDetermined:
           locationManager?.requestAlwaysAuthorization()
        case .authorizedAlways:
            locationAuthorizedBlock?()
        default:
            runDeniedBlock(with: .locationAlways, deniedBlock: locationAuthDeniedBlock)
        }
    }

    func getLocationWhenInUseAuthority(authorizedBlock: @escaping SystemAuthAuthorizedBlock, deniedBlock: @escaping SystemAuthDeniedBlock){
        locationAuthorizedBlock = authorizedBlock
        locationAuthDeniedBlock = deniedBlock
        let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        locationManager = CLLocationManager.init()
        switch authStatus {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            locationAuthorizedBlock?()
        default:
            runDeniedBlock(with: .locationWhenInUse, deniedBlock: locationAuthDeniedBlock)
        }
    }
//    func runDeniedBlock(with type:AuthType,deniedBlock:SystemAuthDeniedBlock?) {
//        deniedBlock?(type.alertTitleText(),type.alertDetailText())
//    }
}

extension LocationAuthorityable{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            locationAuthorizedBlock?()
        default:
            runDeniedBlock(with: .locationWhenInUse, deniedBlock: locationAuthDeniedBlock)
        }
    }
}

//MARK: - CellularNetworkAuthorityable
protocol CellularNetworkAuthorityable:CLLocationManagerDelegate,AuthorityAlertable{
    var cellularData: CTCellularData?{get set}
}
extension CellularNetworkAuthorityable{
    func getCellularNetworkAuthority(authorizedBlock: @escaping SystemAuthAuthorizedBlock, deniedBlock: @escaping SystemAuthDeniedBlock){
        cellularData?.cellularDataRestrictionDidUpdateNotifier = {[weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .notRestricted:
                    authorizedBlock()
                default:
                    self?.runDeniedBlock(with: .cellularNetwork, deniedBlock: deniedBlock)
                }
            }
        }
    }
}

//MARK: - Authorityable
protocol Authorityable:class,CLLocationManagerDelegate,AuthorityAlertable {}

extension Authorityable{
    func requestAuthority(authType: AuthType, authorizedBlock: @escaping SystemAuthAuthorizedBlock, deniedBlock: @escaping SystemAuthDeniedBlock) {
        switch authType {
        case .audio:
            getAudioAuthority(authorizedBlock: authorizedBlock, deniedBlock: deniedBlock)
        case .photos:
            getPhotoAuthority(authorizedBlock: authorizedBlock, deniedBlock: deniedBlock)
        case .video:
            getVideoAuthority(authorizedBlock: authorizedBlock, deniedBlock: deniedBlock)
        case .contact:
            getContactAuthority(authorizedBlock: authorizedBlock, deniedBlock: deniedBlock)
        case .notifications:
            getNotificationAuthority(authorizedBlock: authorizedBlock, deniedBlock: deniedBlock)
        default:break
        }
    }
}

extension Authorityable{
    func getPhotoAuthority(result: @escaping (Bool,PHAuthorizationStatus) -> ()) {
        let library = PHPhotoLibrary.authorizationStatus()
        if library == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                DispatchQueue.main.async{
                    if status == .authorized {
                        result(true, status)
                    } else if status == .denied || status == .restricted{
                        result(false, status)
                    }
                }
            })
        } else {
            result(true, library)
        }
    }
}

extension Authorityable{
    func getAudioAuthority(authorizedBlock: @escaping SystemAuthAuthorizedBlock, deniedBlock: @escaping SystemAuthDeniedBlock){
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        switch authStatus {
        case .notDetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ [weak self](granted) in
                DispatchQueue.main.async {
                    if granted {
                        authorizedBlock()
                    } else {
                        self?.runDeniedBlock(with: .audio, deniedBlock: deniedBlock)
                    }
                }
            })

        case .authorized:
            authorizedBlock()
        default:
            runDeniedBlock(with: .audio, deniedBlock: deniedBlock)
        }
    }

    func getContactAuthority(authorizedBlock: @escaping SystemAuthAuthorizedBlock, deniedBlock: @escaping SystemAuthDeniedBlock){
        if (UIDevice.current.systemVersion as NSString).doubleValue >= 9.0 {
            let authStatus:CNAuthorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
            switch authStatus {
            case .notDetermined:
                CNContactStore.init().requestAccess(for: CNEntityType.contacts, completionHandler: { [weak self](granted, error) in
                    DispatchQueue.main.async {
                        if granted && (error == nil){
                            authorizedBlock()
                        } else {
                            self?.runDeniedBlock(with: .contact, deniedBlock: deniedBlock)
                        }
                    }
                })
            case .authorized:
                authorizedBlock()
            default:
                runDeniedBlock(with: .contact, deniedBlock: deniedBlock)
            }
        }
    }

    func getVideoAuthority(authorizedBlock: @escaping SystemAuthAuthorizedBlock, deniedBlock: @escaping SystemAuthDeniedBlock){
        if AVCaptureDevice.responds(to: #selector(AVCaptureDevice.authorizationStatus(for:))) {
            let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch authStatus {
            case .notDetermined:

                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {[weak self] (granted) in
                    DispatchQueue.main.async {
                        if granted {
                            authorizedBlock()
                        } else {
                            self?.runDeniedBlock(with: .video, deniedBlock: deniedBlock)
                        }
                    }
                })

            case .authorized:
                authorizedBlock()
            default:
                runDeniedBlock(with: .video, deniedBlock: deniedBlock)
            }
        }
    }

    func getPhotoAuthority(authorizedBlock: @escaping SystemAuthAuthorizedBlock, deniedBlock: @escaping SystemAuthDeniedBlock){
        let authStatus:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ [weak self](status) in
                DispatchQueue.main.async {
                    if status == .authorized {
                        authorizedBlock()
                    } else {
                        self?.runDeniedBlock(with: .photos, deniedBlock: deniedBlock)
                    }
                }
            })
        case .authorized:
            authorizedBlock()
        default:
            runDeniedBlock(with: .photos, deniedBlock: deniedBlock)
        }
    }

    func getNotificationAuthority(authorizedBlock: @escaping SystemAuthAuthorizedBlock, deniedBlock: @escaping SystemAuthDeniedBlock){
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { [weak self](setting) in
                switch setting.authorizationStatus {
                case .notDetermined:
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){(granted, error) in
                        DispatchQueue.main.async {
                            if granted && (error == nil){
                                authorizedBlock()
                            } else {
                                self?.runDeniedBlock(with: .notifications, deniedBlock: deniedBlock)
                            }
                        }

                    }

                case .provisional:
                    DispatchQueue.main.async {
                        authorizedBlock()
                    }
                default:
                    DispatchQueue.main.async {
                        self?.runDeniedBlock(with: .notifications, deniedBlock: deniedBlock)
                    }

                }
            }

        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
            let setting = UIApplication.shared.currentUserNotificationSettings
            if setting?.types == Optional.none {
                //没有权限
                runDeniedBlock(with: .notifications, deniedBlock: deniedBlock)
            }else{
                authorizedBlock()
            }
        }
    }


//    func runDeniedBlock(with type:AuthType,deniedBlock:SystemAuthDeniedBlock) {
//        deniedBlock(type.alertTitleText(),type.alertDetailText())
//    }
}

