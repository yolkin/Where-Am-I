//
//  WeatherIcon.swift
//  Where am I?
//
//  Created by Alexander on 08.02.17.
//  Copyright © 2017 Alexander. All rights reserved.
//
//  Icons designed by Flaticon.com

import Foundation
import UIKit
import GoogleMaps

extension UIImageView {
    
    func setWeatherIcon(id: Int) {
        switch id {
        case 200...232:
            self.image = #imageLiteral(resourceName: "storm")
        case 300...321:
            self.image = #imageLiteral(resourceName: "summer-rain")
        case 500...531:
            self.image = #imageLiteral(resourceName: "rain")
        case 600...622:
            self.image = #imageLiteral(resourceName: "snowing")
        case 700...781:
            self.image = #imageLiteral(resourceName: "fog")
        case 800:
            self.image = #imageLiteral(resourceName: "sunny")
        case 801...804:
            self.image = #imageLiteral(resourceName: "cloud")
        default:
            self.image = #imageLiteral(resourceName: "sunny")
        }
    }
}

extension UIViewController {
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D, success: @escaping (GMSAddress) -> (), failure: @escaping (Error) -> ()) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let result = response?.firstResult() {
                success(result)
            } else {
                failure(error!)
            }
        }
    }
}
