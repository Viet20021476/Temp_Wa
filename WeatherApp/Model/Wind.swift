//
//  Wind.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 27/09/2022.
//

import Foundation

class Wind {
    var imgSymbol = ""
    var des = ""
    var isChecked = false
    
    init(imgSymbol: String, des: String, isChecked: Bool) {
        self.imgSymbol = imgSymbol
        self.des = des
        self.isChecked = isChecked
    }
    
}
