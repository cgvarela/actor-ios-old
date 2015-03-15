//
//  DialogsViewController.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 10.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

import UIKit

class DialogsViewController: EngineListController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        initCommon();
    }
    
    override init() {
        super.init(nibName: "DialogsViewController", bundle: nil)
        
        initCommon(); 
    }
    
    func initCommon(){
        var icon = UIImage(named: "ic_letter_blue_24")!;
        tabBarItem = UITabBarItem(title: nil,
            image: icon.tintImage(Resources.BarTintUnselectedColor)
                .imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal),
            selectedImage: icon);
        tabBarItem.imageInsets=UIEdgeInsetsMake(6, 0, -6, 0);
    }
    
    override func getDisplayList() -> AMBindedDisplayList {
        return MSG.getDialogsGlobalList()
    }
    
//    override func buildController(delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
//        return AACDDialog.MR_fetchAllSortedBy("sortKey", ascending: false, withPredicate: nil, groupBy: nil, delegate: delegate);
//    }
    
    func toggleEdit() {
        self.tableView.setEditing(!self.tableView.editing, animated: true);
    }
    
    override func viewDidLoad() {
        
        tableView.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
        
        // Footer
        var footer = UIView(frame: CGRectMake(0, 0, 320, 80));
        
        var footerHint = UILabel(frame: CGRectMake(0, 0, 320, 60));
        footerHint.textAlignment = NSTextAlignment.Center;
        footerHint.font = UIFont.systemFontOfSize(16);
        footerHint.textColor = UIColor(red: 164/255.0, green: 164/255.0, blue: 164/255.0, alpha: 1)
        footerHint.text = "Swipe for more options";
        footer.addSubview(footerHint);
        
        var shadow = UIImageView(image: UIImage(named: "CardBottom2"));
        shadow.frame = CGRectMake(0, 0, 320, 4);
        shadow.contentMode = UIViewContentMode.ScaleToFill;
        footer.addSubview(shadow);
        
        self.tableView.tableFooterView = footer;
        
        var header = UIView(frame: CGRectMake(0, 0, 320, 0))
        
        var headerShadow = UIImageView(frame: CGRectMake(0, -4, 320, 4));
        headerShadow.image = UIImage(named: "CardTop2");
        headerShadow.contentMode = UIViewContentMode.ScaleToFill;
        header.addSubview(headerShadow);
        
        self.tableView.tableHeaderView = header;
        
        loadingView.hidden = true;
        
        bindTable(tableView);
        
        super.viewDidLoad();
    }
    
    override func viewDidAppear(animated: Bool) {
        // MSG.onDialogsOpen();
    }
    
    override func viewWillAppear(animated: Bool) {
        var selected = tableView.indexPathForSelectedRow();
        if (selected != nil){
            tableView.deselectRowAtIndexPath(selected!, animated: animated);
        }
    }
    
    override func buildCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, item: AnyObject?) -> UITableViewCell {
        let reuseKey = "cell_dialog";
        
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseKey) as! DialogCell?;
        
        if (cell == nil){
            cell = DialogCell(reuseIdentifier: reuseKey);
            cell?.awakeFromNib();
        }
        
        return cell!;
    }
    
    override func bindCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, item: AnyObject?, cell: UITableViewCell) {
        var dialog = item as! AMDialog;
        let isLast = indexPath.row == tableView.numberOfRowsInSection(indexPath.section)-1;
        (cell as! DialogCell).bindDialog(dialog, isLast: isLast);
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var dialog = objectAtIndexPath(indexPath) as! AMDialog;
//        self.navigationController?.pushViewController(MessagesViewController(peer: dialog.getPeer()), animated: true);
    }
    
    override func viewDidDisappear(animated: Bool) {
        // MSG.onDialogsClosed();
    }
}
