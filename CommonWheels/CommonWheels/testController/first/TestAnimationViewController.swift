//
//  TestAnimationViewController.swift
//  CommonWheels
//
//  Created by PanJiuLong on 2020/3/23.
//  Copyright © 2020 Utimes-MacbookPro. All rights reserved.
//

import UIKit

class TestAnimationViewController: UIViewController {
    
    let rightToLeft = TransitionAnimator(animatorType: .rightToLeft, hasBackground: true)
    
    let leftToRight = TransitionAnimator(animatorType: .leftToRight, hasBackground: true)
    let bottomToTop = TransitionAnimator(animatorType: .bottomToTop, hasBackground: true)
    let topTobottom = TransitionAnimator(animatorType: .topTobottom, hasBackground: true)
    let scaleCenter = TransitionAnimator(animatorType: .scaleCenter(startScale: 0.0,endScale: 1.1,finalScale: 1.0,dismissScale: 0.5,startAlpha: 0.0,endAlpha: 1.0), hasBackground: true)
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
    
    func createVC(_ animator:TransitionAnimator){
        let vc = UIStoryboard(name: "TestStoryboard", bundle: nil).instantiateViewController(identifier: "TestAnimatored")
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = animator
        present(vc, animated: true, completion: nil)
//        navigationController?.pushViewController(vc, animated: true)
    }
}
