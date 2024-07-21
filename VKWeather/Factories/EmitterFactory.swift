//
//  EmitterFactory.swift
//  VKWeather
//
//  Created by Анна on 22.07.2024.
//

import UIKit

final class EmitterFactory {
    static func createEmitter(of type: WeatherType) -> CAEmitterLayer? {
        switch type {
        case .rain:
            return RainEmitter().configure()
        case .overcast:
            return CloudEmitter().configure()
        case .snow:
            return SnowEmitter().configure()
        case .fog:
            return FogEmitter().configure()
        default:
            return nil
        }
    }
}
