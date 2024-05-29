//
//  UserData+CoreDataProperties.swift
//  Scifalre_Task
//
//  Created by apple on 24/05/24.
//
//

import Foundation
import CoreData




extension UserDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDataModel> {
        return NSFetchRequest<UserDataModel>(entityName: "UserData")
    }

    @NSManaged public var name: String?
    @NSManaged public var gender: String?
    @NSManaged public var email: String?
    @NSManaged public var mobile: String?
    @NSManaged public var id: String?
    @NSManaged public var islatestedit: String?

}


extension UserDataModel : Identifiable {

}

