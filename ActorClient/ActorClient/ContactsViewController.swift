//
//  ContactsViewController.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 10.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import UIKit

class ContactsViewController: EngineListController {
    
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        initCommon();
    }
    
    override init() {
        super.init(nibName: "ContactsViewController", bundle: nil)
        initCommon();
    }
    
    func initCommon(){
        var icon = UIImage(named: "ic_users_blue_24")!;
        tabBarItem = UITabBarItem(title: nil,
            image: icon.tintImage(Resources.BarTintUnselectedColor)
                .imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal),
            selectedImage: icon);
        tabBarItem.imageInsets=UIEdgeInsetsMake(6, 0, -6, 0);
    }
    
    
    override func buildController(delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        return AACDContact.MR_fetchAllSortedBy("sortKey", ascending: false, withPredicate: nil, groupBy: nil, delegate: delegate);
    }
    
    override func viewDidLoad() {
        emptyView.hidden = true;
        bindTable(tableView);
    
        super.viewDidLoad();
    }
    
    var firstLoad : Bool = true;
    
    override func viewWillAppear(animated: Bool) {
        var selected = tableView.indexPathForSelectedRow();
        if (selected != nil){
            tableView.deselectRowAtIndexPath(selected!, animated: animated);
        }
        
        NSLog("View Top: %f",self.rootView.frame.minY);
        
//        self.tableView
        
        // self.tableView.contentInset = UIEdgeInsets(top: 44+20, left: 0, bottom: 0, right: 0)
        
//        if (firstLoad) {
//            firstLoad = false;
//            self.tableView.frame = CGRectMake(0, 44 + 20, self.tableView.frame.size.width, self.tableView.frame.size.height-44 - 20);
//        } else {
//            self.tableView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
//        }
        
        // self.tableView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        var rect = self.navigationController!.navigationBar.frame;
//        
//        var y = rect.size.height + rect.origin.y;
//        
//        self.tableView.contentInset = UIEdgeInsetsMake(y ,0,0,0);
    }
    
    override func viewDidAppear(animated: Bool) {
        NSLog("View Top: %f, %f",self.rootView.frame.origin.y, self.tableView.frame.origin.y);
        
        self.tableView.setNeedsLayout();
    }

    override func buildCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, item: AACD_List) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell_contact") as! ContactCell?;
        
        if (cell == nil) {
            cell = ContactCell(reuseIdentifier:"cell_contact");
        }
        
        return cell!;
    }
    
    override func bindCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, item: AACD_List, cell: UITableViewCell) {
        var contact = item as! AACDContact;
        let isLast = indexPath.row == tableView.numberOfRowsInSection(indexPath.section)-1;
        var shortName : String? = nil;
        if (indexPath.row == 0) {
            shortName = contact.contact.getName().smallValue();
        } else {
            var prevContact = objectAtIndexPath(NSIndexPath(forRow: indexPath.row-1, inSection: indexPath.section)) as! AACDContact;
            
            var prevName = prevContact.contact.getName().smallValue();
            var name = contact.contact.getName().smallValue();

            if (prevName != name){
                shortName = name;
            }
        }
        
        (cell as! ContactCell).bindContact(contact.contact, shortValue: shortName);
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var contact = objectAtIndexPath(indexPath) as! AACDContact;
        navigationController?.pushViewController(MessagesViewController(peer: AMPeer.userWithInt(contact.contact.getUid())), animated: true);
    }
}
