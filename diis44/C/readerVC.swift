import UIKit
import SnapKit

class readerVC:UIViewController,NSLayoutManagerDelegate {

    var mainView = UIView()
    var textView = UITextView()
    var fontBtn = UIButton()
    var chapterText = ""
    var fontSize:CGFloat = 21.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Snapkit ViewSetup
        viewSetup()
        navigationController?.hidesBarsOnTap = true
        navigationController?.navigationItem.title = "Origin"
        navigationController?.navigationItem.titleView?.tintColor = .black
        let fontIcon = UIImage(named: "fontIcon") as UIImage?
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: fontIcon  , style: .plain, target: self, action: #selector(fontChangingBtn))

        let scrollingView = UIScrollView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(view.bounds.size.width - 30), height: CGFloat(view.bounds.size.height - 100)))

        // we will set the contentSize after determining how many pages get filled with text
        //scrollingView.contentSize = CGSize(width: CGFloat((view.bounds.size.width - 20) * pageNumber), height: CGFloat(view.bounds.size.height - 20))
        scrollingView.backgroundColor = UIColor.white
        scrollingView.isPagingEnabled = true
        scrollingView.isDirectionalLockEnabled = true
        scrollingView.center = view.center
        scrollingView.bounces = false
        scrollingView.contentInsetAdjustmentBehavior = .never
        scrollingView.showsVerticalScrollIndicator = false
        scrollingView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollingView)
        
        let textString = chapterText
        
        let textStorage = NSTextStorage(string: textString)
        let textLayout = NSLayoutManager()
        textStorage.addLayoutManager(textLayout)
        textLayout.delegate = self
        
        var r = CGRect(x: 0, y: 0, width: scrollingView.frame.size.width, height: scrollingView.frame.size.height)
        var i: Int = 0
        
        // this is what we'll use to track the "progress" of filling the "screens of textviews"
        // each time through, we'll get the last Glyph rendered...
        // if it's equal to the total number of Glyphs, we know we're done
        var lastRenderedGlyph = 0
        while lastRenderedGlyph < textLayout.numberOfGlyphs {

            let textContainer = NSTextContainer(size: scrollingView.frame.size)
            textLayout.addTextContainer(textContainer)
            let textView = UITextView(frame: r, textContainer: textContainer)
            r.origin.x += r.width
            textView.textAlignment = .left
            //FontSize
            textView.font = .systemFont(ofSize: 21)
            textView.tag = i
            i += 1
            textView.contentSize = scrollingView.contentSize
            scrollingView.addSubview(textView)
            // get the last Glyph rendered into the current textContainer
            lastRenderedGlyph = NSMaxRange(textLayout.glyphRange(for: textContainer))
        }
        
        //last textView rect to set contentSize
        scrollingView.contentSize = CGSize(width: r.origin.x, height: r.size.height)
        print("Actual number of pages =", i)
    }
    @objc func fontChangingBtn() {
        
        print ("TODO: Increase or Decrease Font")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = false
        navigationController?.navigationBar.barTintColor = UIColor.clear
    }
    
}

extension readerVC {
     //snapkit View
    func viewSetup(){
        mainView.backgroundColor = UIColor.white
        self.view.addSubview(mainView)
        mainView.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
}
