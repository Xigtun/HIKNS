//
//  HNCommentViewController.m
//  HIKNS
//
//  Created by cysu on 16/1/22.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "HNCommentViewController.h"
#import <NSDate+TimeAgo.h>
#import "UIView+Positioning.h"
#import "HNCommentViewCell.h"
#import "HNCommentTitleCell.h"
#import "HNRequestManager.h"
#import "UIViewController+HUD.h"
#import "DZNWebViewController.h"
#import <ViewDeck/ViewDeck.h>

@interface HNCommentViewController () <UITableViewDelegate, UITableViewDataSource, TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *stories;


@end

@implementation HNCommentViewController
static NSString *const kCellIdentifier = @"HNCommentViewCell";
static NSString *const kTitleCellIdentifier = @"HNCommentTitleCell";
static NSString *const kPlaceHolderCellIdentifier = @"kPlaceHolderCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    self.view.backgroundColor = kMainBackgroundColor;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.title = self.story.title;

    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"HNCommentViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"HNCommentTitleCell" bundle:nil]
         forCellReuseIdentifier:kTitleCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kPlaceHolderCellIdentifier];
    self.tableView.estimatedRowHeight = 600;
    self.tableView.allowsSelection = NO;
//    self.shyNavBarManager.scrollView = self.tableView;
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData
{
    if (self.story.kids.count > 0) {
        @weakify(self);
        [[HNRequestManager manager] getStoryDataByIDs:self.story.kids hanlder:^(id object, BOOL state) {
            @strongify(self);
            if (state == requestSuccess) {
                self.stories = [NSArray arrayWithArray:object];
                [self.tableView reloadData];
            } else {
            }
        }];
    }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HNCommentTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kTitleCellIdentifier];
        [cell configureUIWithModel:self.story];
        cell.content.delegate = self;
        return cell;
    } else {
        if (IsArrayEmpty(self.stories)) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlaceHolderCellIdentifier];
            cell.contentView.backgroundColor = kMainBackgroundColor;
            return cell;
        }
        HNCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        [cell configureUI:self.stories[indexPath.row] index:indexPath.row];
        cell.content.userInteractionEnabled = YES;
        cell.content.delegate = self;
        return cell;
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"%@", url);
    DZNWebViewController *webViewController = [[DZNWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
