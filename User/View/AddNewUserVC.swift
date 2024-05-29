//
//  AddNewUserVC.swift
//  Scifalre_Task
//
//  Created by mac on 27/05/24.
//

import UIKit

class AddNewUserVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nametF: UITextField!
    @IBOutlet weak var numberF: UITextField!
    @IBOutlet weak var emailtF: UITextField!
    @IBOutlet var genderimg: [UIImageView]!
    
    @IBOutlet weak var submitLbl: UILabel!
    
    var ismale = false
    var isFemale = false
    
    var tupleVal = (name: String(), phoneNumber: String(), gmail: String(), userId: String(), gender: String(), isedit: Bool())
    
    private var viewModel = UserViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        if tupleVal.isedit == true{
            editdataLoad()
        }
        setupTextFields()
        submitLbl.text = tupleVal.isedit ? "Edit" : "Submit"
    }
    func editdataLoad(){
        nametF.text = tupleVal.name
        numberF.text = tupleVal.phoneNumber
        emailtF.text = tupleVal.gmail
        if tupleVal.gender.lowercased() == "male"{
            ismale = true
            isFemale = false
        } else{
            ismale = false
            isFemale = true
        }
        updategenderStatus()
    }
    private func setupTextFields(){
        [nametF,numberF,emailtF].forEach({$0?.delegate = self})
        [nametF,numberF].forEach({$0?.returnKeyType = .next})
        emailtF.returnKeyType = .done
    }
    @IBAction func AddUserBack_Tapped(_ sender: UIButton){
        tupleVal.isedit = false
        popViewController()
    }
    @IBAction func newUser_Tapped(_ sender: UIButton){
        validateUserdataTF { isvalidate, VaidateMsg in
            if isvalidate{
                if self.tupleVal.isedit == true{
                    self.editUserapi()
                } else{
                    self.newUserAddapi()
                }
            }else{
                self.showCommonAlert(message: VaidateMsg, tittle: "Error")
            }
        }
    }
    @IBAction func gender_Tapped(_ sender: UIButton){
        let tag = sender.tag
        switch tag {
            case 0:
                ismale = true
                isFemale = false
            default:
                ismale = false
                isFemale = true
        }
        tupleVal.gender = tag == 0 ? "Male" : "Female"
        updategenderStatus()
    }
    private func updategenderStatus(){
        genderimg[0].image = UIImage(named: ismale ? "radio-Select" : "radio-Unselect")
        genderimg[1].image = UIImage(named: isFemale ? "radio-Select" : "radio-Unselect")
    }
    func newUserAddapi(){
        let name = nametF.text ?? ""
        let Number = numberF.text ?? ""
        let email = emailtF.text ?? ""
        viewModel.newUserData(UserName: name, Email: email, PhoneNumber: Number, gender: tupleVal.gender) { message, status in
            DispatchQueue.main.async {
                self.showokAlert(message: "UserData Added successfully")
            }
        } onFailure: { errmsg in
            print(errmsg)
        }
    }
    func editUserapi(){
        let name = nametF.text ?? ""
        let Number = numberF.text ?? ""
        let email = emailtF.text ?? ""
        viewModel.editUserData(UserName: name, Email: email, PhoneNumber: Number, gender: tupleVal.gender, UserId: tupleVal.userId) { message, status in
            DispatchQueue.main.async {
                self.showokAlert(message: "UserData Edited successfully")
            }
        } onFailure: { errmsg in
            print(errmsg)
        }
    }
    func showokAlert(message: String) {
        let alert = UIAlertController(title: "User Data", message: message, preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Done", style: .default) { _ in
            self.popViewController()
        }
        alert.addAction(logoutAction)
        present(alert, animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case nametF :
                nametF.becomeFirstResponder()
                break
            case numberF :
                numberF.becomeFirstResponder()
                break
            default:
                hideKeyboardWhenTappedAround()
                break
        }
        return true
    }
    
    private func isValidUsername(_ username: String) -> Bool {
        let usernameRegex = "^[a-zA-Z0-9_]$"
        return NSPredicate(format: "SELF MATCHES %@", usernameRegex).evaluate(with: username)
    }
    private func isValidmobilenumber(_ mobilenumber: String) -> Bool {
        // Updated to check for at least 10 digits
        let mobileNumberRegex = "^[0-9]$"
        return NSPredicate(format: "SELF MATCHES %@", mobileNumberRegex).evaluate(with: mobilenumber)
    }
    private func validateUserdataTF(closure: @escaping (Bool, String) -> Swift.Void) -> () {
        if nametF.text!.isEmpty {
            closure(false,"Please enter a username")
            return
        }
        if isValidUsername(nametF.text ?? ""){
            closure(false,"Username must be at least 3 characters long and contain only alphanumeric characters and underscores")
            return
        }
        if numberF.text!.isEmpty{
            closure(false, "Please enter Mobile Number")
            return
        }
        if isValidmobilenumber(numberF.text ?? ""){
            closure(false,"Please enter valid mobile number")
            return
        }
        if emailtF.text!.isEmpty {
            closure(false, "Please enter an email address")
            return
        }
        if !emailtF.text!.isEmail{
            closure(false, "Please enter a valid email address")
            return
        }
        if tupleVal.gender == ""{
            closure(false, "Please Select Gender")
            return
        }
        closure(true, "Success")
    }
}
