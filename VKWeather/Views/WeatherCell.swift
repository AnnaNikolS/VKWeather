//
//  WeatherCell.swift
//  VKWeather
//
//  Created by Анна on 17.07.2024.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    
    //MARK: - Properties
    let imageView = UIImageView()
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 62)
        ])
    }
    
    func configure(with weatherType: WeatherType) {
        switch weatherType {
        case .clear:
            imageView.image = UIImage(systemName: "sun.max.fill")
        case .cloudy:
            imageView.image = UIImage(systemName: "cloud.sun.fill")
        case .overcast:
            imageView.image = UIImage(systemName: "smoke.fill")
        case .rain:
            imageView.image = UIImage(systemName: "cloud.heavyrain.fill")
        case .thunderstorm:
            imageView.image = UIImage(systemName: "cloud.bolt.rain.fill")
        case .rainbow:
            imageView.image = UIImage(systemName: "cloud.rainbow.half.fill")
        }
    }
}
