//
//  chapterCell.swift
//  diis44
//
//  Created by Daniele Lanzetta on 27.09.18.
//  Copyright © 2018 Daniele Lanzetta. All rights reserved.
//

import UIKit

class chapterCell: UICollectionViewCell {
    var chapterTitle:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont(name: "Avenir-Heavy", size: 17.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var chapterSubtitle:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Avenir", size: 14.0)
        label.textColor = UIColor.lightGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
}
