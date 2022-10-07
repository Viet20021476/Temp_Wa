//
//  WeatherDetail.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 26/09/2022.
//

import Foundation

class WeatherDetail {
    var imgType = ""
    var type = ""
    var imgIllustration = ""
    var para = ""
    var des = ""
    
    init(imgType: String, type: String, imgIllustration: String, para: String, des: String) {
        self.imgType = imgType
        self.type = type
        self.imgIllustration = imgIllustration
        self.para = para
        self.des = des
    }
    
    
    
}
