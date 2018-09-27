import Firebase
import UIKit
import FirebaseFirestore
import ReadMoreTextView

class CategoryVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    let mainView = UIScrollView()
    let categoryNameLabel = UILabel()
    let categoryCoverImage = UIImageView()
    var booksCollectionView: UICollectionView!
    var books = [Book]()
    var CATEGORY_NAME = ""


    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        tabBarController?.title = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadBooks { (success, response, error) in
            if success {
                let book = response as! Book
                print(book)
                self.books.append(book)
                self.booksCollectionView.reloadData()
            } else if let error = error {
                print (error)
            }
        }
        setupCollectionView()
        viewSetup()
    }
}






//DownloadBooks
extension CategoryVC{
    func downloadBooks(completion: @escaping (Bool, Any?, Error?) -> Void) {
        let db = Firestore.firestore().collection("category").document(CATEGORY_NAME).collection("books")
        db.getDocuments { (snapshot, error) in
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















//viewSetup
extension CategoryVC {
    func viewSetup() {
        self.view.addSubview(mainView)
        mainView.backgroundColor = UIColor.white
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        booksCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)

        }
        
        
    }
}


















//collection View
extension CategoryVC {
    func setupCollectionView() {
        //layoutCollectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5)
        layout.minimumLineSpacing = 15.0
        layout.minimumInteritemSpacing = 3.0
        booksCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        booksCollectionView.dataSource = self
        booksCollectionView.delegate = self
        booksCollectionView.register(bookCell.self, forCellWithReuseIdentifier: "booksCell")
        booksCollectionView.backgroundColor = UIColor.white
        mainView.addSubview(booksCollectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.width - 10, height: 130)
        return size
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "booksCell", for: indexPath) as! bookCell
        cell.backgroundColor = UIColor.white
        cell.addSubview(cell.image)
        cell.addSubview(cell.author)
        cell.addSubview(cell.title)
        cell.image.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(120)
            make.centerY.equalTo(cell.snp.centerY)
            make.left.equalToSuperview().offset(22)
        }
        cell.image.downloadedFrom(link: books[indexPath.row].coverImage)
        //cell - Title
        cell.title.snp.makeConstraints { (make) in
            make.left.equalTo(cell.image.snp.right).offset(10)
            make.top.equalTo(cell.image.snp.top).offset(15)
            make.width.lessThanOrEqualTo(100)
            make.height.lessThanOrEqualTo(40)
        }
        cell.title.text = books[indexPath.row].title
        // cell - Author
          cell.author.snp.makeConstraints { (make) in
            make.left.equalTo(cell.image.snp.right).offset(10)
            make.top.equalTo(cell.title.snp.bottom).offset(1)
            make.width.lessThanOrEqualTo(100)
            make.height.lessThanOrEqualTo(25)
        }
        cell.author.text = books[indexPath.row].author
        
        // Cell Shadow
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = BookVC()
        vc.hidesBottomBarWhenPushed = true
        vc.book = books[indexPath.row]
        vc.ImageLink = books[indexPath.row].coverImage
        vc.bookAuthor = books[indexPath.row].author
        vc.bookTitle = books[indexPath.row].title
        vc.bookPlot = books[indexPath.row].plot
        vc.tabBarController?.title? = ""
        vc.CATEGORY_NAME = CATEGORY_NAME
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
