//
//  FogEmitterLayer.swift
//  VKWeather
//
//  Created by Анна on 21.07.2024.
//

import UIKit

final class FogEmitterLayer: CAEmitterLayer {
    
    override init() {
        super.init()
        setupEmitter()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupEmitter()
    }
    
    private func setupEmitter() {
        emitterShape = .line
        emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: -10)
        emitterSize = CGSize(width: UIScreen.main.bounds.width, height: 1)
        emitterCells = [createFogCell()]
    }
    
    private func createFogCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "Ellipse5")?.cgImage
        cell.birthRate = 0.3
        cell.lifetime = 150
        cell.velocity = 0.3
        cell.velocityRange = 0.05
        cell.emissionLongitude = .pi
        cell.scale = 0.45
        cell.yAcceleration = 0.2
        
        return cell
    }
}
