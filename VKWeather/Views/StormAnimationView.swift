//
//  StormAnimationView.swift
//  VKWeather
//
//  Created by Анна on 20.07.2024.
//

import UIKit

final class StormAnimationView: UIView {
    
    //MARK: - Private Properties
    private var lightningLayer: CAShapeLayer!
    private var lightningGlowLayer: CAShapeLayer!
    private var flashView: UIView!
    private var isAnimating = false
    private var rainEmitterLayer: CAEmitterLayer?
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLightningLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLightningLayers()
    }
    
    //MARK: - Methods
    // Настройка слоев молний
    private func setupLightningLayers() {
        flashView = UIView(frame: bounds)
        flashView.backgroundColor = .white
        flashView.alpha = 0.0
        addSubview(flashView)
        
        lightningLayer = CAShapeLayer()
        lightningLayer.strokeColor = UIColor.white.cgColor
        lightningLayer.lineWidth = 2.4
        lightningLayer.lineJoin = .round
        lightningLayer.lineCap = .round
        lightningLayer.fillColor = UIColor.clear.cgColor
        lightningLayer.shadowColor = UIColor.white.cgColor
        lightningLayer.shadowRadius = 20
        lightningLayer.shadowOpacity = 1.0
        layer.addSublayer(lightningLayer)
        
        lightningGlowLayer = CAShapeLayer()
        lightningGlowLayer.strokeColor = UIColor.white.cgColor
        lightningGlowLayer.lineWidth = 4.0
        lightningGlowLayer.lineJoin = .round
        lightningGlowLayer.lineCap = .round
        lightningGlowLayer.fillColor = UIColor.clear.cgColor
        lightningGlowLayer.opacity = 0.0
        lightningGlowLayer.shadowColor = UIColor.white.cgColor
        lightningGlowLayer.shadowRadius = 25
        lightningGlowLayer.shadowOpacity = 1.0
        layer.addSublayer(lightningGlowLayer)
    }
    
    /// запуск анимации молнии
    func startLightningAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        animateLightning()
    }
    
    /// остановка анимации молнии
    func stopLightningAnimation() {
        isAnimating = false
        lightningLayer.path = nil
        lightningGlowLayer.path = nil
        flashView.alpha = 0.0
    }
    
    /// анимация молний
    private func animateLightning() {
        guard isAnimating else { return }
        
        let lightningPath = createLightningPath()
        lightningLayer.path = lightningPath.cgPath
        
        flash()
        
        let disappearAnimation = CABasicAnimation(keyPath: "opacity")
        disappearAnimation.fromValue = 1
        disappearAnimation.toValue = 0
        disappearAnimation.duration = 1.0
        disappearAnimation.beginTime = CACurrentMediaTime() + 0.5
        disappearAnimation.isRemovedOnCompletion = false
        disappearAnimation.fillMode = .forwards
        lightningLayer.add(disappearAnimation, forKey: "opacity")
        
        let glowDisappearAnimation = CABasicAnimation(keyPath: "opacity")
        glowDisappearAnimation.fromValue = 0.8
        glowDisappearAnimation.toValue = 0.0
        glowDisappearAnimation.duration = 1.0
        glowDisappearAnimation.beginTime = CACurrentMediaTime()
        glowDisappearAnimation.isRemovedOnCompletion = false
        glowDisappearAnimation.fillMode = .forwards
        lightningGlowLayer.add(glowDisappearAnimation, forKey: "glowOpacity")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            self.animateLightning()
        }
    }
    
    /// cоздание молнии
    private func createLightningPath() -> UIBezierPath {
        let path = UIBezierPath()
        let startX = bounds.midX
        let startY: CGFloat = 0
        path.move(to: CGPoint(x: startX, y: startY))
        
        let segments = 15
        let segmentHeight = bounds.height / CGFloat(segments)
        
        for i in 0..<segments {
            let endX = startX + CGFloat(arc4random_uniform(100)) - 50
            let endY = startY + segmentHeight * CGFloat(i + 2)
            path.addLine(to: CGPoint(x: endX, y: endY))
        }
        return path
    }
    
    /// cоздание вспышки
    private func flash() {
        UIView.animate(withDuration: 0.1, animations: {
            self.flashView.alpha = 0.6
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.flashView.alpha = 0.0
            })
        })
    }
  
    // MARK: - Rain Animation
    func startRainAnimation() {
        stopRainAnimation()
        let emitterLayer = configureRainEmitter()
        layer.addSublayer(emitterLayer)
        self.rainEmitterLayer = emitterLayer
    }
    
    func stopRainAnimation() {
        rainEmitterLayer?.removeFromSuperlayer()
        rainEmitterLayer = nil
    }
    
    /// создание дождя отличного от RainEmitter
    private func configureRainEmitter() -> CAEmitterLayer {
        let layer = CAEmitterLayer()
        layer.emitterShape = .line
        layer.emitterPosition = CGPoint(x: bounds.width / 2, y: -10)
        layer.emitterSize = CGSize(width: bounds.width, height: 1)
        layer.emitterCells = [createRainEmitterCell()]
        return layer
    }
    
    private func createRainEmitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "drop")!.cgImage
        cell.birthRate = 190
        cell.lifetime = 7.0
        cell.velocity = 1000
        cell.velocityRange = 400
        cell.emissionLongitude = .pi
        cell.scale = 0.025
        cell.scaleRange = 0.16
        return cell
    }
}
