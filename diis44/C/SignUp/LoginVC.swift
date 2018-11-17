import UIKit
import Firebase
import SnapKit
import FirebaseFirestore
import FirebaseAuth

class LoginVC: UIViewController {

    let mainView = UIScrollView()
    let loginImg = UIImageView()
    let emailTF = UITextField()
    let passwordTF = UITextField()
    let signUpBtn = UIButton()
    let signInBtn = UIButton()
    let welcomeBackLabel = UILabel()
    let registrationLabel = UILabel()
    let signFont = UIFont(name: "Avenir", size: 14.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
}

extension LoginVC {
    
    func viewSetup() {
        mainView.backgroundColor = UIColor.white
        view.addSubview(mainView)
        mainView.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        //label - already have an account?
        mainView.addSubview(welcomeBackLabel)
        welcomeBackLabel.text = "Welcome back,\n sign in to continue"
        welcomeBackLabel.textAlignment = .center
        welcomeBackLabel.font = UIFont(name: "BodoniSvtyTwoOSITCTT-Bold", size: 40.0)
        welcomeBackLabel.textColor = UIColor.black
        welcomeBackLabel.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(200)
            make.left.equalTo(mainView.snp.left).offset(10)
            make.top.equalTo(mainView.snp.top).offset(30)
        }
        //emailTF
        emailTF.font = signFont
        emailTF.clearButtonMode = .whileEditing
        emailTF.borderStyle = .roundedRect
        emailTF.autocorrectionType = .no
        emailTF.autocapitalizationType = .none
        emailTF.keyboardType = .emailAddress
        emailTF.attributedPlaceholder = NSAttributedString(string: "email", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont(name: "Avenir", size: 14.0)!
            ])
        mainView.addSubview(emailTF)
        emailTF.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(200)
            make.top.equalTo(welcomeBackLabel.snp.bottom).offset(20)
            make.centerX.equalTo(mainView.snp.centerX)
        }
        //passwordTF
        passwordTF.font = signFont
        passwordTF.clearButtonMode = .whileEditing
        passwordTF.borderStyle = .roundedRect
        passwordTF.isSecureTextEntry = true
        passwordTF.attributedPlaceholder = NSAttributedString(string: "password", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont(name: "Avenir", size: 14.0)!
            ])
        mainView.addSubview(passwordTF)
        passwordTF.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(200)
            make.top.equalTo(emailTF.snp.bottom).offset(8)
            make.centerX.equalTo(mainView.snp.centerX)
        }
        //SignInBtn
        signInBtn.setTitle("Sign in", for: .normal)
        signInBtn.layer.cornerRadius = 6.0
        signInBtn.backgroundColor = UIColor.init(rgb: 0x3b5998)
        signInBtn.addTarget(self, action: #selector(signInBtnClicked), for: .touchUpInside)
        mainView.addSubview(signInBtn)
        signInBtn.snp.makeConstraints { (make) in
            make.height.equalTo(36)
            make.width.equalTo(200)
            make.top.equalTo(passwordTF.snp.bottom).offset(6)
            make.centerX.equalTo(mainView.snp.centerX)
        }
        
    }
    @objc func signInBtnClicked(sender:UIButton!) {
        signInBtn.pulsate()
        guard emailTF.text != "", passwordTF.text != "" else {
            signInBtn.shake()
            self.showAlert(title: "Fill the empty fields", message: "")
            return
        }
        Auth.auth().signIn(withEmail: emailTF.text! , password: passwordTF.text!, completion: { (user, error) in
            if let error = error {
                self.signInBtn.shake()
                print(error.localizedDescription)
                self.showAlert(title: error.localizedDescription, message: "")
            }
            if user != nil {
                self.showAlert(title: "User Login", message: "")
            }
        })
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title,message: message, preferredStyle: .alert)
        // Accessing alert view backgroundColor :
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
