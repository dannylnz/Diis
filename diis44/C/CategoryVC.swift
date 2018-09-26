import Firebase
import UIKit
import FirebaseFirestore

class CategoryVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    let mainView = UIView()
    let categoryNameLabel = UILabel()
    let categoryCoverImage = UIImageView()
    var booksCollectionView: UICollectionView!
    var books = [Book]()
    var CATEGORY_NAME = ""


    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
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
        mainView.backgroundColor = UIColor.lightGray
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        booksCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            booksCollectionView.backgroundColor = UIColor.red
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
            make.left.equalToSuperview().offset(12)
        }
        cell.image.downloadedFrom(link: books[indexPath.row].coverImage)
        //cell - Title
        cell.title.snp.makeConstraints { (make) in
            make.left.equalTo(cell.image.snp.right).offset(5)
            make.top.equalTo(cell.image.snp.top).offset(-5)
            make.width.greaterThanOrEqualTo(cell.snp.width).dividedBy(2)
            make.height.lessThanOrEqualTo(40)
        }
        cell.title.text = books[indexPath.row].title
        // cell - Author
          cell.author.snp.makeConstraints { (make) in
            make.left.equalTo(cell.image.snp.right).offset(5)
            make.top.equalTo(cell.title.snp.bottom).offset(1)
            make.width.greaterThanOrEqualTo(cell.snp.width).dividedBy(2)
            make.height.lessThanOrEqualTo(30)
        }
        cell.author.text = books[indexPath.row].author
        
        
        return cell
    }
    
    
}
