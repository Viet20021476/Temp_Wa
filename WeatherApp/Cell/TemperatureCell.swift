//
//  TemperatureCell.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 27/09/2022.
//

import UIKit

class TemperatureCell: UITableViewCell {

    @IBOutlet weak var imgTemp: UIImageView!
    @IBOutlet weak var lbDes: UILabel!
    @IBOutlet weak var imgCheck: UIImageView!
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
