//
//  UtimesAlertView.swift
//  chezhu
//
//  Created by Allen long on 2018/11/24.
//  Copyright © 2018 Allen long. All rights reserved.
//

import UIKit

class UtimesAlertView: UIView,NibLoadable {
    
    var leftAction: (()->())?
    var rightAction: (()->())?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    
    @IBAction func leftBtnClick(_ sender: UIButton) {
        leftAction?()
    }
    @IBAction func rightBtnClick(_ sender: UIButton) {
        rightAction?()
    }
    
    func changeUIForSingleBtn() {
        leftBtn.removeFromSuperview()
        rightBtn.setTitle("知道了", for: .normal)
    }
    
}

protocol NibLoadable {}

extension NibLoadable where Self: UIView {
    static func loadViewFromNib() -> Self {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as! Self
    }
}

