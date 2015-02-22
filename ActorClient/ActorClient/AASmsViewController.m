//
//  AASmsViewController.m
//  ActorClient
//
//  Created by Антон Буков on 22.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "AASmsViewController.h"

@interface AASmsViewController ()

@property (nonatomic, weak) IBOutlet UITextField *codeTextField;
@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;

@end

@implementation AASmsViewController

//MARK: - Scroll View

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Freezed table view header position CGPointZero
    UIView *view = self.tableView.tableHeaderView.subviews.firstObject;
    view.layer.transform = CATransform3DMakeTranslation(0, scrollView.contentOffset.y, 0);
}

//MARK: - View

- (IBAction)nextTapped:(UIBarButtonItem *)button
{
    
}

- (IBAction)codeChanged:(UITextField *)textField
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.phoneLabel.text = self.formattedPhoneNumber;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.codeTextField becomeFirstResponder];
}

/*
//MARK: - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}
*/

@end
