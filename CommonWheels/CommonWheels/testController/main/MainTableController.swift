//
//  MainTableViewController.swift
//  CommonWheels
//
//  Created by PanJiuLong on 2020/3/23.
//  Copyright © 2020 Utimes-MacbookPro. All rights reserved.
//

import UIKit

class MainTableController: UITabBarController {

//    let animator = TabbarAnimation()
    let animator = TransitionAnimator(animatorType: .scaleCenter(startScale: 0.97,endScale: 1.0,startAlpha: 0.01,endAlpha: 1.0), hasBackground: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

}
extension MainTableController:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
}
