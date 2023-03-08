//
//  Service.swift
//  MovieAppXib
//
//  Created by Burak Erden on 10.01.2023.
//

import Alamofire

protocol ServiceProtocol {
    func getWeatherData(coordinate: String, onSuccess: @escaping (WeatherApi?) -> Void, onError: @escaping (AFError) -> Void)
}

final class Service: ServiceProtocol {
    func getWeatherData(coordinate: String, onSuccess: @escaping (WeatherApi?) -> Void, onError: @escaping (Alamofire.AFError) -> Void) {
        ServiceManager.shared.fetch(path: "https://api.openweathermap.org/data/2.5/weather?\(coordinate)&appid=3cd46c43d81fd309b083f8ab55910200&units=metric") { (response: WeatherApi) in
            onSuccess(response)
        } onError: { (error) in
            onError(error)
        }
    }
}
