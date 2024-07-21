//
//  SnowEmitterLayer.swift
//  VKWeather
//
//  Created by Анна on 21.07.2024.
//

import UIKit

final class SnowEmitterLayer: CAEmitterLayer {
    
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
        emitterShape = .line
        emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: -10)
        emitterSize = CGSize(width: UIScreen.main.bounds.width, height: 1)
        emitterCells = [createEmitterCell()]
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
}
