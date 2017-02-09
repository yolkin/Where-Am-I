//
//  DBManager.swift
//  Where am I?
//
//  Created by Alexander on 2/9/17.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import CoreData

class DBManager: NSObject {

    static let shared = DBManager()
    
    // Entities
    static let kWeatherEntityName = "WeatherData"
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: DBManager.kWeatherEntityName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    func saveWeather(weather: Weather) {
        
        let weatherData = NSEntityDescription.insertNewObject(forEntityName: DBManager.kWeatherEntityName, into: managedObjectContext) as! WeatherData
        
        weatherData.clouds      = weather.cloudCover as NSNumber
        weatherData.date        = weather.dateAndTime as NSDate?
        weatherData.humidity    = weather.humidity as NSNumber
        weatherData.weatherId   = weather.id as NSNumber
        weatherData.latitude    = weather.latitude
        weatherData.longitude   = weather.longitude
        weatherData.mainWeather = weather.mainWeather
        weatherData.temp        = weather.tempCelsius
        weatherData.city        = weather.city
        
        saveContext()
    }
    
    func getHistory() -> [WeatherData] {
        let fetchRequest = NSFetchRequest<WeatherData>(entityName: DBManager.kWeatherEntityName)
        
        do {
            return try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    func deleteWeather(weatherData: WeatherData) {
        
        let fetchRequest = NSFetchRequest<WeatherData>(entityName: DBManager.kWeatherEntityName)
        
        if let result = try? managedObjectContext.fetch(fetchRequest) {
            for object in result {
                if object.isEqual(weatherData) {
                    managedObjectContext.delete(object)
                    saveContext()
                    break
                }
            }
        }
    }
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
