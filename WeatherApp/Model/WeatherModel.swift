//
//  Weather.swift
//  AutolayoutTest
//
//  Created by Nguyễn Duy Việt on 20/09/2022.
//

import Foundation
import HandyJSON

class WeatherModel: HandyJSON {
    var cod = ""
    var message = 0
    var cnt = 0
    var list = [List]()
    var city = _City()
    
    required init() {}
}

class List: HandyJSON {
    var dt = 0
    var main = Main()
    var weather = [Weather]()
    var clouds = Clouds()
    var wind = _Wind()
    var visibility = 0
    var pop = 0.0
    var rain: [String: Int]?
    var sys = Sys()
    var dt_txt = ""
    
    required init() {}
}

class Main: HandyJSON {
    var temp = 0.0
    var feels_like = 0.0
    var temp_min = 0.0
    var temp_max = 0.0
    var pressure = 0
    var sea_level = 0
    var grnd_level = 0
    var humidity = 0
    var temp_kf = 0.0
    
    required init() {}
}

class Weather: HandyJSON {
    var id = 0
    var main = ""
    var description = ""
    var icon = ""
    
    required init() {}
}

class Clouds: HandyJSON {
    var all = 0
    
    required init() {}
}

class _Wind: HandyJSON {
    var speed = 0.0
    var deg = 0
    var gust = 0.0
    required init() {}
}

class Rain: HandyJSON {
    var threeHour:Double?
    
    enum CodingKeys: String, CodingKey {
        case threeHour = "3h"
    }
    
    required init() {}
}

class Sys: HandyJSON {
    var pod = ""
    
    required init() {}
}

class _City: HandyJSON {
    var id = 0
    var name = ""
    var coord = Coordinate()
    var country = ""
    var population = 0
    var timezone = 0
    var sunrise = 0
    var sunset = 0
    
    required init() {}
}

class Coordinate: HandyJSON {
    var lat = 0.0
    var lon = 0.0
    
    required init() {}
}


