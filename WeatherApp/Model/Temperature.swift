//
//  Temperature.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 27/09/2022.
//

import Foundation

class Temperature {
    var imgTemp = ""
    var des = ""
    var isChecked = false
    
    init(imgTemp: String, des: String, isChecked: Bool) {
        self.imgTemp = imgTemp
        self.des = des
        self.isChecked = isChecked
    }
    
}
