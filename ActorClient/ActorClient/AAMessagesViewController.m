//
//  AAMessagesViewController.m
//  ActorClient
//
//  Created by Антон Буков on 27.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//


#import "ActorModel.h"
#import "AAReverseTableView.h"
#import "AAMessageCell.h"
#import "AABubbleFactory.h"
#import "AAMessagesViewController.h"
#import "ActorClient-Swift.h"

@interface AAMessagesViewController () <NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet AAReverseTableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UIButton *userButton;

@property (nonatomic, strong) NSFetchedResultsController *frc;

@end

@implementation AAMessagesViewController

#pragma mark - Subviews

- (AAReverseTableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[AAReverseTableView alloc] initWithFrame:self.view.bounds];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.transform = CGAffineTransformMakeScale(1,-1);
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)frc
{
    if (_frc == nil) {
        _frc = [AACDMessage MR_fetchAllSortedBy:@"sortKey" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"zone_id = %@",@(self.peer.getPeerId)] groupBy:nil delegate:self];
    }
    return _frc;
}

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
    AACDMessage *message = [self.frc objectAtIndexPath:indexPath];
    BOOL isMyMessage = (message.message.getSenderId == [CocoaMessenger messenger].myUid);
    NSString *contentType = message.message.getContent.getContentType.name;
    
    NSString *indentifier = [NSString stringWithFormat:@"cell_bubble_%@",contentType];
    AAMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[AAMessageCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:indentifier];
        cell.transform = CGAffineTransformMakeScale(1,-1);
        [cell awakeFromNib];
    }
    
    [cell bindMessage:message.message isMyMessage:isMyMessage];
    
    return cell;
}

#pragma mark - View

- (IBAction)userButtonTapped:(id)sender
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
 
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ChatBackground"]];
}

@end
