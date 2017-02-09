//
//  WeatherData+CoreDataProperties.swift
//  Where am I?
//
//  Created by Alexander on 2/8/17.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation
import CoreData


extension WeatherData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherData> {
        return NSFetchRequest<WeatherData>(entityName: "WeatherData");
    }

    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var clouds: NSNumber
    @NSManaged public var date: NSDate?
    @NSManaged public var humidity: NSNumber
    @NSManaged public var weatherId: NSNumber
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var mainWeather: String?
    @NSManaged public var temp: Double

}
