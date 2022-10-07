////
////  City.swift
////  WeatherApp
////
////  Created by Nguyễn Duy Việt on 21/09/2022.
////
//
import Foundation
import HandyJSON
//
//class City: HandyJSON {
//    var id = 0
//    //name of city
//    var name = ""
//    var state = ""
//    var country = ""
//    var coord = Coordinate()
//    required init() {}
//}
//
//class Coordinate: HandyJSON {
//    var lon = 0.0
//    var lat = 0.0
//    required init() {}
//}

class CityModel: HandyJSON {
    var city = ""
    var lat = 0.0
    var lng = 0.0
    var country = ""
    var iso2 = ""
    var admin_name = ""
    var capital = ""
    var population = ""
    var population_proper = ""
    
    required init() {}
}
