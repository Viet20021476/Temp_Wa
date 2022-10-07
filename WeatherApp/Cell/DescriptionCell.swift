//
//  DescriptionCell.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 27/09/2022.
//

import UIKit

class DescriptionCell: UICollectionViewCell {

    @IBOutlet weak var lbDes: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Util.roundCorner(views: [self], radius: 10)
    }

}
