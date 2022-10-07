//
//  OverallConditions.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 26/09/2022.
//

import Foundation

class OverallConditions {
    var imgWeather = ""
    var weather = ""
    var weatherSpecific = [WeatherSpecific]()
    var isOpenSubView = false
    
    init(imgWeather: String, weather: String, weatherSpecific: [WeatherSpecific], isOpenSubView: Bool) {
        self.imgWeather = imgWeather
        self.weather = weather
        self.weatherSpecific = weatherSpecific
        self.isOpenSubView = isOpenSubView
    }
    
}

class WeatherSpecific {
    var weatherSpe = ""
    var isChecked = false
    
    init(weatherSpe: String, isChecked: Bool) {
        self.weatherSpe = weatherSpe
        self.isChecked = isChecked
    }
    
}
