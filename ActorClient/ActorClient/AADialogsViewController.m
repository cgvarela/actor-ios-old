//
//  AADialogsViewController.m
//  ActorClient
//
//  Created by Stepan Korshakov on 05.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "ActorModel.h"
#import "AADialogCell.h"
#import "AAMessagesViewController.h"
#import "AADialogsViewController.h"

@interface AADialogsViewController () <NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSFetchedResultsController *frc;

@end

@implementation AADialogsViewController

#pragma mark - Fethced Results Controller

- (NSFetchedResultsController *)frc
{
    if (_frc == nil) {
        _frc = [AACDDialog MR_fetchAllSortedBy:@"sortKey" ascending:NO withPredicate:nil groupBy:nil delegate:self];
    }
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
            AADialogCell *cell = (id)[self.tableView cellForRowAtIndexPath:indexPath];
            BOOL isLast = (indexPath.row == [self tableView:self.tableView numberOfRowsInSection:indexPath.section] - 1);
            AACDDialog *dialog = anObject;
            [cell bindDialog:dialog.dialog withLast:isLast];
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
    AADialogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_dialog"];
    if (cell == nil) {
        cell = [[AADialogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_dialog"];
        [cell awakeFromNib];
    }
    
    AACDDialog *dialog = [self.frc objectAtIndexPath:indexPath];
    BOOL isLast = (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1);
    [cell bindDialog:dialog.dialog withLast:isLast];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AACDDialog *dialog = [self.frc objectAtIndexPath:indexPath];
    
    AAMessagesViewController *controller = [[AAMessagesViewController alloc] init];
    controller.peer = dialog.dialog.getPeer;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.navigationController.tabBarItem.title;
    
    self.tableView.rowHeight = 76;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

@end
