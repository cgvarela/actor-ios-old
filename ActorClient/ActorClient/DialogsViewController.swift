//
//  DialogsViewController.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 10.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

import UIKit

class DialogsViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
   
    var fetchedController: NSFetchedResultsController? = nil;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override init() {
        super.init(nibName: "DialogsViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        if (fetchedController == nil){
            fetchedController = AACDDialog.MR_fetchAllSortedBy("sortKey", ascending: false, withPredicate: nil, groupBy: nil, delegate: self);
        }
        
        loadingView.hidden = true;
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 76;
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
//        tableView.separatorInset = UIEdgeInsetsZero;
    }
    
    override func viewDidAppear(animated: Bool) {
//        MSG.onDialogsOpen();
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates();
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch(type){
            case NSFetchedResultsChangeType.Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic);
                break;
            case NSFetchedResultsChangeType.Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic);
                break;
            case NSFetchedResultsChangeType.Move:
                tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!);
                break;
            case NSFetchedResultsChangeType.Update:
                var cell = tableView.cellForRowAtIndexPath(indexPath!) as! AADialogCell;
                var isLast = indexPath!.row == tableView.numberOfRowsInSection(indexPath!.section)-1;
                var dialog = anObject as! AACDDialog;
                cell.bindDialog(dialog.dialog, withLast: isLast);
                break;
            default:
                // Do nothing
                break;
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates();
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var fc = fetchedController!;
        var sec = fc.sections as! [NSFetchedResultsSectionInfo];
        
        if (sec.count <= section){
            return 0;
        }
        
        return sec[section].numberOfObjects;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell_dialog") as! AADialogCell?;

        if (cell == nil){
            cell = AADialogCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell_dialog");
            cell?.awakeFromNib();
        }
        
        var dialog = fetchedController?.objectAtIndexPath(indexPath) as! AACDDialog;
        
        let isLast = indexPath.row == tableView.numberOfRowsInSection(indexPath.section)-1;
        
        cell?.bindDialog(dialog.dialog, withLast: isLast);
        
        return cell!;
    }
    
    override func viewDidDisappear(animated: Bool) {
//        MSG.onDialogsClosed();
    }
}
