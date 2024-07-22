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
    private var rainEmitter: RainEmitter?
    
    //MARK: - Methods
    func startAnimation(in view: UIView) {
        if stormView == nil {
            stormView = StormAnimationView(frame: view.bounds)
            view.addSubview(stormView!)
            stormView?.startLightningAnimation()
        }
        
        if rainEmitter == nil {
            rainEmitter = RainEmitter()
            rainEmitter?.startAnimation(in: view)
        }
    }
    
    func stopAnimation() {
        stormView?.stopLightningAnimation()
        stormView?.removeFromSuperview()
        stormView = nil
        
        rainEmitter?.stopAnimation()
        rainEmitter = nil
    }
}
