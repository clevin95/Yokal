//
//  PostFetcher.swift
//  YokalSwift
//
//  Created by Carter Levin on 7/19/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit
import CoreData


class PostFetcher: NSObject , NSFetchedResultsControllerDelegate {
    var fetchedResultsController : NSFetchedResultsController?
    let store:DataStore = DataStore.sharedInstance
    var delegate:postFetcherDelegate? = nil
    override init() {
        super.init()
    }
    
    func beginFetching(){
        //fetches all travellers and all of their posts from the remote server
        store.getAllTravellers()
        setUpFetchResultsController()
        //store.getAllPosts()
        initialFetch()
    }
    
    func setUpFetchResultsController ()
    {
        let postFetch:NSFetchRequest = NSFetchRequest(entityName: "Post")
        let sortById:NSSortDescriptor = NSSortDescriptor(key: "latitude", ascending: true)
        postFetch.sortDescriptors = [sortById]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: postFetch, managedObjectContext: store.managedObjectContext, sectionNameKeyPath:nil, cacheName:nil)
        fetchedResultsController!.delegate = self
        fetchedResultsController!.performFetch(nil)
    }
    
    
    
    func initialFetch() {
        let postFetch:NSFetchRequest = NSFetchRequest(entityName: "Post")
        let sortById:NSSortDescriptor = NSSortDescriptor(key: "latitude", ascending: true)
        postFetch.sortDescriptors = [sortById]
        postFetch.returnsObjectsAsFaults = false
        let posts = store.managedObjectContext.executeFetchRequest(postFetch, error: nil)
        for i in 0...posts!.count {
            let savedPost = posts![i] as Post
            delegate?.addPost(savedPost)
            
        }
        /*
        for post in posts {
            let savedPost = post as Post
            delegate?.addPost(savedPost)
        }
*/
    }
    
    
    func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!)
    {
        
        
        let savedPost:Post = anObject as Post
        delegate?.addPost(savedPost)
    }
    
    func controller(controller: NSFetchedResultsController!, didChangeSection sectionInfo: NSFetchedResultsSectionInfo!, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType)
    {
        
    }
    
    func controller(controller: NSFetchedResultsController!, sectionIndexTitleForSectionName sectionName: String!) -> String!
    {
        return "test"
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!)
    {
        
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController!)
    {
        
    }
    
}


protocol postFetcherDelegate {
    func addPost (fetchedPost : Post)
}