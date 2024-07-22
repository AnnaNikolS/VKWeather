//
//  SunAnimation.swift
//  VKWeather
//
//  Created by Анна on 22.07.2024.
//

import UIKit

final class SunAnimation: AnimationConfigurable {
    
    //MARK: - Private Properties
    private var sunView: SunAnimationView?
    
    //MARK: - AnimationConfigurable
    func startAnimation(in view: UIView) {
        if sunView == nil {
            sunView = SunAnimationView(frame: view.bounds)
            view.addSubview(sunView!)
        }
    }
    
    func stopAnimation() {
        sunView?.removeFromSuperview()
        sunView = nil
    }
}
