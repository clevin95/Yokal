//
//  DataStore.swift
//  YokalSwift
//
//  Created by Carter Levin on 7/19/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class DataStore: NSObject {
    var currentTraveller:Traveller?
    var travellerDictionary:[NSString : Traveller?] = ["none" : nil]
    var profileImageDic:[NSString : UIImage] = [:]
    
    class var sharedInstance : DataStore {
    struct Static {
        static let instance : DataStore = DataStore()
        }
        return Static.instance
    }
    
    func getAllPosts () {
        APIClient.getCloudPosts({(outputArray:NSArray) in
                self.convertPostDicArray(outputArray)
            })
    }
    
    func getAllTravellers () {
        APIClient.getAllTravellers({(travellerArray:NSArray) in
            for traveller in travellerArray {
                let id:NSString = (traveller["unique_id"] as NSNumber).stringValue
                self.travellerDictionary[id] = self.createTravellerFromDictionary(traveller as NSDictionary)
                APIClient.getCloudPostsForTraveller(id, arrayPassback: {(posts:NSArray) in
                    self.convertPostDicArray(posts)
                })
            }
            NSNotificationCenter.defaultCenter().postNotificationName("processedTravellers", object:nil)
            })
       
    }
    
    func convertPostDicArray(postDicArray:NSArray) {
        for postDic:NSDictionary in postDicArray as [NSDictionary] {
            convertPostDic(postDic)
        }
    }  
    
    func updateTravellerProfileImage(completed:(() -> Void)) {
        APIClient.updateRemoteProfileImage(currentTraveller!, successPassback: {
            })
    }
    
    func convertPostDic(postDic:NSDictionary) {
        
        let myEntityDescription = NSEntityDescription.entityForName("Post", inManagedObjectContext: managedObjectContext)
        let cloudPost: Post = Post(entity:myEntityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        if let content:String = postDic["content"] as? String{
            cloudPost.content = content
        }
        
        if let latitudeNum:NSNumber = postDic["latitude"] as? NSNumber {
            cloudPost.latitude = latitudeNum.floatValue;
        }
        if let longitudeNum:NSNumber = postDic["longitude"] as? NSNumber {
            cloudPost.longitude = longitudeNum.floatValue;
        }
        if let traveller:Traveller? = travellerDictionary[(postDic["poster_id"] as NSNumber!).stringValue] as Traveller!! {
             cloudPost.traveller = traveller!
        }
    }
    
    func createPostWithContentDictionary(contentDictionary:[String:AnyObject]) {
        
        APIClient.createCloudPostFromDictionary(contentDictionary,forTraveller:currentTraveller!)
        let entityDescription = NSEntityDescription.entityForName("Post", inManagedObjectContext: managedObjectContext)
        let newPost: Post = Post(entity:entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        if let content:String = contentDictionary["content"] as? NSString {
            newPost.content = content
        }
        if let latitude:NSNumber = contentDictionary["latitude"] as? NSNumber {
            newPost.latitude = latitude
        }
        if let longitude:NSNumber = contentDictionary["longitude"] as? NSNumber {
            newPost.longitude = longitude
        }
        newPost.traveller = currentTraveller!
    }
    
    
    
    func createTravellerWithContentDictionary (travellerDictionary:[String:String], completed:(() -> Void)){
        let entityDescription = NSEntityDescription.entityForName("Traveller", inManagedObjectContext: managedObjectContext)
        let newTraveller = Traveller(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        newTraveller.name = travellerDictionary["username"] as String!
        newTraveller.password = travellerDictionary["password"] as String!
        newTraveller.email = travellerDictionary["email"] as String!
        
        APIClient.createTravellerRemotely(travellerDictionary, {(passbackID:NSString) in
            newTraveller.uniqueID = passbackID
            self.currentTraveller = newTraveller
            NSNotificationCenter.defaultCenter().postNotificationName("updateProfile", object:self.currentTraveller);
            completed()
            })
    }
    
    func validateTraveller(email:String, password:String, successBlock:((Bool) -> Void)){
        let travellerFetch:NSFetchRequest = NSFetchRequest(entityName: "Traveller")
        travellerFetch.returnsObjectsAsFaults = false
        let sortById:NSSortDescriptor = NSSortDescriptor(key: "email", ascending: true)
        let emailPredicate:NSPredicate = NSPredicate(format: "email == %@",email)
        travellerFetch.predicate = emailPredicate
        var error:NSError?
        let fetchedTraveller:NSArray = managedObjectContext.executeFetchRequest(travellerFetch, error: &error)!
        if (false && fetchedTraveller.count == 1){
            currentTraveller = fetchedTraveller[0] as? Traveller
            NSNotificationCenter.defaultCenter().postNotificationName("updateProfile", object:self.currentTraveller)
            successBlock(true)
        }
        else {
            APIClient.validateTraveller(email, password: password, arrayPassback: {(travellerDictionary:NSDictionary?) in
                if (travellerDictionary != nil){
                    self.currentTraveller = self.createTravellerFromDictionary(travellerDictionary!)
                    NSNotificationCenter.defaultCenter().postNotificationName("updateProfile", object:self.currentTraveller)
                    successBlock(true)
                }
                else {
                    successBlock(false)
                }
                })
        }
    }
    
    func createTravellerFromDictionary(travellerDictionary:NSDictionary) -> Traveller {
        
        
        let entityDescription = NSEntityDescription.entityForName("Traveller", inManagedObjectContext: managedObjectContext)
        let signedInTraveller = Traveller(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        signedInTraveller.name = travellerDictionary["username"] as? NSString
        signedInTraveller.email = travellerDictionary["email"] as? NSString
        signedInTraveller.uniqueID = (travellerDictionary["unique_id"] as NSNumber).stringValue
        
    
        
        
        if let imageData:NSData = travellerDictionary["profilepicture"] as? NSData {
            //let data = NSData(base64EncodedString: imageString, options: nil)
            signedInTraveller.profilePicture = imageData
        }
    
        //let data = NSData(base64EncodedString: imageArray, options: nil)
        
        
        
        
        
        
        return signedInTraveller
    }
    
    
    // Data store stack
    
    func saveContext () {
        var error: NSError? = nil
        let managedObjectContext = self.managedObjectContext
        if managedObjectContext.hasChanges && !managedObjectContext.save(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
    }
    
    // #pragma mark - Core Data stack
    
    // Returns the managed object context for the application.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    var managedObjectContext: NSManagedObjectContext {
    if _managedObjectContext == nil {
        let coordinator = self.persistentStoreCoordinator
            _managedObjectContext = NSManagedObjectContext()
            _managedObjectContext!.persistentStoreCoordinator = coordinator
        }
        return _managedObjectContext!
    }
    var _managedObjectContext: NSManagedObjectContext? = nil
    
    // Returns the managed object model for the application.
    // If the model doesn't already exist, it is created from the application's model.
    var managedObjectModel: NSManagedObjectModel {
    if _managedObjectModel == nil {
        let modelURL = NSBundle.mainBundle().URLForResource("Yokal2_0", withExtension: "momd")
        _managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL!)
        }
        return _managedObjectModel!
    }
    var _managedObjectModel: NSManagedObjectModel? = nil
    
    // Returns the persistent store coordinator for the application.
    // If the coordinator doesn't already exist, it is created and the application's store added to it.
    var persistentStoreCoordinator: NSPersistentStoreCoordinator {
    if _persistentStoreCoordinator == nil {
        let storeURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Yokal2_0.sqlite")
        var error: NSError? = nil
        _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        if _persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error) == nil {
            abort()
        }
        }
        return _persistentStoreCoordinator!
    }
    var _persistentStoreCoordinator: NSPersistentStoreCoordinator? = nil
    
    // #pragma mark - Application's Documents directory
    
    // Returns the URL to the application's Documents directory.
    var applicationDocumentsDirectory: NSURL {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }
    
    
    
    
    
    
}
