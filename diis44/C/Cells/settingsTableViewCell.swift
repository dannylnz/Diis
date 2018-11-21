import UIKit

class settingsTableViewCell: UITableViewCell {
    
    var title:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont(name: "Avenir", size: 20.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var cellImage = UIImageView()
    
}
