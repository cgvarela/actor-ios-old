//
//  AAContactsViewController.m
//  ActorClient
//
//  Created by Антон Буков on 27.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "ActorModel.h"
#import "AAContactCell.h"
#import "AAMessagesViewController.h"
#import "AAContactsViewController.h"

@interface AAContactsViewController () <NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSFetchedResultsController *frc;

@end

@implementation AAContactsViewController

#pragma mark - Fethced Results Controller

- (NSFetchedResultsController *)frc
{
    if (_frc == nil)
        _frc = [AACDContact MR_fetchAllSortedBy:@"sortKey" ascending:NO withPredicate:nil groupBy:nil delegate:self];
    return _frc;
}

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
            AAContactCell *cell = (id)[self.tableView cellForRowAtIndexPath:indexPath];
            BOOL isLast = (indexPath.row == [self tableView:self.tableView numberOfRowsInSection:indexPath.section] - 1);
            AACDContact *contact = anObject;
            [cell bindContact:contact.contact withLast:isLast];
            //[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
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
    AAContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_contact"];
    if (cell == nil) {
        cell = [[AAContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_contact"];
        [cell awakeFromNib];
    }
    
    AACDContact *contact = [self.frc objectAtIndexPath:indexPath];
    BOOL isLast = (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1);
    [cell bindContact:contact.contact withLast:isLast];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AACDContact *contact = [self.frc objectAtIndexPath:indexPath];
    
    AAMessagesViewController *controller = [[AAMessagesViewController alloc] init];
    controller.peer = [[AMPeer alloc] initWithAMPeerTypeEnum:AMPeerType_PRIVATE withInt:contact.contact.getUid];
    [self.navigationController pushViewController:controller animated:YES];    
}

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.navigationController.tabBarItem.title;
    
    self.tableView.rowHeight = 48;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

@end
