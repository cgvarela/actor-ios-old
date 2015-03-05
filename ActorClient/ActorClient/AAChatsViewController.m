//
//  AAChatsViewController.m
//  ActorClient
//
//  Created by Антон Буков on 25.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#define MR_SHORTHAND 1
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "J2ObjC_source.h"
#import "im/actor/model/entity/Peer.h"
#import "im/actor/model/entity/PeerType.h"
#import "im/actor/model/entity/Dialog.h"
#import "im/actor/model/entity/ContentType.h"
#import "im/actor/model/entity/MessageState.h"
#import "im/actor/model/entity/Avatar.h"
#import "im/actor/model/entity/AvatarImage.h"
#import "im/actor/model/entity/FileLocation.h"
#import "im/actor/model/i18n/I18NEngine.h"
#import "CocoaStorage.h"
#import "CocoaMessenger.h"
#import "AAChatsViewController.h"
#import "AAMessagesViewController.h"
#import "ActorModel.h"
#import "AAAvatarImageView.h"
#import "AAMessagesViewController.h"
#import "AAChatsViewController.h"
#import "AADialogTableViewCell.h"

@interface AAChatsViewController () <NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *frc;

@end

@implementation AAChatsViewController

- (NSFetchedResultsController *)frc
{
    if (_frc == nil) {
        _frc = [AACDDialog MR_fetchAllSortedBy:@"sortKey" ascending:NO withPredicate:nil groupBy:nil delegate:self];
    }
    return _frc;
}

#pragma mark - Fethced Results Controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeUpdate:
        {
            BOOL isLast = NO;
            if (indexPath.item == [self.tableView numberOfRowsInSection:indexPath.section] - 1){
                isLast = YES;
            }
            
            AADialogTableViewCell* cell = (AADialogTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            
            [cell bindDialog:anObject withLast:isLast];
        }
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.frc.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell_chat" forIndexPath:indexPath];
//    cell.contentView.bounds = CGRectMake(0,0,tableView.bounds.size.width,tableView.rowHeight);
    
    AACDDialog *dialog = [self.frc objectAtIndexPath:indexPath];
    BOOL isLast = NO;
    
    if (indexPath.item == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        isLast = YES;
    }
    
    AADialogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dialog_cell"];
    
    if (cell == nil){
        cell = [[AADialogTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"dialog_cell"];
        [cell awakeFromNib];
    }
    
    [cell bindDialog:dialog.dialog withLast: isLast];
//    [self configureCell:cell withDialog:dialog update:NO last:isLast];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMDialog *dialog = ((AACDDialog *)[self.frc objectAtIndexPath:indexPath]).dialog;
    
    AAMessagesViewController *controller = [[UIStoryboard storyboardWithName:@"Messages" bundle:nil] instantiateInitialViewController];
    controller.peer = dialog.getPeer;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)configureCell:(UITableViewCell *)cell withDialog:(AACDDialog *)dlg update:(BOOL)update last:(BOOL)isLast
{
    AMDialog *dialog = dlg.dialog;
    
    UIImageView *imageView = (id)[cell.contentView viewWithTag:1];
    UILabel *titleLabel = (id)[cell.contentView viewWithTag:2];
    UILabel *timeLabel = (id)[cell.contentView viewWithTag:3];
    UILabel *textLabel = (id)[cell.contentView viewWithTag:4];
    UILabel *unreadLabel = (id)[cell.contentView viewWithTag:5];
    UIView *sentView = (id)[cell.contentView viewWithTag:6];
    UIView *deliveredView = (id)[cell.contentView viewWithTag:7];
    UIView *readView = (id)[cell.contentView viewWithTag:8];
    UIView *div = (id)[cell.contentView viewWithTag:9];

    // Peer Info
    titleLabel.text = dialog.getDialogTitle;
    
    imageView.image = [AAAvatarImageView imageWithData:nil colorId:dialog.getPeer.getPeerId title:dialog.getDialogTitle size:imageView.bounds.size];

    // Message Date
    
    if ([dialog getDate] > 0){
        AMI18nEngine* formatter = [[CocoaMessenger messenger] getFormatter];
        jlong date = [dialog getDate];
        timeLabel.text = [formatter formatShortDateWithLong:date];
        timeLabel.hidden = NO;
    } else {
        timeLabel.hidden = YES;
    }

    // Message Content
    
    AMContentType contentType = [[dialog getMessageType] getValue];

    if (contentType == AMContentType_TEXT) {
        textLabel.text = dialog.getText;
    } else if (contentType == AMContentType_EMPTY) {
        textLabel.text = @"";
    } else if (contentType == AMContentType_DOCUMENT) {
        textLabel.text = @"Document";
    } else if (contentType == AMContentType_DOCUMENT_PHOTO) {
        textLabel.text = @"Photo";
    } else if (contentType == AMContentType_DOCUMENT_VIDEO) {
        textLabel.text = @"Video";
    } else if (contentType == AMContentType_SERVICE) {
        textLabel.text = dialog.getText;
    } else if (contentType == AMContentType_SERVICE_ADD) {
        textLabel.text = @"Added user";
    } else if (contentType == AMContentType_SERVICE_TITLE) {
        textLabel.text = @"Changed title";
    } else {
        textLabel.text = @"Unknown message";
    }
    
    // Message State
    
    sentView.hidden = !(dialog.getStatus.getValue == AMMessageState_SENT);
    deliveredView.hidden = !(dialog.getStatus.getValue == AMMessageState_RECEIVED);
    readView.hidden = !(dialog.getStatus.getValue == AMMessageState_READ);
    
    // Chat unread count
    
    unreadLabel.text = [@(dialog.getUnreadCount) description];
    
    // Divider
    div.hidden = isLast;
}

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Footer
    
    UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    UILabel* footerHint = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    footerHint.textAlignment = NSTextAlignmentCenter;
    footerHint.font = [UIFont systemFontOfSize:16.];
    footerHint.textColor = [UIColor colorWithRed:164/255. green:164/255. blue:164/255. alpha:1.0];
    [footerHint setText:@"Swipe for more options"];
    footerHint.autoresizingMask= UIViewAutoresizingFlexibleWidth;
    [footer addSubview:footerHint];
    
    UIImageView *shadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 4)];
    [shadow setImage:[UIImage imageNamed:@"CardBottom2"]];
    shadow.contentMode = UIViewContentModeScaleToFill;
    shadow.autoresizingMask= UIViewAutoresizingFlexibleWidth;
    [footer addSubview:shadow];
    
    footer.autoresizingMask= UIViewAutoresizingFlexibleWidth;
    self.tableView.tableFooterView = footer;
    
    // Header
    
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    
    UIImageView *headerShadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, -4, 320, 4)];
    [headerShadow setImage:[UIImage imageNamed:@"CardTop2"]];
    headerShadow.contentMode = UIViewContentModeScaleToFill;
    headerShadow.autoresizingMask= UIViewAutoresizingFlexibleWidth;
    
    [header addSubview:headerShadow];
    
    self.tableView.tableHeaderView=header;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
