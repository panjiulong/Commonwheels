//
//  TestAnimationViewController.swift
//  CommonWheels
//
//  Created by PanJiuLong on 2020/3/23.
//  Copyright © 2020 Utimes-MacbookPro. All rights reserved.
//

import UIKit

class TestAnimationViewController: UIViewController {
    
    let rightToLeft = PresentAnimator(animatorType: .rightToLeft, hasBackground: true)
    
    let leftToRight = PresentAnimator(animatorType: .leftToRight, hasBackground: true)
    let bottomToTop = PresentAnimator(animatorType: .bottomToTop, hasBackground: true)
    let topTobottom = PresentAnimator(animatorType: .topTobottom, hasBackground: true)
    let scaleCenter = PresentAnimator(animatorType: .scaleCenter, hasBackground: true)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func topTobottom(_ sender: Any) {
        
        createVC(topTobottom)
        
    }
    @IBAction func bottomToTop(_ sender: Any) {
        
        createVC(bottomToTop)
        
    }
    @IBAction func leftToRight(_ sender: Any) {

        createVC(leftToRight)
        
    }
    @IBAction func rightToLeft(_ sender: Any) {
        createVC(rightToLeft)
        
    }
    @IBAction func scaleCenter(_ sender: Any) {
        createVC(scaleCenter)
        
    }
    
    func createVC(_ animator:PresentAnimator){
        let vc = UIStoryboard(name: "TestStoryboard", bundle: nil).instantiateViewController(identifier: "TestAnimatored")
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = animator
        present(vc, animated: true, completion: nil)
//        navigationController?.pushViewController(vc, animated: true)
    }
}
