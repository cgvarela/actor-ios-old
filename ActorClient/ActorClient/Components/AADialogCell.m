//
//  AADialogTableViewCell.m
//  ActorClient
//
//  Created by Stepan Korshakov on 05.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "AADialogCell.h"

@implementation AADialogCell

#pragma mark - Status Image Cache

static UIImage *pendingIcon()
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"ChatsIconDelivered"];
    return image;
}

static UIImage *sentIcon()
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"ChatsIconDelivered"];
    return image;
}

static UIImage *receivedIcon()
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"ChatsIconSent"];
    return image;
}

static UIImage *readIcon()
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"ChatsIconRead"];
    return image;
}

#pragma mark - Subviews

- (UIImageView *)avatarView
{
    if (_avatarView == nil) {
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 14, 48, 48)];
    }
    return _avatarView;
}

- (UILabel *)titleView
{
    if (_titleView == nil) {
        _titleView = [[UILabel alloc] initWithFrame:CGRectMake(76, 14, 320-76-60, 20)];
        _titleView.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    }
    return _titleView;
}

- (UILabel *)messageView
{
    if (_messageView == nil) {
        _messageView = [[UILabel alloc] initWithFrame:CGRectMake(76, 36, 320, 20)];
        _messageView.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        _messageView.textColor = [UIColor colorWithRed:165/255. green:165/255. blue:165/255. alpha:1];
    }
    return _messageView;
}

- (UILabel *)dateView
{
    if (_dateView == nil) {
        _dateView = [[UILabel alloc] initWithFrame:CGRectMake(260, 14, 50, 20)];
        _dateView.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        _dateView.textColor = [UIColor colorWithRed:165/255. green:165/255. blue:165/255. alpha:1];
        _dateView.textAlignment = NSTextAlignmentRight;
    }
    return _dateView;
}

- (UIImageView *)statusView
{
    if (_statusView == nil) {
        _statusView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 50, 50, 20)];
        _statusView.contentMode = UIViewContentModeCenter;
    }
    return _statusView;
}

- (UIView *)separatorView
{
    if (_separatorView == nil) {
        _separatorView = [[UIView alloc] initWithFrame:CGRectMake(76, 75.5, 320, 0.5)];
        _separatorView.backgroundColor = [UIColor colorWithRed:165/255. green:165/255. blue:165/255. alpha:1];
    }
    return _separatorView;
}

- (void)awakeFromNib
{
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.messageView];
    [self.contentView addSubview:self.dateView];
    [self.contentView addSubview:self.statusView];
    [self.contentView addSubview:self.separatorView];
}

#pragma mark - Methods

- (void)bindDialog:(AMDialog *)dialog withLast:(BOOL)isLast
{
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
    
    AMMessageState state = dialog.getStatus.getValue;
    if (state == AMMessageState_PENDING) {
        self.statusView.image = pendingIcon();
    } else if (state == AMMessageState_READ){
        self.statusView.image = readIcon();
    } else if (state == AMMessageState_RECEIVED){
        self.statusView.image = receivedIcon();
    } else if (state == AMMessageState_SENT){
        self.statusView.image = sentIcon();
    } else {
        self.statusView.image = nil;
    }
    
    self.separatorView.hidden = isLast;
}

@end
