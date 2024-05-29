//
//  UserListTableViewCell.swift
//  Scifalre_Task
//
//  Created by mac on 28/05/24.
//

import UIKit

protocol UserListTableViewCellDelegate: AnyObject {
    func editButtonTapped(_ cell: UserListTableViewCell)
}

class UserListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernamelbl: UILabel!
    @IBOutlet weak var emallbl: UILabel!
    @IBOutlet weak var phonenumberlbl: UILabel!
    @IBOutlet weak var genderlbl: UILabel!
    
    @IBOutlet weak var editBttn: UIButton!
    @IBOutlet weak var editStackView: UIStackView!
    
    weak var delegate: UserListTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func stakviewHidden(Status: Bool){
        editStackView.isHidden = Status
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
            delegate?.editButtonTapped(self)
        }
    
}
