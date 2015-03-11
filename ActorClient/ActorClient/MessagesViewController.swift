//
//  MessagesViewController.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 11.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

import Foundation
import UIKit

class MessagesViewController: EngineSlackListController {

    var peer: AMPeer!;
    
    init(peer: AMPeer) {
        super.init(isInverted: true);
        self.peer = peer;
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buildController(delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        // TODO: Fix peer id
        var predicate = NSPredicate(format: "zone_id = %d", self.peer.getPeerId());
        var res = AACDMessage.MR_fetchAllSortedBy("sortKey", ascending: false, withPredicate: predicate, groupBy:nil, delegate:delegate);
        return res;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        textView.text = MSG.loadDraft(peer);
    }
    
    override func didPressRightButton(sender: AnyObject!) {
        // Perform auto correct
        textView.refreshFirstResponder();
        
        MSG.sendMessage(peer, withText: textView.text);
        
        super.didPressRightButton(sender);
    }

    override func buildCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, item: AACD_List) -> UITableViewCell {
        
        var message = (item as! AACDMessage).message;
        var contentType = message.getContent().getContentType().name();
        var identifier = String(format: "cell_bubble_%@", contentType);
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! AAMessageCell?;
        if (cell == nil){
            cell = AAMessageCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier);
            cell?.awakeFromNib();
        }
        
        return cell!;
    }
    
    override func bindCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, item: AACD_List, cell: UITableViewCell) {
        
        var message = (item as! AACDMessage).message;
        var isMyMessage = (message.getSenderId() == MSG.myUid());
        
        (cell as! AAMessageCell).bindMessage(message, isMyMessage: isMyMessage)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated);
        MSG.saveDraft(peer, withText: textView.text);
    }
}