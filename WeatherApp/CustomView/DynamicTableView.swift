//
//  DynamicTableView.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 27/09/2022.
//

import UIKit

class DynamicTableView: UITableView {
    
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
