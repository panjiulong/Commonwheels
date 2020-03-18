//
//  Screenshotable.swift
//  LayoutTest
//
//  Created by PanJiuLong on 2020/3/18.
//  Copyright © 2020 Utimes-MacbookPro. All rights reserved.
//

import UIKit

protocol Screenshotable {}
extension Screenshotable{
    func getScreenshot(with view:UIView,result:(UIImage?) -> ()) {
        if #available(iOS 10.0, *) {
            let data = UIGraphicsImageRenderer(size: view.bounds.size).pngData { _ in
                view.drawHierarchy(in: CGRect(origin: .zero, size: view.bounds.size), afterScreenUpdates: true)
            }
            result(UIImage(data: data))
        } else {
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            result(image)
        }
    }
}
