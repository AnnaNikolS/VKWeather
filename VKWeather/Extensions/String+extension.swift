//
//  String+extension.swift
//  VKWeather
//
//  Created by Анна on 21.07.2024.
//

import Foundation

extension String {
    
    var localized: String {
        NSLocalizedString(
            self,
            comment: "\(self) could not be found in localizable.strings"
        )
    }
}
