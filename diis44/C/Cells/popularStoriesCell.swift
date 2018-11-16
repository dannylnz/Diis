//
//  picksCell.swift
//  diis44
//
//  Created by Daniele Lanzetta on 26.09.18.
//  Copyright © 2018 Daniele Lanzetta. All rights reserved.
//

import UIKit

class popularStoriesCell: UICollectionViewCell {
    
        var bookTitleLbl:UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = UIColor.black
            label.font = UIFont(name: "Avenir-Heavy", size: 18.0)
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            return label
        }()
        
        var bookAuthorLbl:UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont(name: "Avenir", size: 14.0)
            label.textColor = UIColor.lightGray
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            return label
        }()
    
        var image = UIImageView()

    
    

}
