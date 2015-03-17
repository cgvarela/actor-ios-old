//
//  MessagesViewController.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 11.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import Foundation
import UIKit

class MessagesViewController: EngineSlackListController {

    var peer: AMPeer!;
    let binder: Binder = Binder();
    
    let titleView: UILabel = UILabel();
    let subtitleView: UILabel = UILabel();
    let navigationView: UIView = UIView();
    
    let avatarView = AvatarView(frameSize: 42)
    
    init(peer: AMPeer) {
        super.init(isInverted: true);
        
        // Hack for fixing top offsets
        self.edgesForExtendedLayout = UIRectEdge.All ^ UIRectEdge.Top;
        
        self.peer = peer;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        self.tableView.backgroundColor = UIColor.clearColor();
        self.tableView.allowsSelection = false;
        self.tableView.tableHeaderView = UIView(frame:CGRectMake(0, 0, 100, 6));
        
        self.textInputbar.backgroundColor = UIColor.whiteColor();
        self.textInputbar.autoHideRightButton = false;
        self.textView.placeholder = "Message";
        
        self.keyboardPanningEnabled = true;
        
        self.leftButton.setImage(UIImage(named: "conv_attach"), forState: UIControlState.Normal)
        
        navigationView.frame = CGRectMake(0, 0, 200, 44);
        navigationView.autoresizingMask = UIViewAutoresizing.FlexibleWidth;
        
        titleView.frame = CGRectMake(0, 0, 200, 24)
        titleView.font = UIFont.boldSystemFontOfSize(18);
        titleView.adjustsFontSizeToFitWidth = false;
        titleView.textColor = UIColor.whiteColor();
        titleView.textAlignment = NSTextAlignment.Center;
        titleView.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
        titleView.autoresizingMask = UIViewAutoresizing.FlexibleWidth;
        
        subtitleView.frame = CGRectMake(0, 24, 200, 44-24);
        subtitleView.font = UIFont.systemFontOfSize(14);
        subtitleView.adjustsFontSizeToFitWidth=false;
        subtitleView.textColor = UIColor.whiteColor();
        subtitleView.text = "???";
        subtitleView.textAlignment = NSTextAlignment.Center;
        subtitleView.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
        subtitleView.autoresizingMask = UIViewAutoresizing.FlexibleWidth;
        
        navigationView.addSubview(titleView);
        navigationView.addSubview(subtitleView);
        
        self.navigationItem.titleView = navigationView;
        
        avatarView.frame = CGRectMake(0, 0, 30, 30)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: avatarView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        textView.text = MSG.loadDraft(peer);
        var image = UIImage(named: "ChatBackground");
        var bg = UIImageView(image: UIImage(named: "ChatBackground"));
        view.insertSubview(bg, atIndex: 0);
        
        if (UInt(peer.getPeerType().ordinal()) == AMPeerType.PRIVATE.rawValue) {
            let user = MSG.getUsers().getWithLong(jlong(peer.getPeerId())) as! AMUserVM;
            var nameModel = user.getName() as AMValueModel;
            binder.bind(nameModel, closure: { (value: NSString?) -> () in
                self.titleView.text = String(value!);
                self.navigationView.sizeToFit();
            })
            binder.bind(MSG.getTyping(peer.getPeerId())!.getTyping(), closure: { (value:JavaLangBoolean?) -> () in
                if (value!.booleanValue()) {
                    self.subtitleView.text="typing...";
                } else {
                    self.subtitleView.text="...";
                }
            })
            binder.bind(user.getAvatar(), closure: { (value: AMAvatar?) -> () in
                self.avatarView.bind(user.getName().get() as! String, id: user.getId(), avatar: value)
            })
        }
        
        MSG.onConversationOpen(peer)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        MSG.onConversationClosed(peer)
    }
    
    override func textWillUpdate() {
        super.textWillUpdate();
        MSG.onTyping(peer);
    }
    
    override func didPressRightButton(sender: AnyObject!) {
        // Perform auto correct
        textView.refreshFirstResponder();
        
        MSG.sendMessage(peer, withText: textView.text);
        
        super.didPressRightButton(sender);
    }
    
    override func buildCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, item: AnyObject?) -> UITableViewCell {
        
        var message = (item as! AMMessage);
        
        if (message.getSenderId() != MSG.myUid()){
            MSG.onInMessageShown(peer, withRid: message.getRid(), withDate: message.getDate(), withEncrypted: false);
        }
        
        if (message.getContent() is AMTextContent){
            var cell = tableView.dequeueReusableCellWithIdentifier("bubble_text") as! BubbleTextCell?
            if (cell == nil) {
                cell = BubbleTextCell()
            }
            return cell!
        } else if (message.getContent() is AMPhotoContent || message.getContent() is AMVideoContent) {
            var cell = tableView.dequeueReusableCellWithIdentifier("bubble_media") as! BubbleMediaCell?
            if (cell == nil) {
                cell = BubbleMediaCell()
            }
            return cell!
            
        } else {
            fatalError("Unsupported content")
        }
    }
    
    override func bindCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, item: AnyObject?, cell: UITableViewCell) {
        (cell as! BubbleCell).bind((item as! AMMessage));
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var item = objectAtIndexPath(indexPath) as! AMMessage;
        return BubbleCell.measureHeight(item);
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated);
        MSG.saveDraft(peer, withText: textView.text);
    }
    
    override func getDisplayList() -> AMBindedDisplayList {
        return MSG.getMessagesGlobalListWithAMPeer(peer)
    }
}