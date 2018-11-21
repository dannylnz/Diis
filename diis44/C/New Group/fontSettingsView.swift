
import UIKit
import SnapKit

class fontSettingsView: UIView {

    let menuUIView = UIView()
    let lessLuminosityImage = UIImageView()
    let moreLuminosityImage = UIImageView()
    let luminositySlider = UISlider(frame:CGRect(x: 10, y: 100, width: 300, height: 20))
    let luminositySteps: Float = 1
    let fontIconImg = UIImage(named: "fontIcon") as UIImage?
    let makeFontSmallerBtn = UIButton()
    let makeFontBiggerBtn = UIButton()
    let colorPattern1 = UIButton()
    let colorPattern2 = UIButton()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    commonInit()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
//        commonInit()
    }
    
     func commonInit(){
        
        menuUIView.backgroundColor = .white
        print("My Custom Init")
        addSubview(menuUIView)
        UISetup()
        menuUIView.frame = self.bounds
        menuUIView.autoresizingMask = [.flexibleHeight, .flexibleWidth]


    }
    
    @objc func sliderValueDidChange(_ sender:UISlider!)
    {
        print("Slider value changed")
        
        // Use this code below only if you want UISlider to snap to values step by step
        let roundedStepValue = round(sender.value / luminositySteps) * luminositySteps
        sender.value = roundedStepValue
        
        print("Slider step value \(Int(roundedStepValue))")
    }
    
    func UISetup(){
        
        
        luminositySlider.minimumValue = 0
        luminositySlider.maximumValue = 100
        luminositySlider.isContinuous = true
        luminositySlider.tintColor = UIColor.green
        luminositySlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        menuUIView.layer.borderColor = UIColor.black.cgColor
        menuUIView.layer.borderWidth = 0.4
        
        menuUIView.addSubview(lessLuminosityImage)
        lessLuminosityImage.image = UIImage(named: "luminosityIcon")
        lessLuminosityImage.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.width.equalTo(17)
            make.left.equalTo(menuUIView.snp.left).offset(50)
            make.top.equalTo(menuUIView.snp.top).offset(40)
        }
        menuUIView.addSubview(moreLuminosityImage)
        moreLuminosityImage.image = UIImage(named: "luminosityIcon")
        moreLuminosityImage.snp.makeConstraints { (make) in
            make.height.equalTo(26)
            make.width.equalTo(26)
            make.right.equalTo(menuUIView.snp.right).offset(-50)
            make.top.equalTo(menuUIView.snp.top).offset(40)
        }
        menuUIView.addSubview(luminositySlider)
        luminositySlider.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalTo(200)
            make.top.equalTo(menuUIView.snp.top).offset(40)
            make.centerX.equalTo(menuUIView.snp.centerX)
            
        }
        menuUIView.addSubview(makeFontSmallerBtn)
        makeFontSmallerBtn.setImage(fontIconImg, for: .normal)
        makeFontSmallerBtn.snp.makeConstraints { (make) in
           make.height.equalTo(60)
            make.width.equalTo(60)
            make.top.equalTo(moreLuminosityImage.snp.bottom)
            make.left.equalTo(menuUIView.snp.left).offset(100)
        }
        menuUIView.addSubview(makeFontBiggerBtn)
        makeFontBiggerBtn.setImage(fontIconImg, for: .normal)
        makeFontBiggerBtn.backgroundColor = UIColor.lightGray
        makeFontBiggerBtn.layer.borderColor = UIColor.black.cgColor
        makeFontBiggerBtn.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.width.equalTo(60)
            make.top.equalTo(moreLuminosityImage.snp.bottom)
            make.right.equalTo(menuUIView.snp.right).offset(-100)
        }
     
    }
 
    
    
}
    
    


