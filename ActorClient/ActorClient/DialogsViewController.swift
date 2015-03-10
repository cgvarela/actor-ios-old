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
    }
    
    override init() {
        super.init(nibName: "DialogsViewController", bundle: nil)
    }
    
    override func buildController(delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        return AACDDialog.MR_fetchAllSortedBy("sortKey", ascending: false, withPredicate: nil, groupBy: nil, delegate: self);
    }
    
    override func viewDidLoad() {
        loadingView.hidden = true;
        
        bindTable(tableView);
        
        super.viewDidLoad();
    }
    
    override func viewDidAppear(animated: Bool) {
        // MSG.onDialogsOpen();
    }
    
    override func buildCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, item: AACD_List) -> UITableViewCell {
        let reuseKey = "cell_dialog";
        
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseKey) as! AADialogCell?;
        
        if (cell == nil){
            cell = AADialogCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseKey);
            cell?.awakeFromNib();
        }
        
        return cell!;
    }
    
    override func bindCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, item: AACD_List, cell: UITableViewCell) {
        var dialog = item as! AACDDialog;
        let isLast = indexPath.row == tableView.numberOfRowsInSection(indexPath.section)-1;
        (cell as! AADialogCell).bindDialog(dialog.dialog, withLast: isLast);
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var dialog = objectAtIndexPath(indexPath) as! AACDDialog;
        var messageController = AAMessagesViewController();
        messageController.peer = dialog.dialog.getPeer();
        self.navigationController?.pushViewController(messageController, animated: true);
    }
    
    override func viewDidDisappear(animated: Bool) {
        // MSG.onDialogsClosed();
    }
}
