//
//  DetainViewController.swift
//  Weather1
//
//  Created by Burak Erden on 11.01.2023.
//

import UIKit
import Lottie

class DetailViewController: UIViewController {
    
    var cityNameHolder: CoordApi?
    var main: Main?
    var wind: Wind?
    var weather = [Weather]()
    
    let coordService = CoordService()
    let service = Service()
    
    private var animationView: LottieAnimationView!
    
    var cityName = ""
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var animation: UIView!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var fellsLike: UILabel!
    @IBOutlet weak var hummidity: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        navigationController?.isNavigationBarHidden = false
        date()
        getCoordData(cityName: cityName)
    }

    func getCoordData(cityName: String) {
        coordService.getCoordData(cityName: cityName) { result in
            guard let cName = result else {return}
            if cName.count == 0 {
                let ac = UIAlertController(title: "Error", message: "Enter valid city name.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(ac, animated: true)
            } else {
                self.cityNameHolder = cName
                let lat = String(format: "%.2f", (self.cityNameHolder?[0].lat)!)
                let lon = String(format: "%.2f", (self.cityNameHolder?[0].lon)!)
                let coordinants = "lat=\(lat)&lon=\(lon)"
                self.getData(coordinate: coordinants)
            }
        } onError: { error in
            print(error)
        }
    }
    
    func getData(coordinate: String) {
        service.getWeatherData(coordinate: coordinate) { result in
            var iconID = ""
            guard let result1 = result?.main else {return}
            self.main = result1
            guard let result2 = result?.weather else {return}
            self.weather = result2
            iconID = self.weather[0].icon ?? "50d"
            guard let result3 = result?.wind else {return}
            self.wind = result3
            self.setupDetailPage()
            self.setupAnimationView(iconID: iconID)
            print(iconID)
        } onError: { error in
            print(error)
        }
    }
    
    func setupDetailPage() {
        locationLabel.text = cityName.replacingOccurrences(of: "+", with: " ").capitalized + " " + (cityNameHolder?[0].country ?? "")
        weatherDescription.text = weather[0].description?.capitalized
        temp.text = String(format: "%.0f", (main?.temp)!) + "°"
        maxTemp.text = String(format: "%.0f", (main?.tempMax)!) + "°" + " /"
        minTemp.text = String(format: "%.0f", (main?.tempMin)!) + "°"
        fellsLike.text = "Feels Like: " + String(format: "%.0f", (main?.feelsLike)!) + "°"
        hummidity.text = "Humidity: %" + String((main?.humidity)!)
        pressure.text = "Pressure: " + String((main?.pressure)!) + " hPa"
        windSpeed.text = "Wind Speed: " + String(format: "%.1f", (wind?.speed)!) + " km/h"
    }

    func date() {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        let result = formatter.string(from: currentDate)
        dateLabel.text = result
    }
    
    func setupAnimationView(iconID: String) {
        
        var animationName = ""

        switch iconID {
        case "01d":
            animationName = "1d"
        case "01n":
            animationName = "1n"
        case "02d":
            animationName = "2d"
        case "02n":
            animationName = "2n"
        case "3d", "3n", "4d", "4n":
            animationName = "3d-3n-4d-4n"
        case "09d", "10d":
            animationName = "9d-10d"
        case "09n", "10n":
            animationName = "9n-10n"
        case "11d":
            animationName = "11d"
        case "11n":
            animationName = "11n"
        case "13d":
            animationName = "13d"
        case "13n":
            animationName = "13n"
        case "50d", "50n":
            animationName = "50d-50n"
        default:
            print("Have you done something new?")
        }
        
        animationView = .init(name: animationName)
        animationView.frame = animation.bounds
        animationView.loopMode = .loop
        animation.addSubview(animationView)
        animationView.play()
    }
    
}
