//
//  FirstViewController.swift
//  Where am I?
//
//  Created by Alexander on 06.02.17.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import GoogleMaps

class FirstViewController: UIViewController, CLLocationManagerDelegate, WeatherGetterDelegate {
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var yourLocationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var clouds: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var mainWeatherLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    let locationManager = CLLocationManager()
    var weather: WeatherGetter!
    
    var isCelsius = true
    var temperature: Double = 0.0

    @IBAction func getYourAddress(_ sender: Any) {
        yourLocationLabel.isHidden = true
        longitudeLabel.isHidden = true
        latitudeLabel.isHidden = true
        cityLabel.isHidden = false
        addressLabel.isHidden = false
        temperatureLabel.isHidden = false
        humidity.isHidden = false
        humidityLabel.isHidden = false
        clouds.isHidden = false
        cloudsLabel.isHidden = false
        mainWeatherLabel.isHidden = false
        imageView.isHidden = false
        button.isHidden = true
    }
    
    @IBAction func celsiusToFarenheit(_ sender: Any) {
        if isCelsius {
            temperature = temperature * 9 / 5 + 32
            temperatureLabel.text = "\(Int(round(temperature)))F"
            isCelsius = false
        } else {
            temperature = (temperature - 32) * 5 / 9
            temperatureLabel.text = "\(Int(round(temperature)))°"
            isCelsius = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weather = WeatherGetter(delegate: self)
        enableLocation()
    }
    
    func enableLocation() {
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        } else if status == .denied || status == .restricted {
            return
        } else {
            if locationManager.delegate == nil {
                locationManager.delegate = self
            }
            locationManager.startUpdatingLocation()
            retreiveAndSaveWeatherData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .notDetermined {
            enableLocation()
            locationManager.delegate = nil
        }
    }
    
    func retreiveAndSaveWeatherData() {
        if let userLocation = locationManager.location {
            let latitude = userLocation.coordinate.latitude
            let longitude = userLocation.coordinate.longitude
            latitudeLabel.text = "\(latitude)"
            longitudeLabel.text = "\(longitude)"
            locationManager.stopUpdatingLocation()
            
            reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), success: { address in
                self.cityLabel.text = "\(address.locality!)"
                self.addressLabel.text = "\(address.thoroughfare!)\n\(address.postalCode!), \(address.country!)"
            }, failure: { error in
                print(error)
            })

            weather.getWeatherByCoordinates(latitude: latitude, longitude: longitude)
        }
    }
    
    func didGetWeather(weather: Weather) {
        var weatherCopy = weather
        
        weatherCopy.latitude = locationManager.location!.coordinate.latitude
        weatherCopy.longitude = locationManager.location!.coordinate.longitude
        
        DBManager.shared.saveWeather(weather: weatherCopy)
        
        DispatchQueue.main.async(execute: {
            self.mainWeatherLabel.text = "\(weather.mainWeather)"
            self.temperatureLabel.text = "\(Int(round(weather.tempCelsius)))°"
            self.humidityLabel.text = "\(weather.humidity)%"
            self.cloudsLabel.text = "\(weather.cloudCover)%"
            self.imageView.setWeatherIcon(id: weather.id)
            self.temperature = weather.tempCelsius
        })
    }
    
    func didNotGetWeather(error: NSError) {
        DispatchQueue.main.async(execute: {
            self.showSimpleAlert(title: "Can't get the weather",
                                 message: "The weather service isn't responding.")
        })
        print("didNotGetWeather error: \(error)")
    }
    
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:  .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
