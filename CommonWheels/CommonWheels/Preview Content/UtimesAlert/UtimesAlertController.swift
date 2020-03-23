//
//  UtimesAlertController.swift
//  chezhu
//
//  Created by Allen long on 2018/11/24.
//  Copyright © 2018 Allen long. All rights reserved.
//

import UIKit

protocol UtimesAlertControllerDelegate: class {
    func didTapLeft(on controller: UtimesAlertController)
    func didTapRight(on controller: UtimesAlertController)
}

extension UtimesAlertControllerDelegate {
    func didTapLeft(on controller: UtimesAlertController) {}
    func didTapRight(on controller: UtimesAlertController) {}
}

class UtimesAlertController: UIViewController {

//    let animator = popoverAnimator(animatorType: .scaleCenter, hasBackground: true)

    var alertTitle: String
    var alertDesc: String
    var leftBtnTitle: String
    var rightBtnTitle: String
    var isSingleBtn: Bool
    var showBackground: Bool
    var extraConfig: (()->())?
    
    var leftTapClosure: (()->())?
    var rightTapClosure: (()->())?
    
    weak var delegate: UtimesAlertControllerDelegate?
    
    init(title: String = "提示", desc: String = "", leftTitle: String = "取消", rightTitle: String = "确定", extraConfig: (()->())? = nil, isSingleBtn: Bool = false, showBackground: Bool = true) {
        self.alertTitle = title
        self.alertDesc = desc
        self.leftBtnTitle = leftTitle
        self.rightBtnTitle = rightTitle
        self.extraConfig = extraConfig
        self.isSingleBtn = isSingleBtn
        self.showBackground = showBackground
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        modalPresentationStyle = .custom
//        transitioningDelegate = animator
        view.addSubview(alertView)
        configAlertViewFrame()
        configAlertViewContent()
        extraConfig?()
        
        alertView.leftAction = {[weak self] in
            guard let strongSelf = self else{ return }
            strongSelf.dismiss(animated: true, completion: nil)
            strongSelf.delegate?.didTapLeft(on: strongSelf)
            strongSelf.leftTapClosure?()
        }
        alertView.rightAction = {[weak self] in
            guard let strongSelf = self else{ return }
            strongSelf.dismiss(animated: true, completion: nil)
            strongSelf.delegate?.didTapRight(on: strongSelf)
            strongSelf.rightTapClosure?()
        }
        // Do any additional setup after loading the view.
    }
    
    func configAlertViewFrame() {
//        let width  = UIScreen.main.bounds.width * 270 / 375
////        let height: CGFloat = alertDesc.calculateHeightWith(width: width - 50, font: UIFont.regularSCFont(ofSize: 16)) + 155
//        let height: CGFloat = 300
//        //50是descLabel距离alertView左右边距之合，155是alertView除descLabel之外的基础高度
//        alertView.frame = CGRect.init(origin: CGPoint(x: (UIScreen.main.bounds.width - width)/2, y: (UIScreen.main.bounds.height - height)/2), size: CGSize(width: width, height: height))
//        alertView.center = self.view.center
//        alertView.frame.size = CGSize(width: UIScreen.main.bounds.width - 15 * 2, height: height)
//        alertView.center = self.view.center
        let margin:CGFloat = 40
        alertView.frame.size = CGSize(width: view.frame.width - (2 * margin), height: 300)
        alertView.center = view.center
    }
    
    func configAlertViewContent() {
        if isSingleBtn {
            alertView.changeUIForSingleBtn()
        }
    }

    lazy var alertView: UtimesAlertView = {
        let view = UtimesAlertView.loadViewFromNib()
        view.titleLabel.text = alertTitle
        view.descLabel.text = alertDesc
        view.center.x = view.center.x
        view.center.y = view.center.y
        view.leftBtn.setTitle(leftBtnTitle, for: .normal)
        view.rightBtn.setTitle(rightBtnTitle, for: .normal)
        return view
    }()
}
