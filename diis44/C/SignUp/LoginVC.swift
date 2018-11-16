import UIKit
import Firebase
import SnapKit
import FirebaseFirestore
import FirebaseAuth

class LoginVC: UIViewController {
    
    let mainView = UIScrollView()
    //Img
    let loginImg = UIImageView()
    //textFields
    let emailTF = UITextField()
    let passwordTF = UITextField()
    //Btn
    let signUpBtn = UIButton()
    let signInBtn = UIButton()
    //Labels
    let loginLabel = UILabel()
    let registrationLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetup()
    }
    
    
    
    
}


extension LoginVC{
    
    func viewSetup() {
        mainView.backgroundColor = UIColor.white
        view.addSubview(mainView)
        mainView.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            
        }
    }
}
