//
//  RainEmitterLayer.swift
//  VKWeather
//
//  Created by Анна on 18.07.2024.
//

import UIKit

class RainEmitterLayer: CAEmitterLayer {
    
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
        emitterCells = [createEmitterCell()]
    }
    
    private func createEmitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        
        cell.contents = UIImage(named: "pngegg2")!.cgImage
        cell.birthRate = 120
        cell.lifetime = 7.0
        cell.velocity = 700
        cell.velocityRange = 400
        cell.emissionLongitude = .pi
        cell.scale = 0.025
        cell.scaleRange = 0.16
        return cell
    }
}
