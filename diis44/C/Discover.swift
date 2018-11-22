import UIKit
import Firebase
import SnapKit
import FirebaseFirestore
import CardsLayout

class Discover: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    let mainView = UIScrollView()
    var picksCV:UICollectionView!
    var popularStoriesCV:UICollectionView!
    var featuredStoriesCV:UICollectionView!
    var books = [Book]()
    private var picksCategory = [Category]()
    private var popularStoriesCategory = [Book]()
    private var featuredStoriesCategory = [Category]()

    override func viewDidLoad() {
        self.title = "Discover"
        navigationController?.tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
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


    
    override func viewDidAppear(_ animated: Bool) {
        self.title = "Discover"
        tabBarController?.tabBar.isHidden = false
        

    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Discover"
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = false
        super.viewWillAppear(animated)
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
            make.height.equalTo(110)
        }
        let popularStoriesLabel = UILabel()
        mainView.addSubview(popularStoriesLabel)
        popularStoriesLabel.text = "Popular Stories"
        popularStoriesLabel.textAlignment = .left
        popularStoriesLabel.font = UIFont(name: "Baskerville", size: 18.0)
        popularStoriesLabel.textColor = UIColor.darkGray
        popularStoriesLabel.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(200)
            make.left.equalTo(mainView).offset(5)
            make.top.equalTo(picksCV.snp.bottom)
        }
        popularStoriesCV.snp.makeConstraints { (make) in
            make.top.equalTo(popularStoriesLabel.snp.bottom)
            make.left.equalToSuperview().offset(5)
            make.width.equalToSuperview()
            make.height.equalTo(220)
        }
        let moreToExploreLabel = UILabel()
        mainView.addSubview(moreToExploreLabel)
        moreToExploreLabel.text = "Featured Stories"
        moreToExploreLabel.textAlignment = .left
        moreToExploreLabel.font = UIFont(name: "Baskerville-Bold", size: 30.0)
        moreToExploreLabel.textColor = UIColor.black
        moreToExploreLabel.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(200)
            make.left.equalTo(mainView).offset(5)
            make.top.equalTo(popularStoriesCV.snp.bottom)
        }
        //featuredStoriesCV
//        let tabBarHeight = tabBarController?.tabBar.bounds.size.height ?? 0
        featuredStoriesCV.snp.makeConstraints { (make) in
            make.top.equalTo(moreToExploreLabel.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
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
        picksCV.showsHorizontalScrollIndicator = false
        picksCV.register(picksCell.self, forCellWithReuseIdentifier: "picksCell")
        picksCV.backgroundColor = UIColor.white
        mainView.addSubview(picksCV)
    }
    //MARK :- popularStoriesCV
    func setupPopularStoriesCollectionView() {
        //layoutCollectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(-50, 5, 0, 10)
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 3.0
        popularStoriesCV = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        popularStoriesCV.isPagingEnabled = true
        popularStoriesCV.dataSource = self
        popularStoriesCV.delegate = self
        popularStoriesCV.tag = 1
        popularStoriesCV.alwaysBounceHorizontal = true
        popularStoriesCV.register(popularStoriesCell.self, forCellWithReuseIdentifier: "popularStoriesCell")
        popularStoriesCV.backgroundColor = UIColor.white
        mainView.addSubview(popularStoriesCV)
    }
    //MARK:- FeaturedStoriesCV
    func setupFeaturedStoriesCollectionView() {
        //layoutCollectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 3.0
        featuredStoriesCV = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        featuredStoriesCV.isPagingEnabled = false
        featuredStoriesCV.dataSource = self
        featuredStoriesCV.delegate = self
        featuredStoriesCV.tag = 2
        featuredStoriesCV.backgroundColor = .white
        featuredStoriesCV.alwaysBounceHorizontal = true
        featuredStoriesCV.showsHorizontalScrollIndicator = false
        featuredStoriesCV.register(featuredCell.self, forCellWithReuseIdentifier: "featuredStoriesCell")
        mainView.addSubview(featuredStoriesCV)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView.tag {
        case 0:
            let size = CGSize(width: 220, height: picksCV.bounds.size.height - 5)
            return size
        case 1:
            let size = CGSize(width: 110, height: 160)
            return size
        case 2:
            //todo cell card
            let size = CGSize(width: featuredStoriesCV.bounds.size.width - 40, height: featuredStoriesCV.bounds.size.height - 20)
            
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
        case 2:
            return featuredStoriesCategory.count
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
            cell.image.layer.masksToBounds = true
            cell.image.contentMode = .scaleAspectFill
            cell.layer.cornerRadius = 20.0
            cell.image.layer.cornerRadius = 20.0
            
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
            cell.bookTitleLbl.text = popularStoriesCategory[indexPath.row].title
            cell.bookAuthorLbl.text = popularStoriesCategory[indexPath.row].author
            cell.image.downloadedFrom(link: popularStoriesCategory[indexPath.row].coverImage)
            cell.image.layer.masksToBounds = true
            cell.image.contentMode = .scaleAspectFill
            cell.image.layer.cornerRadius = 12.0
            cell.layer.cornerRadius = 12.0
            cell.addSubview(cell.image)
            cell.addSubview(cell.bookTitleLbl)
            cell.addSubview(cell.bookAuthorLbl)

            cell.image.snp.makeConstraints { (make) in
                make.height.equalTo(cell.snp.height)
                make.width.equalTo(cell.snp.width)
            }
            cell.bookTitleLbl.snp.makeConstraints { (make) in
                make.height.lessThanOrEqualTo(30)
                make.width.equalTo(cell.snp.width)
                make.centerX.equalTo(cell.snp.centerX)
                make.top.equalTo(cell.snp.bottom).offset(3)
                
            }
            cell.bookAuthorLbl.snp.makeConstraints { (make) in
                make.height.lessThanOrEqualTo(40)
                make.width.equalTo(cell.snp.width)
                make.centerX.equalTo(cell.snp.centerX)
                make.top.equalTo(cell.bookTitleLbl.snp.bottom).offset(-3)
            }
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featuredStoriesCell", for: indexPath) as! featuredCell
            cell.categoryName.text = featuredStoriesCategory[indexPath.row].categoryName
            cell.categoryDescription.text =  featuredStoriesCategory[indexPath.row].categoryDescription
            cell.image.downloadedFrom(link: featuredStoriesCategory[indexPath.row].categoryImage)
            cell.image.layer.masksToBounds = true
            cell.image.contentMode = .scaleAspectFill
            cell.backgroundView = cell.image
            cell.image.layer.cornerRadius = 20.0
            cell.layer.cornerRadius = 20.0
            cell.addSubview(cell.image)
            cell.addSubview(cell.categoryName)
            cell.addSubview(cell.categoryDescription)
            cell.categoryName.snp.makeConstraints { (make) in
                make.height.lessThanOrEqualTo(40)
                make.width.greaterThanOrEqualTo(40)
                make.top.equalTo(cell.snp.centerY)
                make.left.equalTo(cell.snp.left).offset(15)
            }
            let divider = UIView()
            divider.backgroundColor = UIColor.white
            divider.alpha = 0.4
            cell.addSubview(divider)
            divider.snp.makeConstraints { (make) in
                make.height.equalTo(1)
                make.width.equalTo(cell.snp.width).offset(-50)
                make.left.equalTo(cell.categoryName.snp.left)
                make.top.equalTo(cell.categoryName.snp.bottom).offset(1)
            }
            cell.categoryDescription.snp.makeConstraints { (make) in
                make.height.greaterThanOrEqualTo(40)
                make.left.equalTo(cell.categoryName.snp.left)
                make.right.equalTo(cell.snp.right).offset(-20)
                make.top.equalTo(divider.snp.bottom).offset(1)
                
            }
            
            
            return cell
      
        default:
            fatalError()
        }
        
        

        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 0:
            let vc = CategoryVC()
            vc.categoryNameLabel.text = picksCategory[indexPath.row].categoryName
            vc.CATEGORY_NAME = picksCategory[indexPath.row].category
            vc.tabBarController?.title = picksCategory[indexPath.row].categoryName
            UINavigationBar.appearance().isHidden = true
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = BookVC()
            vc.hidesBottomBarWhenPushed = true
            vc.book = books[indexPath.row]
            vc.ImageLink = books[indexPath.row].coverImage
            vc.bookAuthor = books[indexPath.row].author
            vc.bookTitle = books[indexPath.row].title
            vc.bookPlot = books[indexPath.row].plot
            vc.tabBarController?.title? = ""
            vc.CATEGORY_NAME = books[indexPath.row].category
            vc.bookId = books[indexPath.row].root
            vc.bookLink = "/category/\(vc.CATEGORY_NAME)/books/\(books[indexPath.row].root)"
            self.navigationController?.pushViewController(vc, animated: true)
        
        case 2:
            let vc = FeaturedCategoryVC()
            vc.categoryCoverImageLink = featuredStoriesCategory[indexPath.row].categoryImage
            vc.CATEGORY_NAME = featuredStoriesCategory[indexPath.row].category
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }

        
    }
}
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
    func navBarSetup(){
        tabBarController?.title = "Discover"
        tabBarController?.tabBar.barTintColor = UIColor.white
        tabBarController?.tabBar.layer.shadowColor = UIColor.darkGray.cgColor
        tabBarController?.tabBar.layer.shadowOpacity = 0.2
        tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0, height: -4.5)
        tabBarController?.tabBar.layer.shadowRadius = 3
    }
}
