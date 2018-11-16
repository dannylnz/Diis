//
//  bookCell.swift
//  diis44
//
//  Created by Daniele Lanzetta on 27.09.18.
//  Copyright © 2018 Daniele Lanzetta. All rights reserved.
//

import UIKit

class bookCell: UICollectionViewCell {
    var title:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont(name: "Avenir-Heavy", size: 17.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.sizeToFit()
        return label
    }()
    
    var author:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Avenir", size: 14.0)
        label.textColor = UIColor.lightGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var plot:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Avenir-Light", size: 14.0)
        label.textColor = UIColor.black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var image:UIImageView = {
        let image = UIImageView()
        image.frame.size.height = 100
        image.frame.size.width = 60
        image.contentMode = .scaleAspectFill
        return image
    }()
}
