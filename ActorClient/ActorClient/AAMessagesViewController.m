//
//  AAMessagesViewController.m
//  ActorClient
//
//  Created by Антон Буков on 27.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#define MR_SHORTHAND 1
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <TAPKeyboardPop/UIViewController+TAPKeyboardPop.h>
#import "J2ObjC_source.h"
#import "im/actor/model/entity/Peer.h"
#import "im/actor/model/entity/PeerType.h"
#import "im/actor/model/entity/Message.h"
#import "im/actor/model/entity/MessageState.h"
#import "im/actor/model/entity/content/AbsContent.h"
#import "CocoaMessenger.h"
#import "CocoaStorage.h"
#import "AABubbleFactory.h"

#import "AAMessagesViewController.h"
#import "AAReverseTableView.h"
#import "AACDMessage.h"

@interface AAMessagesViewController () <NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UIButton *userButton;
@property (nonatomic, strong) IBOutlet AAReverseTableView *tableView;

@property (nonatomic, strong) NSFetchedResultsController *frc;

@end

@implementation AAMessagesViewController

- (NSFetchedResultsController *)frc
{
    if (_frc == nil) {
        _frc = [AACDMessage MR_fetchAllSortedBy:@"sortKey" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"zone_id = %@",@(self.peer.getPeerId)] groupBy:nil delegate:self];
    }
    return _frc;
}

#pragma mark - Fetched Results Controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    //[self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.frc.sections[0] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMMessage *message = ((AACDMessage *)[self.frc objectAtIndexPath:indexPath]).message;
    BOOL isMyMessage = (message.getSenderId == [CocoaMessenger messenger].myUid);
    NSString *contentType = message.getContent.getContentType.name;
    
    NSString *indentifier = [NSString stringWithFormat:@"cell_bubble_%@",contentType];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    AABubbleView *bubbleView = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:indentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.transform = CGAffineTransformMakeScale(1,-1);
        
        bubbleView = [[[AABubbleFactory bubbleClassForContentType:contentType] alloc] init];
        bubbleView.frame = CGRectInset(cell.contentView.bounds,3,3);
        bubbleView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        bubbleView.tag = 333;
        [cell.contentView addSubview:bubbleView];
    } else {
        bubbleView = (id)[cell.contentView viewWithTag:333];
    }
    
    [bubbleView configureWithMessage:message isMyMessage:isMyMessage];
    
    return cell;
}

#pragma mark - View

- (IBAction)userButtonTapped:(id)sender
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom = 44;
    self.tableView.contentInset = insets;
    
    self.tableView.transform = CGAffineTransformMakeScale(1,-1);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ChatBackground"]];
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
