//
//  Weather.swift
//  Where am I?
//
//  Created by Alexander on 06.02.17.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

struct Weather {
    
    var latitude: Double
    var longitude: Double
    
    let dateAndTime: Date
    let city: String
    
    let mainWeather: String
    let id: Int
    let humidity: Int
    let cloudCover: Int
    
    private let temp: Double
    var tempCelsius: Double {
        get {
            return temp - 273.15
        }
    }
    
    init(weatherData: [String:AnyObject]) {
        dateAndTime = Date(timeIntervalSince1970: weatherData["dt"] as! TimeInterval)
        city = weatherData["name"] as! String
        
        let coordDict = weatherData["coord"] as! [String: AnyObject]
        longitude = coordDict["lon"] as! Double
        latitude = coordDict["lat"] as! Double
        
        let weatherDict = weatherData["weather"]![0] as! [String: AnyObject]
        mainWeather = weatherDict["main"] as! String
        id = weatherDict["id"] as! Int
        cloudCover = weatherData["clouds"]!["all"] as! Int
        temp = weatherData["main"]!["temp"] as! Double
        humidity = weatherData["main"]!["humidity"] as! Int
    }
}
