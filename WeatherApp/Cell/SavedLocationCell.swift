//
//  SavedLocationCell.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 28/09/2022.
//

import UIKit

class SavedLocationCell: UITableViewCell {
    
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbDes: UILabel!
    @IBOutlet weak var lbDegree: UILabel!
    @IBOutlet weak var lbHighTemp: UILabel!
    @IBOutlet weak var lbLowTemp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
