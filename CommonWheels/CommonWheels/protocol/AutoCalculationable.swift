//
//  AutoCalculationable.swift
//  LayoutTest
//
//  Created by PanJiuLong on 2020/3/18.
//  Copyright © 2020 Utimes-MacbookPro. All rights reserved.
//
import UIKit

protocol AutoCalculationable{
    //根据屏幕宽度计算比例宽度
    func auto() -> Double
}

extension Double: AutoCalculationable { }

extension AutoCalculationable where Self == Double {

    func auto() -> Double {
        guard UIDevice.current.userInterfaceIdiom == .phone else {
            return self
        }

        let base = 375.0
        let screenWidth = Double(UIScreen.main.bounds.width)
        let screenHeight = Double(UIScreen.main.bounds.height)
        let width = min(screenWidth, screenHeight)
        return self * (width / base)
    }
}

extension BinaryFloatingPoint {
    func auto() -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.auto()
    }
    func auto<T: BinaryInteger>() -> T {
        let temp = Double("\(self)") ?? 0
        return T(temp.auto())
    }
    func auto<T: BinaryFloatingPoint>() -> T {
        let temp = Double("\(self)") ?? 0
        return T(temp.auto())
    }
}

extension BinaryInteger {
    func auto() -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.auto()
    }
    func auto<T: BinaryInteger>() -> T {
        let temp = Double("\(self)") ?? 0
        return temp.auto()
    }
    func auto<T: BinaryFloatingPoint>() -> T {
        let temp = Double("\(self)") ?? 0
        return temp.auto()
    }
}
