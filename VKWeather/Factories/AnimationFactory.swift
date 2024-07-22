//
//  AnimationFactory.swift
//  VKWeather
//
//  Created by Анна on 22.07.2024.
//

import UIKit

final class AnimationFactory {
    static func createAnimation(for weather: WeatherType) -> AnimationConfigurable? {
        switch weather {
        case .clear:
            return SunAnimation()
        case .storm:
            return StormAnimation()
        case .rain:
            return RainEmitter()
        case .overcast:
            return CloudEmitter()
        case .snow:
            return SnowEmitter()
        default:
            return FogEmitter()
        }
    }
}
