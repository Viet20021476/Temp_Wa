//
//  CatePagingItem.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 04/10/2022.
//

import Foundation
import Parchment

struct CatePagingItem: PagingItem, Hashable, Comparable {
    let index: Int
    let imgPaging: String

    init(index: Int, imgPaging: String) {
        self.index = index
        self.imgPaging = imgPaging
    }
    
    static func < (lhs: CatePagingItem, rhs: CatePagingItem) -> Bool {
        return lhs.index < rhs.index
    }
}

// class va struct ke thua????

//struct CalendarItem: PagingItem, Hashable, Comparable {
//    let date: Date
//    let dateText: String
//    let weekdayText: String
//
//    init(date: Date) {
//        self.date = date
//        dateText = "DateFormatters.dateFormatter.string(from: date)"
//        weekdayText = "DateFormatters.weekdayFormatter.string(from: date)"
//    }
//
//    static func < (lhs: CalendarItem, rhs: CalendarItem) -> Bool {
//        return lhs.date < rhs.date
//    }
//}
