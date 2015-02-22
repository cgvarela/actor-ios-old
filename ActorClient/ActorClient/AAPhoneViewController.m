//
//  AAPhoneViewController.m
//  ActorClient
//
//  Created by Антон Буков on 20.02.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "ABPhoneField.h"
#import "AAPhoneViewController.h"
#import "AACountriesViewController.h"

@interface AAPhoneViewController ()

@property (nonatomic, weak) IBOutlet UILabel *countryNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *countryPrefixLabel;
@property (nonatomic, weak) IBOutlet ABPhoneField *phoneTextField;

@end

@implementation AAPhoneViewController

- (void)setCurrentIso:(NSString *)currentIso
{
    _currentIso = currentIso;
    self.countryPrefixLabel.text = [ABPhoneField callingCodeByCountryCode][currentIso];
    self.countryNameLabel.text = [ABPhoneField countryNameByCountryCode][currentIso];
}

//MARK: - Table View

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Freezed table view header position CGPointZero
    UIView *view = self.tableView.tableHeaderView.subviews.firstObject;
    view.layer.transform = CATransform3DMakeTranslation(0, scrollView.contentOffset.y, 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2 && indexPath.section == 0) {
        return MIN(120,[UIScreen mainScreen].bounds.size.height
                       - tableView.tableHeaderView.frame.size.height
                       - [self tableView:tableView heightForRowAtIndexPath:
                          [NSIndexPath indexPathForRow:0 inSection:0]]
                       - [self tableView:tableView heightForRowAtIndexPath:
                          [NSIndexPath indexPathForRow:1 inSection:0]]
                       - 216/* Number Pad */);
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

//MARK: - View

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.tableView.tableHeaderView.frame.size.width, 90);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *isoCode = self.phoneTextField.currentIso;
    self.currentIso = isoCode;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.phoneTextField becomeFirstResponder];
}

//MARK: - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue_countries"]) {
        AACountriesViewController *controller = segue.destinationViewController;
        controller.currentIso = self.currentIso;
    }
}

@end
