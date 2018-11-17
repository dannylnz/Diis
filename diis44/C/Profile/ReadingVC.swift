import UIKit
import Firebase
import SnapKit
import FirebaseFirestore
import FirebaseAuth

class ReadingVC: UIViewController {
    
    let mainView = UIScrollView()
        let facebookBtn = UIButton()
        let mailBtn = UIButton()
        let onboardingImage = UIImageView()
        let img = UIImage(named: "onboardingreadingimg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLogged()
    }
    
}

extension ReadingVC{
    
    func viewSetup() {
        mainView.backgroundColor = UIColor.blue
        navigationController?.title = "Reading"
        view.addSubview(mainView)
        mainView.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            
        }
    }
    
    func viewSetupGuest() {
        mainView.backgroundColor = UIColor.white
        navigationController?.title = "Reading"
        view.addSubview(mainView)
        mainView.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        //OnboardingImage
        onboardingImage.image = img
        onboardingImage.contentMode = .scaleAspectFill
        mainView.addSubview(onboardingImage)
        onboardingImage.snp.makeConstraints { (make) in
            make.height.equalTo(150)
            make.width.equalTo(200)
            make.top.equalTo(mainView.snp.top).offset(60)
            make.centerX.equalTo(mainView.snp.centerX)
        }
        //onboardingTextLabel
        let onboardingTextLabel = UILabel()
        mainView.addSubview(onboardingTextLabel)
        onboardingTextLabel.text = "Create an account to keep\n track of your favorite stories!"
        onboardingTextLabel.textAlignment = .center
        onboardingTextLabel.numberOfLines = 0
        onboardingTextLabel.font = UIFont(name: "BodoniSvtyTwoOSITCTT-Bold", size: 20.0)
        onboardingTextLabel.textColor = UIColor.black
        onboardingTextLabel.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(200)
            make.top.equalTo(onboardingImage.snp.bottom).offset(20)
            make.centerX.equalTo(mainView.snp.centerX)
        }
        //Facebook Button
        facebookBtn.backgroundColor = UIColor.init(rgb: 0x3B5998)
        facebookBtn.setTitle("Facebook", for: .normal)
        facebookBtn.layer.cornerRadius = 4.0
        facebookBtn.addTarget(self, action: #selector(facebookBtnClicked), for: .touchUpInside)
        mainView.addSubview(facebookBtn)
        facebookBtn.snp.makeConstraints { (make) in
            make.width.equalTo(mainView.snp.width).offset(-150)
            make.height.equalTo(36)
            make.centerX.equalTo(onboardingImage.snp.centerX)
            make.top.equalTo(onboardingTextLabel.snp.bottom).offset(20)
        }
        //mail Button
        mailBtn.backgroundColor = UIColor.init(rgb: 0x59983B)
        mailBtn.setTitle("E-mail", for: .normal)
        mailBtn.layer.cornerRadius = 4.0
        mailBtn.addTarget(self, action: #selector(mailBtnClicked), for: .touchUpInside)
        mainView.addSubview(mailBtn)
        mailBtn.snp.makeConstraints { (make) in
            make.width.equalTo(mainView.snp.width).offset(-150)
            make.height.equalTo(36)
            make.centerX.equalTo(onboardingImage.snp.centerX)
            make.top.equalTo(facebookBtn.snp.bottom).offset(9)
        }
        
    }
    
    //MARK:- Button functions
    @objc func facebookBtnClicked() {
        facebookBtn.pulsate()
        //todo: add facebook integration
    }
    @objc func mailBtnClicked() {
        mailBtn.pulsate()
        let signUpVC = SignUpVC()
        signUpVC.title = "Sign up with your email"
        signUpVC.modalPresentationStyle = .overCurrentContext
        UINavigationBar.appearance().isHidden = true
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    
    
    
    fileprivate func checkIfUserIsLogged() {
        
        if Auth.auth().currentUser != nil  {
            print("user is authenticated")
            viewSetup()
            // todo
        }else {
            print("user is NOT authenticated")
            viewSetupGuest()
        }
        
    }
    
    fileprivate func anonymousUser() {
        
        Auth.auth().signInAnonymously() { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            // TODO: Save eventual data
            
            let user = authResult?.user
            let isAnonymous = user?.isAnonymous  // true
            let uid = user?.uid
            
            //Browse anonymously
            // buttons are disabled (following, dummy profile, likes)
            
        }
    }
    
}


extension readerVC {
    

}
