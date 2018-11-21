import UIKit
import Firebase
import SnapKit
import FirebaseFirestore
import FirebaseAuth

class ReadingVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    let mainView = UIScrollView()
    var followingCV:UICollectionView!
    let facebookBtn = UIButton()
    let mailBtn = UIButton()
    let logoutBtn = UIButton()
    let settingsBtn = UIButton()
    let signInBtn = UIButton()
    let onboardingImage = UIImageView()
    let userUid = Auth.auth().currentUser?.uid
    var followedBooks = [String]()
    private var booksFollowedByUser = [Book]()
    let img = UIImage(named: "onboardingreadingimg")
    let AlreadyhaveAnAccountLabel = UILabel()
    //Img
    let dividerImage = UIImageView()
    let dividerImg = UIImage(named: "divider")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reading"
        checkIfUserIsLogged()
        
    }
    
}
// MARK:- ViewSetup Properties
extension ReadingVC {
    
    
    func addSettingsBtn(){
        settingsBtn.setImage(UIImage(named: "settings"), for: .normal)
        //add function for button
        settingsBtn.addTarget(self, action: #selector(settingsBtnClicked), for: .touchUpInside)
        //set frame
        settingsBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(25)
        }
        let settingsBarButton = UIBarButtonItem(customView: settingsBtn)
        navigationItem.rightBarButtonItem = settingsBarButton
    }
    
    func viewSetup() {
        mainView.backgroundColor = UIColor.white
        navigationController?.title = "Reading"
        view.addSubview(mainView)
        mainView.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        //followingBooksCollectionView
        followingCV.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        addSettingsBtn()
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
        addSettingsBtn()
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
        
        //dividerImage
        dividerImage.image = dividerImg
        dividerImage.contentMode = .scaleAspectFit
        mainView.addSubview(dividerImage)
        dividerImage.snp.makeConstraints { (make) in
            make.height.equalTo(80)
            make.width.equalTo(200)
            make.top.equalTo(mailBtn.snp.bottom).offset(20)
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
            make.top.equalTo(dividerImage.snp.bottom).offset(30)
            make.centerX.equalTo(mainView.snp.centerX)
        }
        
        //SignInBtn
        signInBtn.setTitle("Sign in", for: .normal)
        signInBtn.layer.cornerRadius = 4.0
        signInBtn.backgroundColor = UIColor.black
        signInBtn.addTarget(self, action: #selector(signInBtnClicked), for: .touchUpInside)
        mainView.addSubview(signInBtn)
        signInBtn.snp.makeConstraints { (make) in
            make.height.equalTo(36)
            make.width.equalTo(200)
            make.top.equalTo(AlreadyhaveAnAccountLabel.snp.bottom).offset(6)
            make.centerX.equalTo(mainView.snp.centerX)
        }
        
    }
    
    //MARK:- Button functions
    @objc func signInBtnClicked() {
        signInBtn.pulsate()
        let loginVC = LoginVC()
        loginVC.title = "Sign in"
        loginVC.modalPresentationStyle = .overCurrentContext
        UINavigationBar.appearance().isHidden = true
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @objc func settingsBtnClicked(){
        let settingsVC = SettingsVC()
        settingsVC.title = "Settings" 
        navigationController?.pushViewController(settingsVC, animated: true)
        print("setting Btn Clicked -")
    }
    
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
            
            getFollowedBooks { (success, response, error) in
                if success {
                    let pick = response
                    self.followedBooks = pick as! [String]
                    self.downloadBooks { (success, response, error) in
                        if success {
                            let book = response as! Book
                            self.booksFollowedByUser.append(book)
                            self.followingCV.reloadData()
                        } else if let error = error {
                            print("nothing found")
                            print (error)
                        }
                    }
                } else if let error = error {
                    print (error)
                }
            }
            setupFollowingCollectionView()
            viewSetup()
        }else {
            print("user is NOT authenticated")
            viewSetupGuest()
        }
    }
}

//MARK:- CollectionView Properties
extension ReadingVC {
    
    func setupFollowingCollectionView() {
        //layoutCollectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsetsMake(10, 5, 40, 5)
        layout.minimumLineSpacing = 15.0
        layout.minimumInteritemSpacing = 12.0
        followingCV = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        followingCV.dataSource = self
        followingCV.delegate = self
        followingCV.tag = 0
        followingCV.backgroundColor = .white
        followingCV.showsHorizontalScrollIndicator = false
        followingCV.alwaysBounceVertical = true
        followingCV.register(followingCell.self, forCellWithReuseIdentifier: "followingCell")
        mainView.addSubview(followingCV)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(booksFollowedByUser.count)
        return booksFollowedByUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 110, height: 170)
        return size
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "followingCell", for: indexPath) as! followingCell
        cell.bookTitleLbl.text = booksFollowedByUser[indexPath.row].title
        cell.bookAuthorLbl.text = booksFollowedByUser[indexPath.row].author
        cell.image.downloadedFrom(link: booksFollowedByUser[indexPath.row].coverImage)
        //cell.image.mask?.clipsToBounds = true
        cell.image.layer.masksToBounds = true
        cell.backgroundView = cell.image
        cell.layer.masksToBounds = true
        cell.image.contentMode = .scaleAspectFill
        cell.layer.cornerRadius = 5.0
        cell.addSubview(cell.image)
        cell.addSubview(cell.bookTitleLbl)
        cell.addSubview(cell.bookAuthorLbl)
        return cell
    }
}

//MARK:- Download Properties
extension ReadingVC {
    
    func downloadBooks(completion: @escaping (Bool, Any?, Error?) -> Void) {
        let followedBooksArray = self.followedBooks
        for link in followedBooksArray {
            print(link)
            let db = Firestore.firestore().document(link)
            db.getDocument { (snapshot, error) in
                if let err = error {
                    debugPrint("there was an error with the book : \(err)")
                } else {
                    let document = snapshot?.data() as! [String:Any]
                    let title = document["title"] as! String
                    let author = document["author"] as! String
                    let plot = document["plot"] as! String
                    let coverImage = document["coverImage"] as! String
                    let numberOfLikes = document["numberOfLikes"] as! Int
                    let numberOfFollowers = document["numberOfFollowers"] as! Int
                    let root = snapshot?.documentID
                    let category = document["category"] as! String
                    let aBook = Book(title: title,author:author,numberOfLikes:numberOfLikes, numberOfFollowers:numberOfFollowers, coverImage: coverImage, plot:plot, root: root!, category: category)
                    completion(true,aBook,nil)
                    print(aBook.title)
                }
            }
        }
    }
    
    func getFollowedBooks(completion: @escaping (Bool, Any?, Error?) -> Void) {
        let db = Firestore.firestore().collection("users").document(userUid!)
        db.getDocument { (document, error) in
            if let document = document, document.exists {
                let dictionary = document.data() as! [String:Any]
                let followedBooksArray = dictionary["following"] as! [String]
                completion(true,followedBooksArray,nil)
                
            } else {
                print("Document does not exist")
            }
        }
    }
}
