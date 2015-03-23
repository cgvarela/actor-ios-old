//
//  ComposeController.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 23.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import UIKit

class ComposeController: ContactsBaseController {

    @IBOutlet weak var tableView: UITableView!
    
    override init() {
        super.init(nibName: "ComposeController", bundle: nil)
        
        navigationItem.title = "New Message";
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        bindTable(tableView)
        
        super.viewDidLoad()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var contact = objectAtIndexPath(indexPath) as! AMContact
        
        var controllers = NSMutableArray(array: navigationController!.viewControllers)
        controllers.removeLastObject()
        controllers.addObject(MessagesViewController(peer: AMPeer.userWithInt(contact.getUid())))
        navigationController!.setViewControllers(controllers as [AnyObject], animated: true)
    }
}