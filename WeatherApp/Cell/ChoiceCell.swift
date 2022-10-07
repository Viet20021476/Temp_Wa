//
//  ChoiceCell.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 28/09/2022.
//

import UIKit

class ChoiceCell: DropDownCell {

    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var imgSymbol: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
