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
    
    override func viewDidLoad() {
        
        // Footer
        var footer = UIView(frame: CGRectMake(0, 0, 320, 80));
        
        //        var footerHint = UILabel(frame: CGRectMake(0, 0, 320, 60));
        //        footerHint.textAlignment = NSTextAlignment.Center;
        //        footerHint.font = UIFont.systemFontOfSize(16);
        //        footerHint.textColor = UIColor(red: 164/255.0, green: 164/255.0, blue: 164/255.0, alpha: 1)
        //        footerHint.text = "Swipe for more options";
        //        footer.addSubview(footerHint);
        
        var shadow = UIImageView(image: UIImage(named: "CardBottom2"));
        shadow.frame = CGRectMake(0, 0, 320, 4);
        shadow.contentMode = UIViewContentMode.ScaleToFill;
        footer.addSubview(shadow);
        
        // Header
        
        var header = UIView(frame: CGRectMake(0, 0, 320, 0))
        
        var headerShadow = UIImageView(frame: CGRectMake(0, -4, 320, 4));
        headerShadow.image = UIImage(named: "CardTop2");
        headerShadow.contentMode = UIViewContentMode.ScaleToFill;
        header.addSubview(headerShadow);
        
        self.tableView.tableFooterView = footer;
        self.tableView.tableHeaderView = header;
        self.tableView.backgroundColor = Resources.BackyardColor
        bindTable(tableView);
        
        emptyView.hidden = true;
    
        super.viewDidLoad();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        var selected = tableView.indexPathForSelectedRow();
        if (selected != nil){
            tableView.deselectRowAtIndexPath(selected!, animated: animated);
        }
    }
    
    override func getDisplayList() -> AMBindedDisplayList {
        return MSG.getContactsGlobalList();
    }
    
    override func buildCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, item: AnyObject?) -> UITableViewCell {
        
        let reuseId = "cell_contact";
        
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseId) as! ContactCell?;
        
        if (cell == nil) {
            cell = ContactCell(reuseIdentifier:reuseId);
        }
        
        return cell!;
    }
    
    func addContact() {
        var alertView = UIAlertView(title: "Add Contact", message: "Please, specify phone number", delegate: nil, cancelButtonTitle: "Cancel")
        alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alertView.show()
    }
    
    override func bindCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, item: AnyObject?, cell: UITableViewCell) {
        var contact = item as! AMContact;
        let isLast = indexPath.row == tableView.numberOfRowsInSection(indexPath.section)-1;
        
        // Building short name
        var shortName : String? = nil;
        if (indexPath.row == 0) {
            shortName = contact.getName().smallValue();
        } else {
            var prevContact = objectAtIndexPath(NSIndexPath(forRow: indexPath.row-1, inSection: indexPath.section)) as! AMContact;
        
            var prevName = prevContact.getName().smallValue();
            var name = contact.getName().smallValue();
        
            if (prevName != name){
                shortName = name;
            }
        }
                
        (cell as! ContactCell).bindContact(contact, shortValue: shortName, isLast: isLast);
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var contact = objectAtIndexPath(indexPath) as! AMContact;
        self.navigationController?.pushViewController(MessagesViewController(peer: AMPeer.userWithInt(contact.getUid())), animated: true);
    }
}
