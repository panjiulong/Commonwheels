//
//  Inchable.swift
//  LayoutTest
//
//  Created by PanJiuLong on 2020/3/18.
//  Copyright © 2020 Utimes-MacbookPro. All rights reserved.
//


import UIKit
enum InchType {
    case unknown
    case i58Full
    case i55
    case i47
    case i40
    case i35
    //iPad 1、2
    case p17
    //iPad 4/Air/Air2/mini 2、3、4/ the new iPad(1536 * 2048)
    case p21
    //iPad Pro (2048 * 2732)
    case p22
    //iPad Pro 10.5 (1668 * 2224)
    case p216

    static let current: InchType = {
        let screenWidth = Float(UIScreen.main.bounds.width)
        let screenHeight = Float(UIScreen.main.bounds.height)
        let width = min(screenWidth, screenHeight)
        let height = max(screenWidth, screenHeight)

        if width == 375, height == 812 { return .i58Full }
        if width == 414, height == 736 { return .i55 }
        if width == 375, height == 667 { return .i47 }
        if width == 320, height == 568 { return .i40 }
        if width == 320, height == 480 { return .i35 }
        if width == 768,height == 1024 { return .p17 }
        if width == 1536,height == 2048 { return .p21 }
        if width == 2048,height == 2732 { return .p22 }
        if width == 1668,height == 2224 { return .p216 }
        return .unknown
    } ()
}

protocol Inchable {
    func i58full(_ value: Self) -> Self
    func i55(_ value: Self) -> Self
    func i47(_ value: Self) -> Self
    func i40(_ value: Self) -> Self
    func i35(_ value: Self) -> Self
}

extension Inchable {

    func i58full(_ value: Self) -> Self {
        return InchType.current == .i58Full ? value : self
    }
    func i55(_ value: Self) -> Self {
        return InchType.current == .i55 ? value : self
    }
    func i47(_ value: Self) -> Self {
        return InchType.current == .i47 ? value : self
    }
    func i40(_ value: Self) -> Self {
        return InchType.current == .i40 ? value : self
    }
    func i35(_ value: Self) -> Self {
        return InchType.current == .i35 ? value : self
    }
}

extension Int: Inchable {}
extension Float: Inchable {}
extension CGFloat: Inchable {}
extension Double: Inchable {}
extension String: Inchable {}
