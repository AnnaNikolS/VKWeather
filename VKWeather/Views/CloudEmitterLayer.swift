//
//  CloudEmitterLayer.swift
//  VKWeather
//
//  Created by Анна on 20.07.2024.
//

import UIKit

final class CloudEmitterLayer: CAEmitterLayer {
    
    //MARK: - Initializer
    override init() {
        super.init()
        setupEmitter()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupEmitter()
    }
    
    //MARK: - Private Methods
    private func setupEmitter() {
        emitterShape = .rectangle
        emitterSize = CGSize(width: 1, height: UIScreen.main.bounds.height)
        emitterPosition = CGPoint(x: UIScreen.main.bounds.width + 500, y: UIScreen.main.bounds.height / 2 - 100)
        emitterCells = [createEmitterCell()]
        print("Emitter set up with position \(emitterPosition) and size \(emitterSize)")
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
}
