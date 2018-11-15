import UIKit
import Firebase
import SnapKit
import FirebaseFirestore

class Discover: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    let mainView = UIScrollView()
    var picksCV:UICollectionView!
    var popularStoriesCV:UICollectionView!
    private var picksCategory = [Category]()
    private var popularStoriesCategory = [Book]()
    
    override func viewDidLoad() {
        self.title = "Discover"
        tabBarController?.tabBar.isHidden = false
        super.viewDidLoad()
        downloadPopularStories { (success, response, error) in
            if success {
                let pick = response as! Book
                self.popularStoriesCategory.append(pick)
                self.popularStoriesCV.reloadData()
                print ("This is book:")
                print(pick)
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
        
        setupCollectionView()
        setupPopularStoriesCollectionView()
        viewSetup()
        navBarSetup()
    }
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.title = "Discover"
//        tabBarController?.tabBar.isHidden = false
        setTabBarHidden(false, animated: true, duration: 0.2)
    }
}
//view layout
extension Discover {
    func viewSetup() {
        mainView.backgroundColor = UIColor.white
        view.addSubview(mainView)
        mainView.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            
        }
        picksCV.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(100)
        }
        let popularStoriesLabel = UILabel()
        mainView.addSubview(popularStoriesLabel)
        popularStoriesLabel.text = "Popular Stories"
        popularStoriesLabel.textAlignment = .left
        popularStoriesLabel.font = UIFont(name: "Avenir", size: 18.0)
        popularStoriesLabel.textColor = UIColor.black
        popularStoriesLabel.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(200)
            make.left.equalTo(mainView).offset(5)
            make.top.equalTo(picksCV.snp.bottom)
        }
        popularStoriesCV.snp.makeConstraints { (make) in
            make.top.equalTo(popularStoriesLabel.snp.bottom).offset(5)
            make.width.equalToSuperview()
            make.height.equalTo(200)
        }
    }
}
 //MARK :- ExtensionVC (CollectionViews)
extension Discover {
 //MARK :- picksCV
    func setupCollectionView() {
        //layoutCollectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        layout.minimumLineSpacing = 15.0
        layout.minimumInteritemSpacing = 3.0
        picksCV = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        picksCV.dataSource = self
        picksCV.delegate = self
        picksCV.tag = 0
        picksCV.register(picksCell.self, forCellWithReuseIdentifier: "picksCell")
        picksCV.backgroundColor = UIColor.white
        mainView.addSubview(picksCV)
    }
    
    //MARK :- popularStoriesCV
    func setupPopularStoriesCollectionView() {
        //layoutCollectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(-25, 10, 0, 10)
        layout.minimumLineSpacing = 35.0
        layout.minimumInteritemSpacing = 35.0
        popularStoriesCV = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        popularStoriesCV.dataSource = self
        popularStoriesCV.delegate = self
        popularStoriesCV.tag = 1
        popularStoriesCV.register(popularStoriesCell.self, forCellWithReuseIdentifier: "popularStoriesCell")
        popularStoriesCV.backgroundColor = UIColor.white
        mainView.addSubview(popularStoriesCV)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView.tag {
        case 0:
            let size = CGSize(width: 220, height: 100)
            return size
        case 1:
            let size = CGSize(width: 90, height: 160)
            return size
        default:
            break
        }
        
        let size = CGSize(width: 100, height: 200)
        return size
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return picksCategory.count
        case 1:
            return popularStoriesCategory.count
        default:
            break
        }
        
       return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picksCell", for: indexPath) as! picksCell
            cell.categoryName.text = picksCategory[indexPath.row].categoryName
            cell.image.downloadedFrom(link: picksCategory[indexPath.row].categoryImage)
            cell.backgroundView = cell.image
            cell.image.mask?.clipsToBounds = true
            cell.layer.cornerRadius = 4.0
            cell.addSubview(cell.image)
            cell.addSubview(cell.categoryName)
            cell.categoryName.snp.makeConstraints { (make) in
                make.height.greaterThanOrEqualTo(40)
                make.width.equalTo(cell.snp.width)
                make.centerX.equalTo(cell.snp.centerX)
                make.centerY.equalTo(cell.snp.centerY)
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularStoriesCell", for: indexPath) as! popularStoriesCell
            cell.backgroundColor = .white
            cell.bookTitleLbl.text = popularStoriesCategory[indexPath.row].title
            cell.bookAuthorLbl.text = popularStoriesCategory[indexPath.row].author
            cell.image.downloadedFrom(link: popularStoriesCategory[indexPath.row].coverImage)
            cell.backgroundView = cell.image
            cell.image.mask?.clipsToBounds = false
            cell.layer.cornerRadius = 4.0
            cell.addSubview(cell.image)
            cell.addSubview(cell.bookTitleLbl)
            cell.addSubview(cell.bookAuthorLbl)

            cell.image.snp.makeConstraints { (make) in
                make.height.equalTo(cell.snp.height)
                make.width.equalTo(100)
            }
            cell.bookTitleLbl.snp.makeConstraints { (make) in
                make.height.greaterThanOrEqualTo(40)
                make.width.equalTo(cell.snp.width)
                make.centerX.equalTo(cell.snp.centerX)
                make.top.equalTo(cell.snp.bottom).offset(-10)
                
            }
            cell.bookAuthorLbl.snp.makeConstraints { (make) in
                make.height.greaterThanOrEqualTo(40)
                make.width.equalTo(cell.snp.width)
                make.centerX.equalTo(cell.snp.centerX)
                make.top.equalTo(cell.bookTitleLbl.snp.bottom)
            }
            return cell
            
        default:
            fatalError()
        }
        
        

        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = CategoryVC()
        vc.categoryNameLabel.text = picksCategory[indexPath.row].categoryName
        vc.CATEGORY_NAME = picksCategory[indexPath.row].category
        vc.tabBarController?.title = picksCategory[indexPath.row].categoryName
        UINavigationBar.appearance().isHidden = true
        navigationController?.pushViewController(vc, animated: true)
        
    }
}



//MARK :- DownloadFunc
extension Discover {
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
                    let aBook = Book(title: title,author:author,numberOfLikes:numberOfLikes, numberOfFollowers:numberOfFollowers, coverImage: coverImage, plot:plot, root: root)
                    completion(true,aBook,nil)
                }
            }
        }
    }
    
    
}
































// NavBar Setup
extension Discover {
    func navBarSetup(){
        tabBarController?.title = "Discover"
        tabBarController?.tabBar.barTintColor = UIColor.white
        tabBarController?.tabBar.layer.masksToBounds = false
        tabBarController?.tabBar.layer.shadowColor = UIColor.darkGray.cgColor
        tabBarController?.tabBar.layer.shadowOpacity = 0.2
        tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0, height: -4.5)
        tabBarController?.tabBar.layer.shadowRadius = 3
    }
}
