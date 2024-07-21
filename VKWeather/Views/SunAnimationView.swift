//
//  SunAnimationView.swift
//  VKWeather
//
//  Created by Анна on 20.07.2024.
//

import UIKit

final class SunAnimationView: UIView {
    
    //MARK: - Private Properties
    private let sunImageView = UIImageView(image: UIImage(named: "sun"))
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSunImageView()
        setupRotationAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSunImageView()
        setupRotationAnimation()
    }
    
    //MARK: - Private Methods
    private func setupSunImageView() {
        sunImageView.contentMode = .scaleAspectFill
        sunImageView.frame = CGRect(x: -400, y: -20, width: 1200, height: 800)
        addSubview(sunImageView)
    }
    
    /// установка анимации вращения
    private func setupRotationAnimation() {
        let rotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.values = [1.5, CGFloat.pi / 1.5, 1.5]
        rotationAnimation.keyTimes = [0, 0.5, 1]
        rotationAnimation.duration = 25
        rotationAnimation.repeatCount = .infinity
        
        sunImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
}
