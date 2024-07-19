//
//  MainViewController.swift
//  VKWeather
//
//  Created by Анна on 17.07.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    var weatherCollectionView: UICollectionView!
    var currentWeatherView: UIView!
    var backgroundImageView: UIImageView!
    var rainEmitterLayer: RainEmitterLayer?
    var animationContainerView: UIView!
    
    let weatherTypes: [WeatherType] = [.clear, .cloudy, .overcast, .rain, .thunderstorm, .rainbow]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImageView()
        setupCollectionView()
        setupCurrentWeatherView()
        setupAnimationContainerView()
        displayRandomWeather()
    }
    
    func setupBackgroundImageView() {
        backgroundImageView = UIImageView(frame: .zero)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        weatherCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        weatherCollectionView.register(WeatherCell.self, forCellWithReuseIdentifier: "WeatherCell")
        weatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        weatherCollectionView.backgroundColor = .clear
        weatherCollectionView.layer.cornerRadius = 24
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = weatherCollectionView.bounds
        weatherCollectionView.backgroundView = blurView
        
        view.addSubview(weatherCollectionView)
        
        NSLayoutConstraint.activate([
            weatherCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weatherCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weatherCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weatherCollectionView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    func setupCurrentWeatherView() {
        currentWeatherView = UIView()
        currentWeatherView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentWeatherView)
        
        NSLayoutConstraint.activate([
            currentWeatherView.topAnchor.constraint(equalTo: weatherCollectionView.bottomAnchor),
            currentWeatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentWeatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currentWeatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupAnimationContainerView() {
        animationContainerView = UIView()
        animationContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(animationContainerView, belowSubview: weatherCollectionView)
        
        NSLayoutConstraint.activate([
            animationContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            animationContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func displayRandomWeather() {
        let randomWeather = weatherTypes.randomElement()!
        displayWeather(randomWeather)
    }
    
    func displayWeather(_ weather: WeatherType) {
        updateBackgroundImage(for: weather)
        
        if weather == .rain {
            startRainAnimation()
        } else {
            stopRainAnimation()
        }
    }
    
    func updateBackgroundImage(for weather: WeatherType) {
        var backgroundImageName: String

        switch weather {
        case .clear:
            backgroundImageName = "backSUI"
        case .cloudy:
            backgroundImageName = "back2"
        case .overcast:
            backgroundImageName = "backSUI"
        case .rain:
            backgroundImageName = "rainBack"
        case .thunderstorm:
            backgroundImageName = "backSUI"
        case .rainbow:
            backgroundImageName = "backSUI"
        }

        if let backgroundImage = UIImage(named: backgroundImageName) {
            UIView.transition(with: self.backgroundImageView,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                self?.backgroundImageView.image = backgroundImage
            }, completion: nil)
        }
       
    }

    func startRainAnimation() {
        if rainEmitterLayer == nil {
            let rainLayer = RainEmitterLayer()
            rainLayer.frame = animationContainerView.bounds
            animationContainerView.layer.addSublayer(rainLayer)
            rainEmitterLayer = rainLayer
        }
    }
    
    func stopRainAnimation() {
        rainEmitterLayer?.removeFromSuperlayer()
        rainEmitterLayer = nil
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        let weatherType = weatherTypes[indexPath.item]
        cell.configure(with: weatherType)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedWeather = weatherTypes[indexPath.item]
        displayWeather(selectedWeather)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}



#Preview {
    MainViewController()
}
