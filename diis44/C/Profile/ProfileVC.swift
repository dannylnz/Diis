import UIKit
import SnapKit

class ProfileVC: UIViewController {
    
    let mainView = UIScrollView()
//    let facebookBtn = UIButton()
//    let mailBtn = UIButton()
//    let onboardingImage = UIImageView()
//    let img = UIImage(named: "onboardingimage")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
}


extension ProfileVC{
    
    func viewSetup() {
        mainView.backgroundColor = UIColor.blue
        navigationController?.title = "Profile"
        view.addSubview(mainView)
        mainView.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            
        }
        
        
}

}
