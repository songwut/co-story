//
//  FlipPresentAnimationController.swift
//  GuessThePet
//
//  Created by Vesza Jozsef on 08/07/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class FlipPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  var originFrame = CGRectZero
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 0.6
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
        let containerView = transitionContext.containerView(),
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
        return
    }
    
    let initialFrame = originFrame
    let finalFrame = transitionContext.finalFrameForViewController(toVC)
    
    let snapshot = toVC.view.snapshotViewAfterScreenUpdates(true)
    
    snapshot.frame = initialFrame
    snapshot.layer.cornerRadius = 25
    snapshot.layer.masksToBounds = true
    
    containerView.addSubview(toVC.view)
    containerView.addSubview(snapshot)
    toVC.view.hidden = true
    
    AnimationHelper.perspectiveTransformForContainerView(containerView)
    
    //snapshot.layer.transform = AnimationHelper.yRotation(M_PI_2)
    snapshot.layer.transform = AnimationHelper.scale(1)
    
    let duration = transitionDuration(transitionContext)
    
    UIView.animateKeyframesWithDuration(
      duration,
      delay: 0,
      options: .CalculationModeCubic,
      animations: {
        /*
        UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1/3, animations: {
          //fromVC.view.layer.transform = AnimationHelper.yRotation(-M_PI_2)
            fromVC.view.layer.transform = AnimationHelper.scale(1)
        })
        
        UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 1/3, animations: {
          //snapshot.layer.transform = AnimationHelper.yRotation(0.0)
            fromVC.view.layer.transform = AnimationHelper.scale(2)
        })
         
        UIView.addKeyframeWithRelativeStartTime(2/3, relativeDuration: 1/3, animations: {
          snapshot.frame = finalFrame
        })
        */
        UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1, animations: {
            snapshot.frame = finalFrame
            snapshot.alpha = 0
        })
      },
      completion: { _ in
        toVC.view.hidden = false
        snapshot.removeFromSuperview()
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
      })
  }
}