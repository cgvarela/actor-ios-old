//
//  AAChatsViewController.m
//  ActorClient
//
//  Created by Антон Буков on 25.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "ActorModel.h"
#import "AAAvatarImageView.h"
#import "AAMessagesViewController.h"
#import "AAChatsViewController.h"

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
        case NSFetchedResultsChangeUpdate: {
            //[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
            BOOL isLast = (indexPath.item == [self.tableView numberOfRowsInSection:indexPath.section] - 1);
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] withDialog:anObject update:YES last:isLast];
            break;
        }
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell_chat" forIndexPath:indexPath];
    
    AACDDialog *dialog = [self.frc objectAtIndexPath:indexPath];
    BOOL isLast = (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1);
    [self configureCell:cell withDialog:dialog update:NO last:isLast];
    
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
    UIView *separatorView = (id)[cell.contentView viewWithTag:9];

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
    textLabel.text = ^{
        switch (contentType) {
            case AMContentType_TEXT:
                return dialog.getText;
            case AMContentType_EMPTY:
                return @"";
            case AMContentType_DOCUMENT:
                return @"Document";
            case AMContentType_DOCUMENT_PHOTO:
                return @"Photo";
            case AMContentType_DOCUMENT_VIDEO:
                return @"Video";
            case AMContentType_SERVICE:
                return dialog.getText;
            case AMContentType_SERVICE_ADD:
                return @"Use added";
            case AMContentType_SERVICE_KICK:
                return @"User kicked";
            case AMContentType_SERVICE_LEAVE:
                return @"User leaved";
            case AMContentType_SERVICE_REGISTERED:
                return @"User was registered";
            case AMContentType_SERVICE_CREATED:
                return @"Dialog created";
            case AMContentType_SERVICE_TITLE:
                return @"Title changed";
            case AMContentType_SERVICE_AVATAR:
                return @"Avatar changed";
            case AMContentType_SERVICE_AVATAR_REMOVED:
                return @"Avatar removed";
            case AMContentType_UNKNOWN_CONTENT:
                return @"Unknown message";
                
            default:
                return @"";
        }
    }();
    
    // Message State
    
    sentView.hidden = !(dialog.getStatus.getValue == AMMessageState_SENT);
    deliveredView.hidden = !(dialog.getStatus.getValue == AMMessageState_RECEIVED);
    readView.hidden = !(dialog.getStatus.getValue == AMMessageState_READ);
    
    // Chat unread count
    
    unreadLabel.text = [@(dialog.getUnreadCount) description];
    
    // Separator
    
    separatorView.hidden = isLast;
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
