//
//  Choice.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 28/09/2022.
//

import Foundation

class Choice {
    var isChecked = false
    var des = ""
    var imgSymbol = ""
    
    init(isChecked: Bool, des: String, imgSymbol: String) {
        self.isChecked = isChecked
        self.des = des
        self.imgSymbol = imgSymbol
    }
}
