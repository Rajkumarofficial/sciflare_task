//
//  UserDataModel.swift
//  Scifalre_Task
//
//  Created by mac on 27/05/24.
//

import Foundation
import SwiftyJSON

class UserDataModelRC{

    var id : String!
    var email : String!
    var gender : String!
    var mobile : String!
    var name : String!

    init(fromJson json: JSON!){
        if json == nil{
            return
        }
        id = json["_id"].stringValue
        email = json["email"].stringValue
        gender = json["gender"].stringValue
        mobile = json["mobile"].stringValue
        name = json["name"].stringValue
    }
}
