//
//  UserViewModel.swift
//  Scifalre_Task
//
//  Created by apple on 24/05/24.
//

import Foundation
import Alamofire

class UserViewModel{
    
    var model: UserDataModelRC?
    let ApiUrl = "https://crudcrud.com/api/c71ea120bcd44394a173c5451036ffe3/unicorns"
    
    func newUserData(UserName : String,Email : String,PhoneNumber : String, gender : String,onSuccess: @escaping (String,Int) -> (), onFailure: @escaping (String) -> ()){
        print(ApiUrl)
        let param: [String: Any] = ["name": UserName,
                                    "email": Email,
                                    "mobile" : PhoneNumber,
                                    "gender" : gender]
        do {
            try Service.PostRequest(url: ApiUrl, parameter: param) { success, message, json in
                if success {
                    self.model = UserDataModelRC(fromJson: json)
                    let id = self.model?.id ?? ""
                    CoreDataManager.shared.saveUserData(userData: ["name": UserName, "mobile": PhoneNumber, "email": Email, "gender": gender, "id": id,"islatestedit": "false"])
                    onSuccess(json["message"].stringValue, json["resultCount"].intValue)
                } else {
                    onFailure(message)
                }
            }
        } catch {
            onFailure("Request failed with error: \(error.localizedDescription)")
        }
    }
    func editUserData(UserName : String,Email : String,PhoneNumber : String, gender : String,UserId: String, onSuccess: @escaping (String,Int) -> (), onFailure: @escaping (String) -> ()){
        let Api = ApiUrl + "/\(UserId)"
        let param: Parameters = ["name": UserName,
                                    "email": Email,
                                    "mobile" : PhoneNumber,
                                    "gender" : gender]
        print("shewhngierg",Api)
        do{
            try Service.PutRequest(url: Api, parameter: param) { success, message, json in
                if success {
                    CoreDataManager.shared.updateUserData(id: UserId, updatedData: ["name": UserName, "mobile": PhoneNumber, "email": Email, "gender": gender, "id": UserId,"islatestedit": "true"])
                    onSuccess(json["message"].stringValue, json["resultCount"].intValue)
                } else {
                    onFailure(message)
                }
            }
        } catch {
            onFailure("Request failed with error: \(error.localizedDescription)")
        }
    }
    func getUserData(onSuccess: @escaping ([UserDataModelRC]) -> (), onFailure: @escaping (String) -> ()){
        print(ApiUrl)
        do{
            try Service.GetRequest(url: ApiUrl) { success, message, json in
                if success {
                    let jsonArray = json.arrayValue
                    var users: [UserDataModelRC] = []
                    for json in jsonArray {
                        let user = UserDataModelRC(fromJson: json)
                        users.append(user)
                    }
                    onSuccess(users)
                }else{
                    onFailure(json["message"].stringValue)
                }
            }
        } catch{
            onFailure("Request failed with error: \(error.localizedDescription)")
        }
    }
}
