//
//  ContactsViewController.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 10.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import UIKit

class ContactsViewController: EngineListController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        tabBarItem = UITabBarItem(title: "Contacts",
            image: UIImage(named: "TabIconContacts"),
            selectedImage: UIImage(named: "TabIconContactsHighlighted"));
    }
    
    override init() {
        super.init(nibName: "ContactsViewController", bundle: nil)
        
        tabBarItem = UITabBarItem(title: "Contacts",
            image: UIImage(named: "TabIconContacts"),
            selectedImage: UIImage(named: "TabIconContactsHighlighted"));
    }
    
    override func buildController(delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        return AACDContact.MR_fetchAllSortedBy("sortKey", ascending: false, withPredicate: nil, groupBy: nil, delegate: delegate);
    }
    
    override func viewDidLoad() {
        emptyView.hidden = true;
        bindTable(tableView);
    
        super.viewDidLoad();
    }

    override func buildCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, item: AACD_List) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell_contact") as! AAContactCell?;
        
        if (cell == nil) {
            cell = AAContactCell(style: UITableViewCellStyle.Default, reuseIdentifier:"cell_contact");
            cell!.awakeFromNib();
        }
        
        return cell!;
    }
    
    override func bindCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, item: AACD_List, cell: UITableViewCell) {
        var contact = item as! AACDContact;
        let isLast = indexPath.row == tableView.numberOfRowsInSection(indexPath.section)-1;
        (cell as! AAContactCell).bindContact(contact.contact, withLast: isLast);
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var contact = objectAtIndexPath(indexPath) as! AACDContact;
        navigationController?.pushViewController(MessagesViewController(peer: AMPeer.userWithInt(contact.contact.getUid())), animated: true);
    }
}
