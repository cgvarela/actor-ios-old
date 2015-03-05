//
//  AADialogTableViewCell.m
//  ActorClient
//
//  Created by Stepan Korshakov on 05.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "AADialogTableViewCell.h"

@implementation AADialogTableViewCell

static UIImage* pendingIcon = nil;
static UIImage* sentIcon = nil;
static UIImage* receivedIcon = nil;
static UIImage* readIcon = nil;

- (void)awakeFromNib {
    self.avatarView = [[AAAvatarImageView alloc] initWithFrame:CGRectMake(14, 14, 48, 48)];

    self.titleView = [[UILabel alloc] initWithFrame:CGRectMake(76, 14, 320, 20)];
    self.titleView.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    
    self.messageView = [[UILabel alloc] initWithFrame:CGRectMake(76, 36, 320, 20)];
    self.messageView.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    [self.messageView setTextColor:[UIColor colorWithRed:165/255. green:165/255. blue:165/255. alpha:1.]];
    
    self.dateView = [[UILabel alloc] initWithFrame:CGRectMake(270, 14, 50, 20)];
    self.dateView.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [self.dateView setTextColor:[UIColor colorWithRed:165/255. green:165/255. blue:165/255. alpha:1.]];
    
    self.statusView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 50, 50, 20)];
    [self.statusView setContentMode:UIViewContentModeCenter];
    
    self.separator = [[UIView alloc] initWithFrame:CGRectMake(76, 75.5, 320, 0.5)];
    [self.separator setBackgroundColor:[UIColor colorWithRed:165/255. green:165/255. blue:165/255. alpha:1.]];
 
    // [self.titleView setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
    
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.messageView];
    [self.contentView addSubview:self.dateView];
    [self.contentView addSubview:self.statusView];
    [self.contentView addSubview:self.separator];
    
    if (pendingIcon == nil) {
        // TODO: Fix
        pendingIcon = [UIImage imageNamed:@"ChatsIconDelivered"];
    }
    if (sentIcon == nil) {
        sentIcon = [UIImage imageNamed:@"ChatsIconSent"];
    }
    if (receivedIcon == nil){
        receivedIcon = [UIImage imageNamed:@"ChatsIconDelivered"];
    }
    if (receivedIcon == nil){
        receivedIcon = [UIImage imageNamed:@"ChatsIconDelivered"];
    }
    if (readIcon == nil){
        readIcon = [UIImage imageNamed:@"ChatsIconRead"];
    }
}

- (void)bindDialog:(AMDialog *)dialog withLast:(BOOL)isLast {
    
    // Peer info
    
    self.avatarView.image = [AAAvatarImageView imageWithData:nil colorId:dialog.getPeer.getPeerId title:dialog.getDialogTitle size:CGSizeMake(48, 48)];
    
    self.titleView.text = [dialog getDialogTitle];

    // Message content
    
    AMContentType contentType = [[dialog getMessageType] getValue];
    if (contentType == AMContentType_TEXT) {
        self.messageView.text = dialog.getText;
    } else if (contentType == AMContentType_EMPTY) {
        self.messageView.text = @"";
    } else if (contentType == AMContentType_DOCUMENT) {
        self.messageView.text = @"Document";
    } else if (contentType == AMContentType_DOCUMENT_PHOTO) {
        self.messageView.text = @"Photo";
    } else if (contentType == AMContentType_DOCUMENT_VIDEO) {
        self.messageView.text = @"Video";
    } else if (contentType == AMContentType_SERVICE) {
        self.messageView.text = dialog.getText;
    } else if (contentType == AMContentType_SERVICE_ADD) {
        self.messageView.text = @"Added user";
    } else if (contentType == AMContentType_SERVICE_TITLE) {
        self.messageView.text = @"Changed title";
    } else {
        self.messageView.text = @"Unknown message";
    }
    
    // Message date

    if ([dialog getDate] > 0){
        AMI18nEngine* formatter = [[CocoaMessenger messenger] getFormatter];
        jlong date = [dialog getDate];
        self.dateView.text = [formatter formatShortDateWithLong:date];
        self.dateView.hidden = NO;
    } else {
        self.dateView.hidden = YES;
    }
    
    // Message state
    
    AMMessageState state = [dialog.getStatus getValue];
    if (state == AMMessageState_PENDING) {
        self.statusView.image = pendingIcon;
        self.statusView.hidden = NO;
    } else if (state == AMMessageState_READ){
        self.statusView.image = readIcon;
        self.statusView.hidden = NO;
    } else if (state == AMMessageState_RECEIVED){
        self.statusView.image = receivedIcon;
        self.statusView.hidden = NO;
    } else if (state == AMMessageState_SENT){
        self.statusView.image = sentIcon;
        self.statusView.hidden = NO;
    } else {
        self.statusView.hidden = YES;
    }
}

@end
