//
//  popUpRegistrationVC.swift
//  diis44
//
//  Created by Daniele Lanzetta on 16.11.18.
//  Copyright © 2018 Daniele Lanzetta. All rights reserved.
//

import UIKit
import SnapKit

class popUpRegistrationVC: UIViewController {

    let mainView = UIScrollView()
    let facebookBtn = UIButton()
    let mailBtn = UIButton()
    let dismissBtn = UIButton()
    let dismissImage = UIImage(named: "dismiss")
    let onboardingImage = UIImageView()
    let img = UIImage(named: "signupimg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        viewSetup()
        
    }
    
}


extension popUpRegistrationVC{
    
    func viewSetup() {
        mainView.backgroundColor = UIColor.white
        view.addSubview(mainView)
        mainView.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            
        }
        //onboardingImage
        onboardingImage.image = img
        onboardingImage.contentMode = .scaleAspectFill
        mainView.addSubview(onboardingImage)
        onboardingImage.snp.makeConstraints { (make) in
            make.height.width.equalTo(200)
            make.top.equalTo(mainView.snp.top).offset(120)
            make.centerX.equalTo(mainView.snp.centerX)
        }
        //onboardingTextLabel
        let onboardingTextLabel = UILabel()
        mainView.addSubview(onboardingTextLabel)
        onboardingTextLabel.text = "To save stories and review them\n you can create an account."
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
//        //dismiss Button
//        dismissBtn.setImage(dismissImage, for: .normal)
//        dismissBtn.contentMode = .scaleAspectFill
//        dismissBtn.addTarget(self, action: #selector(dismissBtnClicked), for: .touchUpInside)
//        mainView.addSubview(dismissBtn)
//        dismissBtn.snp.makeConstraints { (make) in
//            make.width.equalTo(20)
//            make.height.equalTo(20)
//            make.right.equalTo(mainView.snp.right).offset(50)
//            make.top.equalTo(mainView.snp.top).offset(70)
//        }
        
        
        
    }
    
    @objc func facebookBtnClicked() {
        
        facebookBtn.pulsate()
       
        //todo
    }
    
    @objc func mailBtnClicked() {
        mailBtn.pulsate()
        let signUpVC = SignUpVC()
        signUpVC.title = "Sign up with your email"
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc func dismissBtnClicked() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
