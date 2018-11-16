import UIKit
import Firebase
import SnapKit
import FirebaseFirestore
import FirebaseAuth

class SignUpVC: UIViewController {
    
    let db = Firestore.firestore()
    var ref: DocumentReference?
    let mainView = UIScrollView()

    //textFields
    let emailTF = UITextField()
    let nameTF = UITextField()
    let passwordTF = UITextField()
    let confirmPasswordTF = UITextField()
    let signFont = UIFont(name: "Avenir", size: 14.0)
    //Btn
    let signUpBtn = UIButton()
    let signInBtn = UIButton()
    //Labels
    let AlreadyhaveAnAccountLabel = UILabel()
    //Img
    let dividerImage = UIImageView()
    let img = UIImage(named: "divider")
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpBtn.addTarget(self, action: #selector(signUpBtnClicked), for: .touchUpInside)
        viewSetup()
        
        test()
    }
    
    func test(){
        db.collection("users").getDocuments { (snap, error) in
            
            for document in snap!.documents {
                print("\(document.documentID) => \(document.data())")
            }
        
        }
        
    }
}


//MARK:- UISetup
extension SignUpVC{
    
    func viewSetup() {
        mainView.backgroundColor = UIColor.white
        view.addSubview(mainView)
        mainView.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            
        }
      //emailTF
        emailTF.font = signFont
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
            make.top.equalTo(mainView.snp.top).offset(100)
            make.centerX.equalTo(mainView.snp.centerX)
        }
        //nameTF
        nameTF.font = signFont
        nameTF.autocapitalizationType = .words
        nameTF.borderStyle = .roundedRect
        nameTF.attributedPlaceholder = NSAttributedString(string: "name", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont(name: "Avenir", size: 14.0)!
            ])
        mainView.addSubview(nameTF)
        nameTF.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(200)
            make.top.equalTo(emailTF.snp.bottom).offset(8)
            make.centerX.equalTo(mainView.snp.centerX)
        }
        //passwordTF
        passwordTF.font = signFont
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
            make.top.equalTo(nameTF.snp.bottom).offset(8)
            make.centerX.equalTo(mainView.snp.centerX)
        }
        //confirmPasswordTF
        confirmPasswordTF.font = signFont
        confirmPasswordTF.placeholder = "confirm password"
        confirmPasswordTF.borderStyle = .roundedRect
        confirmPasswordTF.isSecureTextEntry = true
        confirmPasswordTF.attributedPlaceholder = NSAttributedString(string: "confirm password", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont(name: "Avenir", size: 14.0)!
            ])
        mainView.addSubview(confirmPasswordTF)
        confirmPasswordTF.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(200)
            make.top.equalTo(passwordTF.snp.bottom).offset(8)
            make.centerX.equalTo(mainView.snp.centerX)
        }
        
        //SignUpBtn
        signUpBtn.setTitle("Sign up", for: .normal)
        signUpBtn.layer.cornerRadius = 4.0
        signUpBtn.backgroundColor = UIColor.init(rgb: 0x59983B)
        mainView.addSubview(signUpBtn)
        signUpBtn.snp.makeConstraints { (make) in
            make.height.equalTo(36)
            make.width.equalTo(200)
            make.top.equalTo(confirmPasswordTF.snp.bottom).offset(12)
            make.centerX.equalTo(mainView.snp.centerX)
        }
        //dividerImage
        dividerImage.image = img
        dividerImage.contentMode = .scaleAspectFill
        mainView.addSubview(dividerImage)
        dividerImage.snp.makeConstraints { (make) in
            make.height.equalTo(100)
            make.width.equalTo(mainView.snp.width).offset(25)
            make.top.equalTo(signUpBtn.snp.bottom).offset(50)
            make.centerX.equalTo(mainView.snp.centerX)
        }
        
        //label - already have an account?
        mainView.addSubview(AlreadyhaveAnAccountLabel)
        AlreadyhaveAnAccountLabel.text = "Already have an account?"
        AlreadyhaveAnAccountLabel.textAlignment = .center
        AlreadyhaveAnAccountLabel.font = UIFont(name: "BodoniSvtyTwoOSITCTT-Bold", size: 20.0)
        AlreadyhaveAnAccountLabel.textColor = UIColor.black
        AlreadyhaveAnAccountLabel.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(200)
            make.top.equalTo(dividerImage.snp.bottom).offset(75)
            make.centerX.equalTo(mainView.snp.centerX)
        }
        
        //SignInBtn
        signInBtn.setTitle("Sign in", for: .normal)
        signInBtn.layer.cornerRadius = 4.0
        signInBtn.backgroundColor = UIColor.init(rgb: 0x3b5998)
        mainView.addSubview(signInBtn)
        signInBtn.snp.makeConstraints { (make) in
            make.height.equalTo(36)
            make.width.equalTo(200)
            make.top.equalTo(AlreadyhaveAnAccountLabel.snp.bottom).offset(6)
            make.centerX.equalTo(mainView.snp.centerX)
        }
        
        
       
    }
}
extension SignUpVC{
    
    @objc func signUpBtnClicked(){
        
       guard emailTF.text != "", nameTF.text != "" , passwordTF.text != "",confirmPasswordTF.text != "" else {return}
        
        
        if passwordTF.text == confirmPasswordTF.text {
            
            Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!, completion: { (user, error) in
                if let error = error {
                    
                    print(error.localizedDescription)
                } else if let user = user {
                    
                        let dbRef = Firestore.firestore()
                        let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                        changeRequest.displayName = self.nameTF.text!
                        changeRequest.commitChanges(completion: nil)
                        let userInfo : [String: Any] = ["uid": user.user.uid,
                                                        "name" : self.nameTF.text!,
                                                        "mail": self.emailTF.text!]
          
                    dbRef.collection("users").document("\(user.user.uid)").setData(userInfo, merge: true, completion: { (error) in
                        if let error = error {print (error.localizedDescription) //TODO - Message:cannot make your registration, Sorry! :(}
                        } else {
                            
                            let alert = UIAlertController(title: "Sign up successful", message: "", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            print("user registered")
                        }
                    })
                    
 
            
        }
    }
    
    
)}
}
}


