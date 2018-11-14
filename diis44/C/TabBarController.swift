import UIKit





class TabBarController: UITabBarController {
    let discoverVC = Discover()
    
    let readIcon = UIImage(named: "read")
    let readIconClicked = UIImage(named: "readClicked")
    let discoverIcon = UIImage(named: "discover")
    let discoverIconClicked = UIImage(named: "discoverClicked")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        discoverVC.tabBarItem = UITabBarItem(title: "discover", image: discoverIcon, selectedImage: discoverIconClicked)
        tabBar.barTintColor = UIColor.black
        navigationController?.tabBarController?.tabBar.backgroundColor = UIColor.black
        let controllers = [discoverVC]
        self.viewControllers = controllers
        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
    }
}
