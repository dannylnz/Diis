
import UIKit
import SnapKit
import Firebase
import ReadMoreTextView
import FirebaseFirestore

class BookVC: UIViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    var mainView = UIView()
    var chaptersCV:UICollectionView!
    var bookImage = UIImageView()
    var ImageLink = ""
    var TitleLbl = UILabel()
    var bookTitle = ""
    var AuthorLbl = UILabel()
    var bookAuthor = ""
    var PlotLbl = ReadMoreTextView()
    var bookPlot = ""
    var chapters = [Chapter]()
    var CATEGORY_NAME = ""
    var book:Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadChapters { (success, response, error) in
            if success {
                let chapter = response as! Chapter
                self.chapters.append(chapter)
                self.chaptersCV.reloadData()
                } else if let error = error {
                print (error)
            }
            print(self.chapters)
        }
        
    //setupView
        setupCollectionView()
        viewSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         tabBarController?.tabBar.isHidden = true
    }
    
}

//ViewSetup
extension BookVC {
    func viewSetup(){
    
        mainView.backgroundColor = UIColor.white
        self.view.addSubview(mainView)
        mainView.snp.updateConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.view.snp.bottom)
            make.width.equalToSuperview()
        }
        //image
        mainView.addSubview(bookImage)
        
        bookImage.snp.makeConstraints { (make) in
            make.top.equalTo(self.mainView.safeAreaLayoutGuide.snp.top).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(200)
            make.centerX.equalTo(mainView.snp.centerX)
        }
        bookImage.downloadedFrom(link: (book?.coverImage)!)
        bookImage.clipsToBounds = true
        bookImage.layer.cornerRadius = 4.0
        bookImage.contentMode = .scaleAspectFill
        //book - title
        mainView.addSubview(TitleLbl)
        TitleLbl.text = book?.title
        TitleLbl.textAlignment = .center
        TitleLbl.font = UIFont(name: "Avenir-Heavy", size: 19.0)
        TitleLbl.textColor = UIColor.black
        TitleLbl.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(30)
            make.width.greaterThanOrEqualTo(200)
            make.centerX.equalTo(bookImage.snp.centerX)
            make.top.equalTo(bookImage.snp.bottom).offset(5)
        }
        //book - author
        mainView.addSubview(AuthorLbl)
        AuthorLbl.text = book?.author
        AuthorLbl.textAlignment = .center
        AuthorLbl.font = UIFont(name: "Avenir", size: 15.0)
        AuthorLbl.textColor = UIColor.darkGray
        AuthorLbl.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(30)
            make.width.greaterThanOrEqualTo(200)
            make.centerX.equalTo(bookImage.snp.centerX)
            make.top.equalTo(TitleLbl.snp.bottom)
        }
        //book - plot
        mainView.addSubview(PlotLbl)
        PlotLbl.text = book?.plot
        PlotLbl.textAlignment = .center
        PlotLbl.font = UIFont(name: "Avenir-Light", size: 12.0)
        PlotLbl.textColor = UIColor.lightGray
        PlotLbl.shouldTrim = true
        PlotLbl.maximumNumberOfLines = 3
        PlotLbl.attributedReadMoreText = NSAttributedString(string: "... Read more")
        PlotLbl.attributedReadLessText = NSAttributedString(string: " Read less")
        PlotLbl.layoutSubviews()
        PlotLbl.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(30)
            make.width.equalTo(bookImage.snp.width).multipliedBy(2)
            make.centerX.equalTo(bookImage.snp.centerX)
            make.top.equalTo(AuthorLbl.snp.bottom)
        }
        
        //CollectionView
        chaptersCV.snp.makeConstraints { (make) in
            make.top.equalTo(PlotLbl.snp.bottom).offset(5)
            make.bottom.equalTo(mainView.snp.bottom)
            make.width.equalToSuperview()
        }
        
    }
}

//collectionView - Chapters
extension BookVC{
    
    func setupCollectionView() {
        //layoutCollectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        layout.minimumLineSpacing = 15.0
        layout.minimumInteritemSpacing = 3.0
        chaptersCV = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        chaptersCV.dataSource = self
        chaptersCV.delegate = self
        chaptersCV.register(chapterCell.self, forCellWithReuseIdentifier: "chapterCell")
        chaptersCV.backgroundColor = UIColor.white
        mainView.addSubview(chaptersCV)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.width - 10, height: 50)
        return size
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapters.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chapterCell", for: indexPath) as! chapterCell
        cell.backgroundColor = .white
        cell.addSubview(cell.chapterTitle)
        cell.chapterTitle.text = chapters[indexPath.row].title
        cell.chapterTitle.snp.makeConstraints { (make) in
            make.width.equalTo(cell.snp.width).offset(-10)
            make.height.equalTo(cell.snp.height)
            make.centerX.equalTo(cell.snp.centerX)
            make.left.equalTo(cell.snp.left).offset(5)
        }
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
        let vc = readerVC()
        
        vc.chapterText = chapters[indexPath.row].value
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationItem.backBarButtonItem?.title = "<"
        navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.black
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BookVC{
    
    func downloadChapters(completion: @escaping (Bool, Any?, Error?) -> Void) {
        let db = Firestore.firestore().collection("category").document(CATEGORY_NAME).collection("books").document((book?.root)!).collection("chapters")
        db.getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("there was an error : \(err)")
            } else {
                for chapter in (snapshot?.documents)! {
                    let chapterTitle = chapter["chapterTitle"] as! String
                    let chapter = chapter["chapter"] as! String
                    let chapterRoot = db.collectionID
                    let aChapter = Chapter(title: chapterTitle, value: chapter, root:chapterRoot)
                    

                    
                    
                    completion(true,aChapter,nil)
                }
            }
        }
    }
    
}

