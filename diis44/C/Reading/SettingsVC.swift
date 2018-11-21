import UIKit
import Firebase
import SnapKit
import FirebaseFirestore
import FirebaseAuth

class SettingsVC: UIViewController, UITableViewDelegate,UITableViewDataSource {

    let mainView = UIScrollView()
    let settingsTVCategories = ["Login Screen","Get extra","Logout"]
    var settingsTV = UITableView()
    let logOutBtn = UIButton()
    let userUid = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reading"
        setupSettingsTableView()
        checkIfUserIsLogged()
    }
}
// MARK:- ViewSetup Properties
extension SettingsVC {
    
    func viewSetup() {
        mainView.backgroundColor = UIColor.blue
        navigationController?.title = "Settings"
        view.addSubview(mainView)
        mainView.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        settingsTV.snp.makeConstraints { (make) in
            make.top.equalTo(mainView.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(mainView.safeAreaLayoutGuide.snp.bottom)
            make.width.equalTo(mainView.safeAreaLayoutGuide.snp.width)
        }
    }
    func viewSetupGuest() {
        mainView.backgroundColor = UIColor.white
        navigationController?.title = "Settings Guest"
        view.addSubview(mainView)
        mainView.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        settingsTV.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalTo(self.view.safeAreaLayoutGuide.snp.width)
        }
    }
    fileprivate func checkIfUserIsLogged() {
        if Auth.auth().currentUser != nil {
            print("user is authenticated")
            viewSetup()
        } else {
            print("user is NOT authenticated")
            viewSetupGuest()
        }
    }
}

// MARK:- Table View Setup
extension SettingsVC {
    
    func setupSettingsTableView() {
        settingsTV.dataSource = self
        settingsTV.delegate = self
        settingsTV.register(settingsTableViewCell.self, forCellReuseIdentifier: "settingsTableViewCell")
        settingsTV.backgroundColor = UIColor.white
        mainView.addSubview(settingsTV)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsTVCategories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch userUid {
        
        case nil:
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsTableViewCell", for: indexPath) as! settingsTableViewCell
            cell.title.text = settingsTVCategories[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            cell.addSubview(cell.title)
            cell.title.snp.makeConstraints { (make) in
                make.left.equalTo(cell.snp.left).offset(5)
                make.centerY.equalTo(cell.snp.centerY)
                cell.title.sizeToFit()
            }
            return cell
        
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsTableViewCell", for: indexPath) as! settingsTableViewCell
            cell.title.text = settingsTVCategories[indexPath.row]
            cell.addSubview(cell.title)
            cell.title.snp.makeConstraints { (make) in
                cell.title.sizeToFit()
            }
            setupLogOutBtn()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    }
}

//MARK:- Functions
extension SettingsVC {
    
    func setupLogOutBtn() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        customView.backgroundColor = UIColor.red
        let logOutBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        logOutBtn.setTitle("Logout", for: .normal)
        logOutBtn.addTarget(self, action: #selector(logOutBtnClicked), for: .touchUpInside)
        customView.addSubview(logOutBtn)
        settingsTV.tableFooterView = customView
    }
    
    @objc func logOutBtnClicked(sender: UIButton) {
        if userUid == nil {
            print("there is no user authenticated")
        } else {
            do {
                try Auth.auth().signOut()
            } catch  {
                //Catch error
            }
            let tabBar = TabBarController()
            self.navigationController?.present(tabBar, animated: true, completion: nil)
        }
    }
}
