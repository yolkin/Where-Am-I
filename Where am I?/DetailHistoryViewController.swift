//
//  DetailHistoryViewController.swift
//  Where am I?
//
//  Created by Alexander on 08.02.17.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import GoogleMaps

class DetailHistoryViewController: UIViewController {
    
    var weatherData: WeatherData?
    
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var mainWeatherLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MMM dd yyyy hh:mm:ss"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        
        if weatherData != nil {
            
            temperatureLabel.text  = "\(Int(round(weatherData!.temp)))°"
            humidityLabel.text     = "\(weatherData!.humidity)"
            cloudsLabel.text       = "\(weatherData!.clouds)"
            cityLabel.text         = weatherData!.city
            mainWeatherLabel.text  = weatherData!.mainWeather
            dateLabel.text         = dateFormatter.string(for: weatherData!.date!)
            imageView.setWeatherIcon(id: Int(weatherData!.weatherId))
            
            reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D(latitude: weatherData!.latitude, longitude: weatherData!.longitude), success: { address in
                self.addressLabel.text = "\(address.thoroughfare!)\n\(address.postalCode!), \(address.country!)"
            }, failure: { error in
                print(error)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
