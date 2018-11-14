import UIKit
import Firebase
import SnapKit
import FirebaseFirestore

class Discover: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    let mainView = UIScrollView()
    var picksCV:UICollectionView!
    private var picksCategory = [Category]()
    
    override func viewDidLoad() {
        tabBarController?.tabBar.isHidden = false
        super.viewDidLoad()
        downloadPicks { (success, response, error) in
            if success {
                let pick = response as! Category
                print(pick)
                self.picksCategory.append(pick)
                self.picksCV.reloadData()
            } else if let error = error {
                print (error)
            }
        }
        setupCollectionView()
        viewSetup()
        navBarSetup()
    }
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.title = "Discover"
        tabBarController?.tabBar.isHidden = false
        
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
        popularStoriesLabel.font = UIFont(name: "Avenir", size: 16.0)
        popularStoriesLabel.textColor = UIColor.black
        popularStoriesLabel.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(200)
            make.left.equalTo(mainView).offset(5)
            make.top.equalTo(picksCV.snp.bottom)
        }
    }
}
//MARK :- picksCV
extension Discover {
    
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
        picksCV.register(picksCell.self, forCellWithReuseIdentifier: "picksCell")
        picksCV.backgroundColor = UIColor.white
        mainView.addSubview(picksCV)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 220, height: 100)
        return size
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picksCategory.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
