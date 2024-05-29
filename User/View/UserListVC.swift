//
//  UserListVC.swift
//  Scifalre_Task
//
//  Created by mac on 27/05/24.
//

import UIKit

class UserListVC: UIViewController {
    
    @IBOutlet weak var userlistTableview: UITableView!
    @IBOutlet var tabView: [UIView]!
    @IBOutlet var tabLbl: [UILabel]!
    
    private var users: [UserDataModel] = []
    private var SelectTap = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewdelegate()
    }
    override func viewWillAppear(_ animated: Bool) {
        commonBttnAction(Tag: 0)
    }
    func TableViewdelegate(){
        userlistTableview.delegate = self
        userlistTableview.dataSource = self
        userlistTableview.registerCellNib(UserListTableViewCell.self)
    }
    func UiChange(Tag: Int){
        tabView[0].backgroundColor = UIColor(named: Tag == 0 ? "ButtonColor" : "NavigationColor")
        tabView[1].backgroundColor = UIColor(named: Tag == 1 ? "ButtonColor" : "NavigationColor")
        tabLbl[0].textColor = Tag != 0 ? .black : .white
        tabLbl[1].textColor = Tag != 1 ? .black : .white
    }
    func fetchAllUsers() {
        CoreDataManager.shared.fetchAllUsers { [weak self] users in
            guard let users = users else { return }
            self?.users = users
            DispatchQueue.main.async {
                self?.userlistTableview.reloadData()
            }
        }
    }
    func fetchPaticularUsers(){
        CoreDataManager.shared.fetchAllUsers { [weak self] users in
            guard let users = users else { return }
            let filteredUsers = users.filter { $0.islatestedit == "true" }
            self?.users = filteredUsers
            DispatchQueue.main.async {
                self?.userlistTableview.reloadData()
            }
        }
    }
    func commonBttnAction(Tag: Int){
        UiChange(Tag: Tag)
        SelectTap = Tag
        if Tag == 0{
            fetchAllUsers()
        } else{
            fetchPaticularUsers()
        }
    }
   
    @IBAction func userTap(_ sender: UIButton){
        commonBttnAction(Tag: sender.tag)
    }
    @IBAction func userListBack_Tapped(_ sender: UIButton){
        popViewController()
    }
    @IBAction func addUserdata_Tapped(_ sender: UIButton){
        pushViewController(identifier: "AddNewUserVC") 
    }
}
extension UserListVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let UserListcount = users.count
        if UserListcount == 0{
            userlistTableview.setEmptyMessage(SelectTap == 0 ? "No UserData Found!" : "No EditData Found!")
            return 0
        } else{
            userlistTableview.restore()
            return UserListcount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserListTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let Userdata = users[indexPath.row]
        cell.delegate = self // Set the delegate
        cell.emallbl.text = Userdata.email ?? ""
        cell.usernamelbl.text = Userdata.name ?? ""
        cell.phonenumberlbl.text = Userdata.mobile ?? ""
        cell.genderlbl.text = Userdata.gender ?? ""
        cell.stakviewHidden(Status: SelectTap == 0 ? false : true)
        
        return cell
    }
}
extension UserListVC: UserListTableViewCellDelegate {
    func editButtonTapped(_ cell: UserListTableViewCell) {
        guard let indexPath = userlistTableview.indexPath(for: cell) else { return }
        let Userdata = users[indexPath.row]
        if let vc = self.storyboard?.instantiateViewController(identifier: "AddNewUserVC") as? AddNewUserVC{
            vc.tupleVal.gender = Userdata.gender ?? ""
            vc.tupleVal.userId = Userdata.id ?? ""
            vc.tupleVal.name = Userdata.name ?? ""
            vc.tupleVal.gmail = Userdata.email ?? ""
            vc.tupleVal.phoneNumber = Userdata.mobile ?? ""
            vc.tupleVal.isedit = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
