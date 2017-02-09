//
//  WeatherGetter.swift
//  Where am I?
//
//  Created by Alexander on 06.02.17.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

protocol WeatherGetterDelegate {
    func didGetWeather(weather: Weather)
    func didNotGetWeather(error: NSError)
}

class WeatherGetter {
    private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let openWeatherAPIKey = "542e5ad414c3d002f9abb19c97cfe1f9"
    
    private var delegate: WeatherGetterDelegate
    
    init(delegate: WeatherGetterDelegate) {
        self.delegate = delegate
    }
    
    func getWeatherByCoordinates(latitude: Double, longitude: Double) {
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherAPIKey)&lat=\(latitude)&lon=\(longitude)")
        getWeather(weatherRequestURL: weatherRequestURL!)
    }
    
    func getWeather(weatherRequestURL: URL) {
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 3
        
        let dataTask = session.dataTask(with: weatherRequestURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if let networkError = error {
                self.delegate.didNotGetWeather(error: networkError as NSError)
            } else {
                do {
                    let weatherData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                    let weather = Weather(weatherData: weatherData)
                    self.delegate.didGetWeather(weather: weather)
                } catch let jsonError as NSError {
                    self.delegate.didNotGetWeather(error: jsonError)
                }
            }
        }
        
        dataTask.resume()
    }
}
