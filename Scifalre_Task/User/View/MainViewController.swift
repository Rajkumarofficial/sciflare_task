//
//  MainViewController.swift
//  Scifalre_Task
//
//  Created by mac on 27/05/24.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func user_Tapped(_ sender: UIButton){
        pushViewController(identifier: "UserListVC")
    }
    @IBAction func map_Tapped(_ sender: UIButton){
        pushViewController(identifier: "googleMapViewController") 
    }
}
