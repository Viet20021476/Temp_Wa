//
//  CatePagingCell.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 04/10/2022.
//

import UIKit
import Parchment

class CatePagingCell: PagingCell {
    
    var imgPaging = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgPaging.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imgPaging.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        imgPaging.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imgPaging.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        imgPaging.contentMode = .scaleAspectFit
    }
    
    func configure() {
        addSubview(imgPaging)
        imgPaging.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func setPagingItem(_ pagingItem: PagingItem, selected _: Bool, options _: PagingOptions) {
        let catePagingItem = pagingItem as! CatePagingItem
        imgPaging.image = UIImage(named: "\(catePagingItem.imgPaging)")
    }

}
