//
//  EngineListController.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 10.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

import Foundation
import UIKit

class EngineListController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    private var engineTableView: UITableView!;
    private var fetchedController: NSFetchedResultsController!;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    }
    
    override init(){
        super.init();
    }
    
    // Init

    func buildController(delegate:NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        fatalError("Not implemented");
    }
    
    func bindTable(table: UITableView){
        self.engineTableView = table;
        self.engineTableView!.dataSource = self;
        self.engineTableView!.delegate = self;
    }
    
    override func viewDidLoad() {
        if (fetchedController == nil){
            fetchedController = buildController(self);
        }
    }
    
    // Controller operation
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        engineTableView.beginUpdates();
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch(type){
        case NSFetchedResultsChangeType.Insert:
            engineTableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic);
            break;
        case NSFetchedResultsChangeType.Delete:
            engineTableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic);
            break;
        case NSFetchedResultsChangeType.Move:
            engineTableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!);
            break;
        case NSFetchedResultsChangeType.Update:
            var cell = engineTableView.cellForRowAtIndexPath(indexPath!);
            if (cell != nil) {
                var item = anObject as! AACD_List;
                bindCell(engineTableView, cellForRowAtIndexPath: indexPath!, item: item, cell: cell!);
            }
            break;
        default:
            // Do nothing
            break;
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        engineTableView.endUpdates();
    }
    
    // Table Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sec = fetchedController!.sections as! [NSFetchedResultsSectionInfo];
        
        if (sec.count <= section){
            return 0;
        }
        
        return sec[section].numberOfObjects;
    }

    // Table Data Source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var item = fetchedController?.objectAtIndexPath(indexPath) as! AACD_List;
        var cell = buildCell(tableView, cellForRowAtIndexPath:indexPath, item:item);
        bindCell(tableView, cellForRowAtIndexPath: indexPath, item: item, cell: cell);
        return cell;
    }
    
    func buildCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, item: AACD_List)  -> UITableViewCell {
        fatalError("Not implemented");
    }
    
    func bindCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, item: AACD_List, cell: UITableViewCell) {
        fatalError("Not implemented");
    }
}