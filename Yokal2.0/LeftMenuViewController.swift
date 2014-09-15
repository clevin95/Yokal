//
//  LeftMenuViewController.swift
//  Yokal2.0
//
//  Created by Carter Levin on 7/25/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var friendsTable: UITableView!
    let store:DataStore = DataStore.sharedInstance
    var travellers:[Traveller?] = []
    var delegate:LeftMenuDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTable", name: "processedTravellers", object: nil)
        friendsTable.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        friendsTable.backgroundColor = UIColor(white: 1, alpha: 0)
        let backgroundView:UIView = UIView(frame: view.frame)
        backgroundView.backgroundColor = UIColor.mySkyBlue()
        backgroundView.alpha = 0.3
        view.insertSubview(backgroundView, atIndex: 0)
        // Do any additional setup after loading the view.
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTable (){
        for key:NSString in store.travellerDictionary.keys {
            let travellerToAdd:Traveller? = store.travellerDictionary[key]!
            travellers.append(travellerToAdd)
        }
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.friendsTable.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("travellerCell") as UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        let id = travellers[indexPath.row]?.uniqueID!
        if (id != nil){
            if store.profileImageDic[id!] != nil{
                cell.imageView!.image = store.profileImageDic[id!]
            }else {
                
                cell.imageView!.image = UIImage(data:travellers[indexPath.row]!.profilePicture!)
                store.profileImageDic[id!] = cell.imageView!.image
            }
        }
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.textLabel!.text = travellers[indexPath.row]?.name
        cell.imageView!.layer.cornerRadius = cell.imageView!.frame.height / 2.0
        cell.imageView!.frame.size = CGSize(width: cell.imageView!.frame.height, height: cell.imageView!.frame.height)
        cell.imageView!.clipsToBounds = true
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travellers.count
    }
    

    
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol LeftMenuDelegate {
    
}