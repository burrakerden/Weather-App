//
//  MainViewModel.swift
//  Weather1
//
//  Created by Burak Erden on 18.01.2023.
//

import Foundation
import UIKit

class MainViewModel {
    
    var main: Main?
    var weather = [Weather]()
    
    func cities(coordinate: String, image: UIImageView, condition: UILabel) {
        Service().getWeatherData(coordinate: coordinate) { result in
            guard let result1 = result?.main else {return}
            self.main = result1
            guard let result2 = result?.weather else {return}
            self.weather = result2
            self.getCity(image: image, condition: condition)
        } onError: { error in
            print(error)
        }
    }
    
    func getCity(image: UIImageView, condition: UILabel) {
        let icon = weather[0].icon ?? ""
        let imageBaseUrl = "http://openweathermap.org/img/wn/\(icon)@2x.png"
        image.downloaded(from: imageBaseUrl, contentMode: .center)
        let degree = String(format: "%.0f", (main?.temp)!) + "°"
        if let weather = weather[0].main {
            condition.text = degree + weather
        }
    }
    
}
