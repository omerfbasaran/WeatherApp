//
//  ViewController.swift
//  task4_app
//
//  Created by Ömer Faruk Başaran on 15.09.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    var latitude = ""
    var longitude = ""
    let openIdTok = "f19e9c513e6cf108d8fc045e1d8ba565"
    var weatherData: WeatherResponse?
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var tempratureLabel: UILabel!
    
    @IBOutlet weak var minMaxLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //request location auth
        locationManager.requestLocation()
        
        
        // Do any additional setup after loading the view.
    }
    
    func getData(){
        
        print("get data")
        let URL = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(self.latitude)&lon=\(self.longitude)&units=metric&appid=\(openIdTok)")
        let request = URLRequest(url: URL!)
        let _ = URLSession.shared.dataTask(with: request) { data, response, error in
            if (error != nil){
                print("network error")
            }
            if let data = data, let response = try? JSONDecoder().decode(WeatherResponse.self, from: data){
                DispatchQueue.main.async {
                    self.weatherData = response
                    print("datasucces")
                    print(response)
                    print(self.weatherData as Any)
                    self.getUI()
                }
            }
        }.resume()
    }
    
    func getUI(){
        locationLabel.text = weatherData?.name
        tempratureLabel.text = String(describing: Int(weatherData?.main.temp ?? 0)) + "C⁰"
        minMaxLabel.text = "Min: \(String(describing: Int(weatherData?.main.temp_min ?? 0))) C⁰ Max: \(String(describing: Int(weatherData?.main.temp_min ?? 0))) C⁰"
        var tempp = weatherData?.main.temp ?? 30
        switch tempp {
        case -50..<5:
            self.weatherImage.image = UIImage(systemName:"snowflake")
        case 5..<20:
            self.weatherImage.image = UIImage(systemName:"cloud.sun")
        case 20..<30:
            self.weatherImage.image = UIImage(systemName:"sun.min")
        case 30...50:
            self.weatherImage.image = UIImage(systemName:"sun.max")
        default:
            self.weatherImage.image = UIImage(systemName:"sun.max")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.latitude = String(location.coordinate.latitude)
            self.longitude = String(location.coordinate.longitude)
            print("latt and longg \(self.latitude) --- \(self.longitude)")
            getData()
            // Handle location update
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error: \(error)")
    }
}

