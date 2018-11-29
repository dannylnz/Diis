import UIKit
import Firebase
import SnapKit
import FirebaseFirestore
import CardsLayout
import Hero

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
        layout.minimumInteritemSpacing = 12.0
        let customLayout = CardsCollectionViewLayout()
        featuredStoriesCV = UICollectionView(frame: self.view.frame, collectionViewLayout: customLayout)
        customLayout.itemSize = CGSize(width: featuredStoriesCV.bounds.size.width / 1.6, height: featuredStoriesCV.bounds.size.height / 2)
        featuredStoriesCV.isPagingEnabled = true
        featuredStoriesCV.showsHorizontalScrollIndicator = false
        featuredStoriesCV.dataSource = self
        featuredStoriesCV.delegate = self
        featuredStoriesCV.tag = 2
        featuredStoriesCV.backgroundColor = .white
        let collectionViewBGImage = UIImage(named: "collectionViewBG")
        let collectionViewBG = UIImageView(image: collectionViewBGImage)
        featuredStoriesCV.backgroundView = collectionViewBG
        collectionViewBG.contentMode = .scaleToFill
        collectionViewBG.alpha = 0.1
        featuredStoriesCV.alwaysBounceHorizontal = true
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
            let size = CGSize(width: featuredStoriesCV.bounds.size.width - 90, height: featuredStoriesCV.bounds.size.height - 300)
            return size
        default:
            break
        }
        let size = CGSize(width: 100, height: 100)
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
            cell.image.layer.cornerRadius = 20.0
            cell.layer.cornerRadius = 20.0
            cell.image.contentMode = .scaleAspectFill
            cell.backgroundView = cell.image
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
            vc.hidesBottomBarWhenPushed = true
            vc.categoryNameLabel.text = picksCategory[indexPath.row].categoryName
            vc.CATEGORY_NAME = picksCategory[indexPath.row].category
            vc.tabBarController?.title = picksCategory[indexPath.row].categoryName
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
