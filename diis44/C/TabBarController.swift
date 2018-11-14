import UIKit





class TabBarController: UITabBarController {
    let discoverVC = Discover()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        discoverVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        tabBar.barTintColor = UIColor.red
        navigationController?.tabBarController?.tabBar.backgroundColor = UIColor.blue
        let controllers = [discoverVC]
        self.viewControllers = controllers
        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
    }
}
