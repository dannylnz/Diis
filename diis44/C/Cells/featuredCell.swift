import UIKit

class featuredCell: BaseRoundedCardCell {
    
    var categoryName:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir-Heavy", size: 25.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var categoryDescription:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "SFCompactDisplay-Regular", size: 22.0)
        label.textColor = UIColor.black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var image = UIImageView()
    
    
    
    
}
