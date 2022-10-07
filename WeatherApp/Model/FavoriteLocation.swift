//
//  FavoriteLocation.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 03/10/2022.
//

import Foundation
import RealmSwift

class FavoriteLocation: Object {
    @Persisted(primaryKey: true) var id = ""
    @Persisted var lat = 0.0
    @Persisted var lon = 0.0
    @Persisted var location = ""
    @Persisted var time = ""
    @Persisted var des = ""
    @Persisted var degree = ""
    @Persisted var highTemp = ""
    @Persisted var lowTemp = ""
    @Persisted var indexInSavedLocation = 0
    
    override init() {}
    
    init(id: String, location: String, time: String, des: String, degree: String, highTemp: String, lowTemp: String, indexInSavedLocation: Int) {
        self.id = id
        self.lat = 0.0
        self.lon = 0.0
        self.location = location
        self.time = time
        self.des = des
        self.degree = degree
        self.highTemp = highTemp
        self.lowTemp = lowTemp
        self.indexInSavedLocation = indexInSavedLocation
    }
}
