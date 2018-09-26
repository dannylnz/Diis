import UIKit
import SnapKit

class TabBarController: UITabBarController {

    let discoverVC = Discover()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        discoverVC.title = "Discover"
        discoverVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        let controllers = [discoverVC]
        self.viewControllers = controllers
        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
        self.view.backgroundColor = UIColor.white
        
    }

}
