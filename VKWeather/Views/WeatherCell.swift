//
//  WeatherCell.swift
//  VKWeather
//
//  Created by Анна on 17.07.2024.
//

import UIKit

final class WeatherCell: UICollectionViewCell {
    
    //MARK: - Properties
    let imageView = UIImageView()
    let label = UILabel()
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    /// установка отображения системных изображений в горизонтальной коллекции
    func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    /// установка лейбла погодного условия
    func setupLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            label.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    /// системные изображения
    func configure(with weatherType: WeatherType) {
        switch weatherType {
        case .clear:
            imageView.image = UIImage(systemName: "sun.max.fill")
            label.text = "Clear"
        case .overcast:
            imageView.image = UIImage(systemName: "smoke.fill")
            label.text = "Overcast"
        case .rain:
            imageView.image = UIImage(systemName: "cloud.heavyrain.fill")
            label.text = "Rain"
        case .thunderstorm:
            imageView.image = UIImage(systemName: "cloud.bolt.rain.fill")
            label.text = "Storm"
        }
    }
    
    /// цветовая настройка выбранного погодного условия в коллекции
    func setSelected(_ selected: Bool) {
        if selected {
            imageView.tintColor = .black
            label.textColor = .black
        } else {
            imageView.tintColor = .white
            label.textColor = .white
        }
    }
}
