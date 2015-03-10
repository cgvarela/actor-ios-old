//
//  DialogsViewController.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 10.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc class AADIalogsViewController: UIViewController, NSFetchedResultsControllerDelegate {
    var fetchedConctroller: NSFetchedResultsController? = nil;

    override func viewDidLoad() {
        if (fetchedConctroller == nil){
            fetchedConctroller = AACDDialog.MR_fetchAllSortedBy("sortKey", ascending: false, withPredicate: nil, groupBy: nil, delegate: self);
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        MSG.onDialogsOpen();
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
    }
    
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
    }

    override func viewDidDisappear(animated: Bool) {
        MSG.onDialogsClosed();
    }
}