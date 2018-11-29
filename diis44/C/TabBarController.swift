import UIKit





class TabBarController: UITabBarController {
    let discoverVC = Discover()
    let readingVC = ReadingVC()
    
    let readIcon = UIImage(named: "read")
    let readIconClicked = UIImage(named: "readClicked")
    let discoverIcon = UIImage(named: "discover")
    let discoverIconClicked = UIImage(named: "discoverClicked")
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        discoverVC.title = "Discover"
        readingVC.title = "Reading"
        discoverVC.tabBarItem = UITabBarItem(title: "discover", image: discoverIcon?.withRenderingMode(.alwaysTemplate), selectedImage: discoverIconClicked?.withRenderingMode(.alwaysOriginal))
        readingVC.tabBarItem = UITabBarItem(title: "reading", image: readIcon?.withRenderingMode(.alwaysTemplate), selectedImage: readIconClicked?.withRenderingMode(.alwaysOriginal))
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        tabBar.tintColor = UIColor.black
        navigationController?.tabBarController?.tabBar.backgroundColor = UIColor.black
        navigationController?.tabBarController?.tabBar.barTintColor = UIColor.white
        let controllers = [discoverVC,readingVC]

        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        navigationController?.navigationBar.isHidden = false
    }
}
