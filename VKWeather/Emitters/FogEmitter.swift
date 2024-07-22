//
//  FogEmitter.swift
//  VKWeather
//
//  Created by Анна on 22.07.2024.
//

import UIKit

final class FogEmitter: EmitterConfigurable, AnimationConfigurable {
    
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
        cell.contents = UIImage(named: "fogParticle")?.cgImage
        cell.birthRate = 0.3
        cell.lifetime = 150
        cell.velocity = 0.3
        cell.velocityRange = 0.05
        cell.emissionLongitude = .pi
        cell.scale = 0.45
        cell.yAcceleration = 0.2
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

