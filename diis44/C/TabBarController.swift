import UIKit





class TabBarController: UITabBarController {
    let discoverVC = Discover()
    let profileVC = ProfileVC()
    
    let readIcon = UIImage(named: "read")
    let readIconClicked = UIImage(named: "readClicked")
    let discoverIcon = UIImage(named: "discover")
    let discoverIconClicked = UIImage(named: "discoverClicked")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        discoverVC.tabBarItem = UITabBarItem(title: "discover", image: discoverIcon, selectedImage: discoverIconClicked)
        profileVC.tabBarItem = UITabBarItem(title: "profile", image: readIcon, selectedImage: readIconClicked)
        tabBar.barTintColor = UIColor.black
        navigationController?.tabBarController?.tabBar.backgroundColor = UIColor.black
        let controllers = [discoverVC,profileVC]
        self.viewControllers = controllers
        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
    }
}
