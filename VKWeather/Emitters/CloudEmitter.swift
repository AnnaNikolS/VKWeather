//
//  CloudEmitter.swift
//  VKWeather
//
//  Created by Анна on 22.07.2024.
//

import UIKit

final class CloudEmitter: EmitterConfigurable, AnimationConfigurable {
    
    //MARK: - Private Properties
    private var emitterLayer: CAEmitterLayer?
    
    //MARK: - Methods
    func configure() -> CAEmitterLayer {
        let layer = CAEmitterLayer()
        layer.emitterShape = .rectangle
        layer.emitterSize = CGSize(width: 1, height: UIScreen.main.bounds.height)
        layer.emitterPosition = CGPoint(x: UIScreen.main.bounds.width + 500, y: UIScreen.main.bounds.height / 2 - 100)
        layer.emitterCells = [createEmitterCell()]
        return layer
    }
    
    private func createEmitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "cloud")!.cgImage
        cell.birthRate = 0.5
        cell.lifetime = 80.0
        cell.velocityRange = 1
        cell.emissionLongitude = .pi
        cell.scale = 0.25
        cell.scaleRange = 0.2
        cell.xAcceleration = -0.5
        cell.yAcceleration = 0
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

