//
//  Service.swift
//  MovieAppXib
//
//  Created by Burak Erden on 10.01.2023.
//

import Alamofire

protocol GetCoord {
    func getCoordData(cityName: String, onSuccess: @escaping (CoordApi?) -> Void, onError: @escaping (AFError) -> Void)
}

final class CoordService: GetCoord {
    func getCoordData(cityName: String, onSuccess: @escaping (CoordApi?) -> Void, onError: @escaping (Alamofire.AFError) -> Void) {
        ServiceManager.shared.fetch(path: "http://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=1&appid=3cd46c43d81fd309b083f8ab55910200") { (response: CoordApi) in
            onSuccess(response)
        } onError: { (error) in
            onError(error)
        }
    }
}





