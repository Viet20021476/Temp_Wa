//
//  WeatherDetailCell.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 26/09/2022.
//

import UIKit
import GradientProgressBar

class WeatherDetailCell: UICollectionViewCell {
    @IBOutlet weak var wContentView: UIView!
    @IBOutlet weak var imgType: UIImageView!
    
    @IBOutlet weak var lbLast24hours: UILabel!
    @IBOutlet weak var lbType: UILabel!
    
    @IBOutlet weak var imgIllustration: UIImageView!
    @IBOutlet weak var lbPara: UILabel!
    @IBOutlet weak var lbDes: UILabel!
    @IBOutlet weak var uvProgressBar: GradientProgressBar!
}
