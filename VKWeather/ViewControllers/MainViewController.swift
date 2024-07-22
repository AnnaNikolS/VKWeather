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
    
    private var currentAnimation: AnimationConfigurable?
    
    private let weatherTypes: [WeatherType] = [.clear, .overcast, .rain, .storm, .snow, .fog]
    
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
        manageAnimations(for: weather)
        /// перезагрузка коллекции и прокрутка к выбранному элементу, если это рандомный выбор
        reloadAndScrollCollectionView(isRandom: isRandom, weather: weather)
    }
    
    private func manageAnimations(for weather: WeatherType) {
        currentAnimation?.stopAnimation()
        
        if let newAnimation = AnimationFactory.createAnimation(for: weather) {
            newAnimation.startAnimation(in: animationContainerView)
            currentAnimation = newAnimation
        }
    }
    
    /// прокручивание коллекции на элемент при рандомном выборе
    private func reloadAndScrollCollectionView(isRandom: Bool, weather: WeatherType) {
        weatherCollectionView.reloadData()
        
        if isRandom {
            if weather == .snow || weather == .fog {
                DispatchQueue.main.async {
                    let lastItemIndex = IndexPath(item: self.weatherTypes.count - 1, section: 0)
                    self.weatherCollectionView.scrollToItem(at: lastItemIndex, at: .right, animated: true)
                }
            } else if let selectedIndexPath = selectedIndexPath {
                DispatchQueue.main.async {
                    let visibleIndexPaths = self.weatherCollectionView.indexPathsForVisibleItems
                    if !visibleIndexPaths.contains(selectedIndexPath) {
                        self.weatherCollectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
                    }
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
            backgroundImageName = "stormBack"
        case .snow:
            backgroundImageName = "snowBack"
        case .fog:
            backgroundImageName = "fogBack"
        }
        
        /// анимационный переход
        if let backgroundImage = UIImage(named: backgroundImageName) {
            UIView.transition(with: self.backgroundImageView,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                self?.backgroundImageView.image = backgroundImage
            }, completion: nil)
        }
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
