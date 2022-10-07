//
//  OverallConditionsCell.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 26/09/2022.
//

import UIKit

class OverallConditionsCell: UITableViewCell {

    @IBOutlet weak var lbWeatherSpecific: UILabel!
    @IBOutlet weak var imgCheck: UIImageView!
    var isChecked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgCheck.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
