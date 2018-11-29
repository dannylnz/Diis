import UIKit
import Firebase
import SnapKit
import FirebaseFirestore
import CardsLayout
import Hero

class Discover: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    let mainView = UIScrollView()
    var picksCV:UICollectionView!
    var popularStoriesCV:UICollectionView!
    var featuredStoriesCV:UICollectionView!
    var books = [Book]()
     var picksCategory = [Category]()
     var popularStoriesCategory = [Book]()
     var featuredStoriesCategory = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadPopularStories { (success, response, error) in
            if success {
                let pick = response as! Book
                self.popularStoriesCategory.append(pick)
                self.books.append(pick)
                self.popularStoriesCV.reloadData()
            } else if let error = error {
                print (error)
            }
        }
        downloadPicks { (success, response, error) in
            if success {
                let pick = response as! Category
                self.picksCategory.append(pick)
                self.picksCV.reloadData()
            } else if let error = error {
                print (error)
            }
        }
        downloadFeaturedStories { (success, response, error) in
            if success {
                let pick = response as! Category
                self.featuredStoriesCategory.append(pick)
                self.featuredStoriesCV.reloadData()
            } else if let error = error {
                print (error)
            }
        }
        setupCollectionView()
        setupPopularStoriesCollectionView()
        setupFeaturedStoriesCollectionView()
        viewSetup()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UINavigationBar.appearance().isHidden = false
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
//    override func viewDidAppear(_ animated: Bool) {
//        self.title = "Discover"
//        tabBarController?.tabBar.isHidden = false
//
//
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        self.title = "Discover"
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        tabBarController?.tabBar.isHidden = false
//        super.viewWillAppear(animated)
//    }
}

//view layout
extension Discover {
    func viewSetup() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        tabBarController?.tabBar.isTranslucent = false
        tabBarController?.tabBar.barTintColor = .white
        mainView.backgroundColor = UIColor.white
        view.addSubview(mainView)
        mainView.snp.updateConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalToSuperview()
        }
        mainView.showsVerticalScrollIndicator = false
        mainView.resizeScrollViewContentSize()

//        let featureLabel = UILabel()
//        featuredStoriesCV.addSubview(featureLabel)
//        featureLabel.text = "FEATURED"
//        featureLabel.textAlignment = .left
//        featureLabel.font = UIFont(name: "Avenir-Black", size: 16.0)
//        featureLabel.textColor = UIColor.black
//        featureLabel.snp.makeConstraints { (make) in
//            make.height.greaterThanOrEqualTo(22)
//            make.width.greaterThanOrEqualTo(200)
//            make.left.equalTo(mainView).offset(5)
//            make.top.equalTo(featuredStoriesCV.snp.top).offset(3)
//        }
//        let divider = UIView()
//        divider.backgroundColor = UIColor.black
//        divider.alpha = 0.3
//        featuredStoriesCV.addSubview(divider)
//        divider.snp.makeConstraints { (make) in
//            make.height.equalTo(1)
//            make.left.equalTo(mainView.snp.left).offset(5)
//            make.width.equalTo(featuredStoriesCV.bounds.size.width - 40)
//            make.top.equalTo(featureLabel.snp.bottom).offset(-2)
//        }
        //featuredStoriesCV
        featuredStoriesCV.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(500)
        }
        
        let popularStoriesLabel = UILabel()
        mainView.addSubview(popularStoriesLabel)
        popularStoriesLabel.text = "Popular Stories"
        popularStoriesLabel.textAlignment = .left
        popularStoriesLabel.font = UIFont(name: "Avenir-Black", size: 18.0)
        popularStoriesLabel.textColor = UIColor.black
        popularStoriesLabel.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(200)
            make.left.equalTo(mainView).offset(5)
            make.top.equalTo(featuredStoriesCV.snp.bottom)
        }
        popularStoriesCV.snp.makeConstraints { (make) in
            make.top.equalTo(popularStoriesLabel.snp.bottom)
            make.left.equalToSuperview().offset(5)
            make.width.equalToSuperview()
            make.height.equalTo(220)
        }
        let moreToExploreLabel = UILabel()
        mainView.addSubview(moreToExploreLabel)
        moreToExploreLabel.text = "Collections"
        moreToExploreLabel.textAlignment = .left
        moreToExploreLabel.font = UIFont(name: "Avenir-Black", size: 30.0)
        moreToExploreLabel.textColor = UIColor.black
        moreToExploreLabel.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(200)
            make.left.equalTo(mainView).offset(5)
            make.top.equalTo(popularStoriesCV.snp.bottom)
        }
        //Categories Picks
        picksCV.snp.makeConstraints { (make) in
            make.top.equalTo(moreToExploreLabel.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(110)
        }

    }
}
 //MARK :- ExtensionVC (CollectionViews)

//MARK :- DownloadFunc
extension Discover {
    //This function downloads the categories in the DB ---category/ (IE: Drama / SciFi / Humor / History / etc...)
    func downloadPicks(completion: @escaping (Bool, Any?, Error?) -> Void) {
        let db = Firestore.firestore().collection("category")
        db.getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("there was an error : \(err)")
            } else {
                for document in (snapshot?.documents)! {
                    let categoryImage = document["categoryImage"] as! String
                    let categoryDescription = document["categoryDescription"] as! String
                    let categoryName = document["categoryName"] as! String
                    let category = document.documentID
                    let aCategory = Category(categoryDescription: categoryDescription,categoryImage:categoryImage, categoryName:categoryName, category: category)
                    completion(true,aCategory,nil)
                }
            }
        }
    }
    
    // This function downloads only stories where number of followers is greater than X (isGreaterThan)
    // To set to query stories that have big following
    func downloadPopularStories(completion: @escaping (Bool, Any?, Error?) -> Void) {
        let db = Firestore.firestore().collection("category").document("SciFi").collection("books")
        db.whereField("numberOfFollowers", isGreaterThan: 2).getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("there was an error : \(err)")
            } else {
                for document in (snapshot?.documents)! {
                    let title = document["title"] as! String
                    let author = document["author"] as! String
                    let plot = document["plot"] as! String
                    let coverImage = document["coverImage"] as! String
                    let numberOfLikes = document["numberOfLikes"] as! Int
                    let numberOfFollowers = document["numberOfFollowers"] as! Int
                    let root = document.documentID
                    let category = document["category"] as! String
                    let aBook = Book(title: title,author:author,numberOfLikes:numberOfLikes, numberOfFollowers:numberOfFollowers, coverImage: coverImage, plot:plot, root: root, category: category)
                    completion(true,aBook,nil)
                }
            }
        }
    }
    
    //This function downloads the featured categories ---/featured
    func downloadFeaturedStories(completion: @escaping (Bool, Any?, Error?) -> Void) {
        let db = Firestore.firestore().collection("featured")
        db.getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("there was an error : \(err)")
            } else {
                for document in (snapshot?.documents)! {
                    let categoryImage = document["categoryImage"] as! String
                    let categoryDescription = document["categoryDescription"] as! String
                    let categoryName = document["categoryName"] as! String
                    let category = document.documentID
                    let aCategory = Category(categoryDescription: categoryDescription,categoryImage:categoryImage, categoryName:categoryName, category: category)
                    completion(true,aCategory,nil)
                }
            }
        }
    }
    
    //This function downloads the book to be shown from Popular Stories

}
// NavBar Setup
extension Discover {
    
    
}

extension UIScrollView {
    func resizeScrollViewContentSize() {
        var contentRect = CGRect.zero
        
        for view in self.subviews {
            contentRect = contentRect.union(view.frame)
        }
        self.contentSize =  contentRect.size
    }
}

//extension Discover: UIScrollViewDelegate{
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0{
//            //scrolling down
//            changeTabBar(hidden: true, animated: true)
//            print("scrolling down")
//        }
//        else{
//            //scrolling up
//            changeTabBar(hidden: false, animated: true)
//            print("scrolling up")
//        }
//    }
//
//    func changeTabBar(hidden:Bool, animated: Bool){
//        let tabBar = self.navigationController?.navigationBar
//        let offset = (hidden ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.height - (tabBar?.frame.size.height)! )
//        if offset == tabBar?.frame.origin.y {return}
//        print("changing origin y position")
//        let duration:TimeInterval = (animated ? 0.5 : 0.0)
//        UIView.animate(withDuration: duration,
//                       animations: {tabBar!.frame.origin.y = offset},
//                       completion:nil)
//    }
//}
