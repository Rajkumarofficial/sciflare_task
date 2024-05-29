//
//  CoreData_manager.swift
//  Scifalre_Task
//
//  Created by apple on 24/05/24.
//

import Foundation
import CoreData

struct CoreDataManager{
    static var shared = CoreDataManager()
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func saveUserData(userData: [String:String]) {
        let context = persistentContainer.viewContext
        let userEntity = UserDataModel(context: context)
        
        userEntity.name = userData["name"]
        userEntity.gender = userData["gender"]
        userEntity.mobile = userData["mobile"]
        userEntity.email = userData["email"]
        userEntity.id = userData["id"]
        userEntity.islatestedit = userData["islatestedit"]
        
        do {
            try context.save()
        } catch {
            print("Error saving banner data: \(error.localizedDescription)")
        }
    }
    
    
    func fetchUserData() -> [String:String] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDataModel> = UserDataModel.fetchRequest()
        
        do {
            var userDataDict:[String:String] = [:]
            let userData = try context.fetch(fetchRequest)
            
            print(userData)
            
            let userDataObj = userData[0]
            
            userDataDict["name"] = userDataObj.name
            userDataDict["mobile"] = userDataObj.mobile
            userDataDict["email"] = userDataObj.email
            userDataDict["gender"] = userDataObj.gender
            userDataDict["id"] = userDataObj.id
            userDataDict["islatestedit"] = userDataObj.islatestedit
            
            return userDataDict
        } catch {
            print("Error fetching banner data: \(error.localizedDescription)")
            return [:]
        }
    }
    func fetchAllUsers(completion: @escaping ([UserDataModel]?) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDataModel> = UserDataModel.fetchRequest()
        
        do {
            let users = try context.fetch(fetchRequest)
            completion(users)
        } catch {
            print("Failed to fetch users: \(error.localizedDescription)")
            completion(nil)
        }
    }
    func updateUserData(id: String, updatedData: [String:String]) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDataModel> = UserDataModel.fetchRequest()
        
        do {
            // Fetch all users
            let allUsers = try context.fetch(fetchRequest)
            
            for user in allUsers {
                user.islatestedit = "false"
            }
            
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            let specificUsers = try context.fetch(fetchRequest)
            
            if let user = specificUsers.first {
                user.name = updatedData["name"]
                user.gender = updatedData["gender"]
                user.mobile = updatedData["mobile"]
                user.email = updatedData["email"]
                user.islatestedit = "true"
            }
            // Save the context
            try context.save()
        } catch {
            print("Error updating user data: \(error.localizedDescription)")
        }
    }
}
