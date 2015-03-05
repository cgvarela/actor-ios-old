//
//  AADialogsViewController.m
//  ActorClient
//
//  Created by Stepan Korshakov on 05.03.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "AADialogsViewController.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "ActorModel.h"
#import "AADialogTableViewCell.h"

@interface AADialogsViewController () <NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>
    @property (nonatomic, strong) UITableView *tableView;
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
        case NSFetchedResultsChangeUpdate:
        {
            BOOL isLast = NO;
            if (indexPath.item == [self.tableView numberOfRowsInSection:indexPath.section] - 1) {
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMDialog *dialog = ((AACDDialog *)[self.frc objectAtIndexPath:indexPath]).dialog;
    
//    AAMessagesViewController *controller = [[UIStoryboard storyboardWithName:@"Messages" bundle:nil] instantiateInitialViewController];
//    controller.peer = dialog.getPeer;
//    [self.navigationController pushViewController:controller animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 500)];
    self.tableView.rowHeight = 76;
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
