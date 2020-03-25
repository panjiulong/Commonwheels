//
//  PresentAnimator.swift
//  HZX
//
//  Created by panjiulong on 2017/8/7.
//  Copyright © 2017年 panjiulong. All rights reserved.
//

import UIKit

struct AnimationConfig {
    typealias AnimationClourse = (_ transitionContext: UIViewControllerContextTransitioning) -> ()
    var prepareAnimation:AnimationClourse
    var presentedAnimation:AnimationClourse
    var presentedFinishAnimation:AnimationClourse
    var dismissedAnimation:AnimationClourse
    var dismissedFinishAnimation:AnimationClourse
    init(prepareAnimation:@escaping AnimationClourse,presentedAnimation:@escaping AnimationClourse,presentedFinishAnimation:@escaping AnimationClourse,dismissedAnimation:@escaping AnimationClourse,dismissedFinishAnimation:@escaping AnimationClourse) {
        self.prepareAnimation = prepareAnimation
        self.presentedAnimation = presentedAnimation
        self.presentedFinishAnimation = presentedFinishAnimation
        self.dismissedAnimation = dismissedAnimation
        self.dismissedFinishAnimation = dismissedFinishAnimation
    }
}

enum AnimatorType {
    case topTobottom
    case bottomToTop
    case leftToRight
    case rightToLeft
    case scaleCenter(startScale:CGFloat = 0.0,endScale:CGFloat = 1.0,finalScale:CGFloat = 1.0,dismissScale:CGFloat = 0.0,startAlpha:CGFloat = 0.0,endAlpha:CGFloat = 1.0)

    var animatorConfig:AnimationConfig{
        return AnimationConfig(prepareAnimation: {transitionContext in
                self.prepareAnimation(transitionContext)
        }, presentedAnimation: {transitionContext in
            self.presentedAnimation(transitionContext)
        },presentedFinishAnimation:{transitionContext in
            self.presentedFinishAnimation(transitionContext)
        },  dismissedAnimation: {transitionContext in
            self.dismissedAnimation(transitionContext)
        },dismissedFinishAnimation:{transitionContext in
            self.dismissedFinishAnimation(transitionContext)
        })
    }

    func prepareAnimation(_ transitionContext: UIViewControllerContextTransitioning){
        let presentedView = transitionContext.view(forKey: .to)!
        let frame = transitionContext.containerView.frame
        let width = frame.size.width
        let height = frame.size.height
        let x = frame.origin.x
        let y = frame.origin.y
        switch self {
        case .topTobottom:
            presentedView.frame = CGRect(x: x, y: -height, width: width, height:height)
        case .bottomToTop:
            presentedView.frame = CGRect(x: x, y: height, width: width, height:height)
        case .leftToRight:
            presentedView.frame = CGRect(x: -width, y: y, width: width, height:height)
        case .rightToLeft:
            presentedView.frame = CGRect(x: width, y: y, width: width, height:height)
        case let .scaleCenter(startScale,_,_,_,startAlpha,_):
            presentedView.frame = presentedView.bounds
            presentedView.alpha = startAlpha
            presentedView.transform = CGAffineTransform(scaleX: startScale, y: startScale)
        }
    }

    func presentedAnimation(_ transitionContext: UIViewControllerContextTransitioning){
        let presentedView = transitionContext.view(forKey: .to)!
        switch self {
        case .topTobottom:
            presentedView.frame.origin.y = 0.0
        case .bottomToTop:
            presentedView.frame.origin.y = 0.0
        case .leftToRight:
            presentedView.frame.origin.x = 0.0
        case .rightToLeft:
            presentedView.frame.origin.x = 0.0
        case let .scaleCenter(_,endScale,_,_,_,endAlpha):
            presentedView.transform = CGAffineTransform(scaleX: endScale, y: endScale)
            presentedView.alpha = endAlpha
        }
    }


    func  presentedFinishAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        let presentedView = transitionContext.viewController(forKey: .to)!
        switch self {
        case let .scaleCenter(_,_,finalScale,_,_,_):
            UIView.animate(withDuration: 0.1, animations: {
                presentedView.view.transform = CGAffineTransform(scaleX: finalScale, y: finalScale)
            }, completion: { (completed) in
                transitionContext.completeTransition(completed)
            })
        default:
            transitionContext.completeTransition(true)
        }
    }

    func dismissedAnimation(_ transitionContext: UIViewControllerContextTransitioning){
        let dismissView = transitionContext.view(forKey: .from)!
        switch self {
        case .topTobottom:
            dismissView.frame.origin.y = -transitionContext.containerView.frame.height
        case .bottomToTop:
            dismissView.frame.origin.y = transitionContext.containerView.frame.height
        case .leftToRight:
            dismissView.frame.origin.x = -transitionContext.containerView.frame.width
        case .rightToLeft:
            dismissView.frame.origin.x = transitionContext.containerView.frame.width
        case let .scaleCenter(_,_,_,dismissScale,startAlpha,_):
            dismissView.transform = CGAffineTransform(scaleX: dismissScale, y: dismissScale)
            dismissView.alpha = startAlpha
        }
    }
    func dismissedFinishAnimation(_ transitionContext: UIViewControllerContextTransitioning){
        let dismissView = transitionContext.view(forKey: .from)!
        dismissView.removeFromSuperview()
        transitionContext.completeTransition(true)
    }
}

class TransitionAnimator: NSObject {
    var animatorType:AnimatorType
    var hasBackground:Bool
    var duration:TimeInterval
    var animationConfig:AnimationConfig?
    init(animatorType:AnimatorType,hasBackground:Bool,duration:TimeInterval = 0.4,animationConfig:AnimationConfig? = nil) {
        self.animatorType = animatorType
        self.hasBackground = hasBackground
        self.duration = duration
        if let config = animationConfig {
            self.animationConfig = config
        }else{
            self.animationConfig = animatorType.animatorConfig
        }

    }
    private var isPresented : Bool = true
    lazy var backGroundView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0.01
        return view
    }()
}
extension TransitionAnimator:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

extension TransitionAnimator:UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext: transitionContext) : animationForDismissedView(transitionContext: transitionContext)
    }

    func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        let presentedView = transitionContext.view(forKey: .to)!
        transitionContext.containerView.addSubview(backGroundView)
        backGroundView.frame = transitionContext.containerView.bounds
        transitionContext.containerView.addSubview(presentedView)

        animationConfig?.prepareAnimation(transitionContext)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {[weak self] in
            guard let strongSelf = self else{ return }
            strongSelf.animationConfig?.presentedAnimation(transitionContext)
            if strongSelf.hasBackground{
                strongSelf.backGroundView.alpha = 1.0
            }else{
                strongSelf.backGroundView.alpha = 0.01
            }

        }) { [weak self] (_) in
            self?.animationConfig?.presentedFinishAnimation(transitionContext)
        }
    }

    func animationForDismissedView(transitionContext: UIViewControllerContextTransitioning) {
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {[weak self] in
            self?.animationConfig?.dismissedAnimation(transitionContext)
            self?.backGroundView.alpha = 0.01
        }) {[weak self] (_) in
            self?.animationConfig?.dismissedFinishAnimation(transitionContext)
            self?.backGroundView.removeFromSuperview()
        }
    }
}
