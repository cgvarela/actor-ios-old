//
//  EngineSlackListController.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 11.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

import Foundation
import UIKit;

//class EngineSlackListController: SLKTextViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
//    
//    private var engineTableView: UITableView!;
//    private var fetchedController: NSFetchedResultsController!;
//    
//    init(isInverted:Bool) {
//        super.init(tableViewStyle: UITableViewStyle.Plain);
//        self.engineTableView = tableView;
//        self.engineTableView.dataSource = self;
//        self.engineTableView.delegate = self;
//        self.inverted = isInverted;
//    }
//    
//    required init!(coder decoder: NSCoder!) {
//        fatalError("Not implemented");
//    }
//    
//    func buildController(delegate:NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
//        fatalError("Not implemented");
//    }
//    
//    override func viewDidLoad() {
//        if (fetchedController == nil){
//            fetchedController = buildController(self);
//        }
//    }
//    
//    // Controller operation
//    func controllerWillChangeContent(controller: NSFetchedResultsController) {
//        if (engineTableView == nil){
//            return;
//        }
//        engineTableView.beginUpdates();
//    }
//    
//    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
//        if (engineTableView == nil){
//            return;
//        }
//        
//        switch(type){
//        case NSFetchedResultsChangeType.Insert:
//            engineTableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic);
//            break;
//        case NSFetchedResultsChangeType.Delete:
//            engineTableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic);
//            break;
//        case NSFetchedResultsChangeType.Move:
//            engineTableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!);
//            break;
//        case NSFetchedResultsChangeType.Update:
//            var cell = engineTableView.cellForRowAtIndexPath(indexPath!);
//            if (cell != nil) {
//                var item = anObject as! AACD_List;
//                bindCell(engineTableView, cellForRowAtIndexPath: indexPath!, item: item, cell: cell!);
//            }
//            break;
//        default:
//            // Do nothing
//            break;
//        }
//    }
//    
//    func controllerDidChangeContent(controller: NSFetchedResultsController) {
//        if (engineTableView == nil){
//            return;
//        }
//        
//        engineTableView.endUpdates();
//    }
//    
//    func objectAtIndexPath(indexPath: NSIndexPath) -> AACD_List {
//        return fetchedController.objectAtIndexPath(indexPath) as! AACD_List;
//    }
//    
//    // Table Delegate
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (fetchedController == nil){
//            return 0;
//        }
//        
//        var sec = fetchedController!.sections as! [NSFetchedResultsSectionInfo];
//        
//        if (sec.count <= section){
//            return 0;
//        }
//        
//        return sec[section].numberOfObjects;
//    }
//    
//    // Table Data Source
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var item = fetchedController?.objectAtIndexPath(indexPath) as! AACD_List;
//        var cell = buildCell(tableView, cellForRowAtIndexPath:indexPath, item:item);
//        bindCell(tableView, cellForRowAtIndexPath: indexPath, item: item, cell: cell);
//        cell.transform = self.tableView.transform;
//        return cell;
//    }
//    
//    func buildCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, item: AACD_List)  -> UITableViewCell {
//        fatalError("Not implemented");
//    }
//    
//    func bindCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, item: AACD_List, cell: UITableViewCell) {
//        fatalError("Not implemented");
//    }
//}