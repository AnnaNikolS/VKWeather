//
//  SnowEmitter.swift
//  VKWeather
//
//  Created by Анна on 22.07.2024.
//

import UIKit

final class SnowEmitter: EmitterConfigurable, AnimationConfigurable {
    
    //MARK: - Private Properties
    private var emitterLayer: CAEmitterLayer?
    
    //MARK: - Methods
    func configure() -> CAEmitterLayer {
        let layer = CAEmitterLayer()
        layer.emitterShape = .line
        layer.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: -10)
        layer.emitterSize = CGSize(width: UIScreen.main.bounds.width, height: 1)
        layer.emitterCells = [createEmitterCell()]
        return layer
    }
    
    private func createEmitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "snowFlake")!.cgImage
        cell.birthRate = 25
        cell.lifetime = 7.0
        cell.velocity = 160
        cell.velocityRange = 70
        cell.emissionLongitude = .pi
        cell.scale = 0.018
        cell.scaleRange = 0.05
        return cell
    }
    
    //MARK: - AnimationConfigurable
    func startAnimation(in view: UIView) {
        stopAnimation()
        let layer = configure()
        view.layer.addSublayer(layer)
        self.emitterLayer = layer
    }
    
    func stopAnimation() {
        emitterLayer?.removeFromSuperlayer()
        emitterLayer = nil
    }
}

