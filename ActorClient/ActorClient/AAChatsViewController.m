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
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] withDialog:anObject update:YES];
            //[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell_chat" forIndexPath:indexPath];
    
    AACDDialog *dialog = [self.frc objectAtIndexPath:indexPath];
    [self configureCell:cell withDialog:dialog update:NO];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMDialog *dialog = ((AACDDialog *)[self.frc objectAtIndexPath:indexPath]).dialog;
    
    AAMessagesViewController *controller = [[UIStoryboard storyboardWithName:@"Messages" bundle:nil] instantiateInitialViewController];
    controller.peer = dialog.getPeer;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)configureCell:(UITableViewCell *)cell withDialog:(AACDDialog *)dlg update:(BOOL)update
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
    
    imageView.image = [AAAvatarImageView imageWithData:nil colorId:dialog.getPeer.getPeerId title:dialog.getDialogTitle size:imageView.bounds.size];
    //dialog.getDialogAvatar.getLargeImage.getFileLocation.get
    titleLabel.text = dialog.getDialogTitle;
    timeLabel.text = [^{
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"HH:mm" options:0 locale:[NSLocale currentLocale]];
        }
        return dateFormatter;
    }() stringFromDate:[NSDate dateWithTimeIntervalSince1970:dialog.getDate]];
    textLabel.text = dialog.getText;
    unreadLabel.text = [@(dialog.getUnreadCount) description];
    sentView.hidden = !(dialog.getStatus.getValue == AMMessageState_SENT);
    deliveredView.hidden = !(dialog.getStatus.getValue == AMMessageState_RECEIVED);
    readView.hidden = !(dialog.getStatus.getValue == AMMessageState_READ);
}

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
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
