//
//  AAContactsViewController.m
//  ActorClient
//
//  Created by Антон Буков on 27.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#define MR_SHORTHAND 1
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "J2ObjC_source.h"
#import "im/actor/model/entity/Peer.h"
#import "im/actor/model/entity/PeerType.h"
#import "im/actor/model/entity/Dialog.h"
#import "im/actor/model/entity/Contact.h"
#import "im/actor/model/entity/MessageState.h"
#import "im/actor/model/entity/Avatar.h"
#import "im/actor/model/entity/AvatarImage.h"
#import "im/actor/model/entity/FileLocation.h"
#import "AACDContact.h"
#import "AAContactsViewController.h"
#import "AAAvatarImageView.h"

@interface AAContactsViewController () <NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *frc;

@end

@implementation AAContactsViewController

- (NSFetchedResultsController *)frc
{
    if (_frc == nil)
        _frc = [AACDContact MR_fetchAllSortedBy:@"sortKey" ascending:NO withPredicate:nil groupBy:nil delegate:self];
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
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] withContact:anObject update:YES];
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell_contact" forIndexPath:indexPath];
    
    AACDContact *contact = [self.frc objectAtIndexPath:indexPath];
    [self configureCell:cell withContact:contact update:NO];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withContact:(AACDContact *)cntct update:(BOOL)update
{
    IOSByteArray *byteArray = [IOSByteArray arrayWithBytes:cntct.value.bytes count:cntct.value.length];
    AMContact *contact = [AMContact fromBytesWithByteArray:byteArray];
    
    UIImageView *imageView = (id)[cell.contentView viewWithTag:1];
    UILabel *titleLabel = (id)[cell.contentView viewWithTag:2];
    
    imageView.image = [AAAvatarImageView imageWithData:nil colorId:contact.getUid title:contact.getName size:imageView.bounds.size];
    titleLabel.text = contact.getName;
}

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
