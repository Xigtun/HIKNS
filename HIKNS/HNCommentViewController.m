//
//  HNCommentViewController.m
//  HIKNS
//
//  Created by cysu on 16/1/22.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "HNCommentViewController.h"
#import <NSDate+TimeAgo.h>
#import <UIView+Positioning/UIView+Positioning.h>
#import <TLYShyNavBar/TLYShyNavBarManager.h>
#import "HNCommentViewCell.h"
#import "HNCommentTitleCell.h"
#import "HNRequestManager.h"

@interface HNCommentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *stories;


@end

@implementation HNCommentViewController
static NSString *const kCellIdentifier = @"HNCommentViewCell";
static NSString *const kTitleCellIdentifier = @"HNCommentTitleCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"HNCommentViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"HNCommentTitleCell" bundle:nil]
         forCellReuseIdentifier:kTitleCellIdentifier];
    self.tableView.estimatedRowHeight = 300;
    self.shyNavBarManager.scrollView = self.tableView;
    [self requestData];
}

- (void)requestData
{
    [[HNRequestManager manager] getStoryDataByIDs:self.story.kids hanlder:^(id object, BOOL state) {
        if (state == requestSuccess) {
            self.stories = [NSArray arrayWithArray:object];
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : self.story.kids.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HNCommentTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kTitleCellIdentifier];
        [cell configureUIWithModel:self.story];
        return cell;
    } else {
        HNCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        [cell configureUI:self.stories[indexPath.row] index:indexPath.row];
        return cell;
    }
}


@end
