//
//  StormAnimation.swift
//  VKWeather
//
//  Created by Анна on 22.07.2024.
//

import UIKit

final class StormAnimation: AnimationConfigurable {
    
    //MARK: - Private Properties
    private var stormView: StormAnimationView?
    
    //MARK: - AnimationConfigurable
    func startAnimation(in view: UIView) {
        if stormView == nil {
            stormView = StormAnimationView(frame: view.bounds)
            view.addSubview(stormView!)
            stormView?.startLightningAnimation()
            stormView?.startRainAnimation()
        }
    }
    
    func stopAnimation() {
        stormView?.stopLightningAnimation()
        stormView?.stopRainAnimation()
        stormView?.removeFromSuperview()
        stormView = nil
    }
}

