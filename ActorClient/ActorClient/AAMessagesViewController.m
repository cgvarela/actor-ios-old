//
//  AAMessagesViewController.m
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
    [self.tableView beginUpdates];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.frc.sections[0] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc] init];
}

#pragma mark - View

- (IBAction)userButtonTapped:(id)sender
{
}

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
