//
//  HistoryTableViewController.swift
//  Where am I?
//
//  Created by Alexander on 06.02.17.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {

    var weatherData: [WeatherData] = []
    let dateFormatter = DateFormatter()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "MMM dd yyyy hh:mm:ss"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        
        weatherData = DBManager.shared.getHistory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let weather = weatherData[indexPath.row]
        
        cell.textLabel?.text = String(format: "%@, %f, %f", weather.city!, weather.latitude, weather.longitude)
        cell.detailTextLabel?.text = dateFormatter.string(for: weather.date!)
        cell.imageView?.setWeatherIcon(id: Int(weather.weatherId))

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showInfo", sender: weatherData[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DBManager.shared.deleteWeather(weatherData: weatherData[indexPath.row])
            weatherData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {

        }    
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInfo" {
            let destinationVC: DetailHistoryViewController = segue.destination as! DetailHistoryViewController
            destinationVC.weatherData = sender as? WeatherData
        }
    }

}
