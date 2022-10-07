//
//  OtherConditions.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 27/09/2022.
//

import Foundation

class OtherConditions {
    var imgWeather = ""
    var des = ""
    var isChecked = false
    
    init(imgWeather: String, des: String, isChecked: Bool) {
        self.imgWeather = imgWeather
        self.des = des
        self.isChecked = isChecked
    }
}
