//
//  WeatherModel.swift
//  task4_app
//
//  Created by Ömer Faruk Başaran on 15.09.2023.
//

import Foundation

struct WeatherResponse: Decodable {
    let name: String
    let main: Weather
}

struct Weather: Decodable {
    
    let temp: Double
    let humidity: Double
    let temp_min: Double
    let temp_max: Double
}
