//
//  MainViewController.swift
//  VKWeather
//
//  Created by Анна on 17.07.2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    //MARK: - Private Properties
    private var weatherCollectionView: UICollectionView!
    private var currentWeatherView: UIView!
    private var backgroundImageView: UIImageView!
    private var animationContainerView: UIView!
    private var selectedIndexPath: IndexPath?
    
    private var rainEmitterLayer: RainEmitterLayer?
    private var cloudEmitterLayer: CloudEmitterLayer?
    private var snowEmitterLayer: SnowEmitterLayer?
    private var stormAnimationView: StormAnimationView?
    private var sunAnimationView: SunAnimationView?
    private var fogEmitterLayer: FogEmitterLayer?
    
    private let weatherTypes: [WeatherType] = [.clear, .overcast, .rain, .storm, .snow, .wind]
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImageView()
        setupCollectionView()
        setupCurrentWeatherView()
        setupAnimationContainerView()
        displayRandomWeather()
    }
    
    //MARK: - Methods
    /// установка фонового изображения
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
    
    /// настройка коллекции
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
        
        /// блюр эффект для плашки с коллекцией
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = weatherCollectionView.bounds
        weatherCollectionView.backgroundView = blurView
        
        view.addSubview(weatherCollectionView)
        
        NSLayoutConstraint.activate([
            weatherCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weatherCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weatherCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weatherCollectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    /// установка текущих погодных условий
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
        animationContainerView = UIView(frame: view.bounds)
        animationContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(animationContainerView, belowSubview: weatherCollectionView)
        
        NSLayoutConstraint.activate([
            animationContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            animationContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// установка рандомной погоды
    func displayRandomWeather() {
        let randomWeather = weatherTypes.randomElement()!
        if let index = weatherTypes.firstIndex(of: randomWeather) {
            selectedIndexPath = IndexPath(item: index, section: 0)
        }
        displayWeather(randomWeather, isRandom: true)
    }
    
    func displayWeather(_ weather: WeatherType, isRandom: Bool = false) {
        updateBackgroundImage(for: weather)
        
        // Управление анимацией дождя
        if weather == .rain || weather == .storm {
            startRainAnimation()
        } else {
            stopRainAnimation()
        }
        
        // Управление анимацией молнии
        if weather == .storm {
            startThunderstormAnimation()
        } else {
            stopThunderstormAnimation()
        }
        
        // Управление анимацией облаков
        if weather == .overcast {
            startCloudAnimation()
        } else {
            stopCloudAnimation()
        }
        
        if weather == .clear {
            startSunAnimation()
        } else {
            stopSunAnimation()
        }
        
        if weather == .snow {
            startSnowAnimation()
        } else {
            stopSnowAnimation()
        }
        
        if weather == .wind {
            startFogAnimation()
        } else {
            stopFogAnimation()
        }
        
        // Перезагрузка коллекции и прокрутка к выбранному элементу, если это рандомный выбор
        weatherCollectionView.reloadData()
        if isRandom, weather == .snow || weather == .wind {
            DispatchQueue.main.async {
                // Прокрутка до последнего элемента коллекции
                let lastItemIndex = IndexPath(item: self.weatherTypes.count - 1, section: 0)
                self.weatherCollectionView.scrollToItem(at: lastItemIndex, at: .right, animated: true)
            }
        } else if isRandom, let selectedIndexPath = selectedIndexPath {
            DispatchQueue.main.async {
                // Убедитесь, что коллекция перезагружена и элементы видимы
                let visibleIndexPaths = self.weatherCollectionView.indexPathsForVisibleItems
                if !visibleIndexPaths.contains(selectedIndexPath) {
                    self.weatherCollectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
    
    /// обновление фонового изображения
    func updateBackgroundImage(for weather: WeatherType) {
        var backgroundImageName: String
        
        switch weather {
        case .clear:
            backgroundImageName = "clearBack"
        case .overcast:
            backgroundImageName = "overcastBack"
        case .rain:
            backgroundImageName = "rainBack"
        case .storm:
            backgroundImageName = "thunderstormBack"
        case .snow:
            backgroundImageName = "snowBack"
        case .wind:
            backgroundImageName = "fogBack"
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
    
    /// анимация дождя
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
    
    /// анимация облаков
    func startCloudAnimation() {
        stopCloudAnimation()
        let cloudLayer = CloudEmitterLayer()
        cloudLayer.frame = animationContainerView.bounds
        animationContainerView.layer.addSublayer(cloudLayer)
        cloudEmitterLayer = cloudLayer
    }
    
    func stopCloudAnimation() {
        cloudEmitterLayer?.removeFromSuperlayer()
        cloudEmitterLayer = nil
    }
    
    /// анимация молнии
    func startThunderstormAnimation() {
        if stormAnimationView == nil {
            let lightningView = StormAnimationView(frame: animationContainerView.bounds)
            animationContainerView.addSubview(lightningView)
            stormAnimationView = lightningView
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.stormAnimationView?.startLightningAnimation()
        }
    }
    
    func stopThunderstormAnimation() {
        stormAnimationView?.stopLightningAnimation()
        stormAnimationView?.removeFromSuperview()
        stormAnimationView = nil
    }
    
    /// анимация ясной погоды
    func startSunAnimation() {
        if sunAnimationView == nil {
            let sunView = SunAnimationView()
            animationContainerView.addSubview(sunView)
            sunAnimationView = sunView
        }
    }
    
    func stopSunAnimation() {
        sunAnimationView?.removeFromSuperview()
        sunAnimationView = nil
    }
    
    /// анимация снега
    func startSnowAnimation() {
        if snowEmitterLayer == nil {
            let snowLayer = SnowEmitterLayer()
            snowLayer.frame = animationContainerView.bounds
            animationContainerView.layer.addSublayer(snowLayer)
            snowEmitterLayer = snowLayer
        }
    }
    
    func stopSnowAnimation() {
        snowEmitterLayer?.removeFromSuperlayer()
        snowEmitterLayer = nil
    }
    
    func startFogAnimation() {
        if fogEmitterLayer == nil {
            let fogLayer = FogEmitterLayer()
            fogLayer.frame = animationContainerView.bounds
            animationContainerView.layer.addSublayer(fogLayer)
            fogEmitterLayer = fogLayer
        }
    }
    
    func stopFogAnimation() {
        fogEmitterLayer?.removeFromSuperlayer()
        fogEmitterLayer = nil
    }
}

//MARK: - MainViewController
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        let weatherType = weatherTypes[indexPath.item]
        cell.configure(with: weatherType)
        cell.setSelected(indexPath == selectedIndexPath)
        
        return cell
    }
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedWeather = weatherTypes[indexPath.item]
        displayWeather(selectedWeather)
        selectedIndexPath = indexPath
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if selectedIndexPath == indexPath {
            selectedIndexPath = nil
            collectionView.reloadData()
        }
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}

#Preview {
    MainViewController()
}
