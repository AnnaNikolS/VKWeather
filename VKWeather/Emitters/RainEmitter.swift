//
//  RainEmitter.swift
//  VKWeather
//
//  Created by Анна on 22.07.2024.
//

import UIKit

final class RainEmitter: EmitterConfigurable, AnimationConfigurable {
    
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
        cell.contents = UIImage(named: "drop")!.cgImage
        cell.birthRate = 120
        cell.lifetime = 7.0
        cell.velocity = 700
        cell.velocityRange = 400
        cell.emissionLongitude = .pi
        cell.scale = 0.025
        cell.scaleRange = 0.16
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
