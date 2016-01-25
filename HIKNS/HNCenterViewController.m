//
//  HNCenterViewController.m
//  HIKNS
//
//  Created by cysu on 16/1/22.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "HNCenterViewController.h"
#import <ViewDeck/ViewDeck.h>
#import <MJRefresh.h>
#import <UIView+Toast.h>
#import <TOWebViewController/TOWebViewController.h>
#import <SafariServices/SafariServices.h>

#import <TLYShyNavBar/TLYShyNavBarManager.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "HNRequestManager.h"
#import "HNDataBaseManager.h"
#import "HNLeftViewController.h"
#import "HNMainTableViewCell.h"
#import "HNCommentViewController.h"
#import "UIViewController+HUD.h"

@interface HNCenterViewController ()<SFSafariViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, HNLeftControllerDelegate>

@property (nonatomic, strong) NSMutableArray *stories;
@property (nonatomic, strong) NSMutableArray *allStoryIDs;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HNCenterViewController {
    RequestKind p_currentKind;
}


static NSString *const kCellIdentifier = @"HNMainTableViewCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"hnn";
    [self setupLeftMenuButton];
    self.fd_prefersNavigationBarHidden = NO;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"HNMainTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.tableView.estimatedRowHeight = 150;
    self.tableView.tableFooterView = [UIView new];
    
    [self setupRefreshAction];
    
//    self.shyNavBarManager.scrollView = self.tableView;
    self.stories = [[HNDataBaseManager manager] getStoriesWithKind:RequestKindNews];
    [self.tableView reloadData];
    
    [self getNewestData:RequestKindNews];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.hidesBarsOnSwipe = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.hidesBarsOnSwipe = NO;
}

- (void)setupRefreshAction
{
    p_currentKind = RequestKindNews;
    @weakify(self);
    // 下拉刷新
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        @weakify(self);
        [[HNRequestManager manager] getNewStoryIDsWithKind:p_currentKind hanlder:^(id object, BOOL state) {
            @strongify(self);
            if (state == requestSuccess) {
                NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:object];
                self.stories = [dictionary objectForKey:@"models"];
                self.allStoryIDs = [dictionary objectForKey:@"id"];
                [self.tableView reloadData];
            } else {
            }
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;

    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.allStoryIDs.count <= self.stories.count) {
            [self.view makeToast:@"There's no more data!" duration:0.5 position:CSToastPositionCenter];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
        NSArray *requestStories = [self.allStoryIDs subarrayWithRange:NSMakeRange(MIN(self.stories.count, self.allStoryIDs.count), MIN(100, self.allStoryIDs.count - self.stories.count))];
        @weakify(self);
        [[HNRequestManager manager] getStoryDataByIDs:requestStories kind:p_currentKind hanlder:^(id object, BOOL state) {
            @strongify(self);
            if (state == requestSuccess) {
                NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:object];
                NSArray *nextStories = [dictionary objectForKey:@"models"];
                NSArray *tempArray = [self.stories arrayByAddingObjectsFromArray:nextStories];
                self.stories = [NSMutableArray arrayWithArray:tempArray];
            } else {
            }
            // 结束刷新
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }];
        
    }];
}

- (void)getNewestData:(RequestKind)kind
{
    [self showHudWithMessage:@"Loading"];
    @weakify(self);
    [[HNRequestManager manager] getNewStoryIDsWithKind:kind hanlder:^(id object, BOOL state) {
        @strongify(self);
        if (state == requestSuccess) {
            [self hideHudWithSuccessMessage:@"Completed"];
            NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:object];
            self.stories = [dictionary objectForKey:@"models"];
            self.allStoryIDs = [dictionary objectForKey:@"id"];
            [self.tableView reloadData];
        } else {
            [self hideHudWithErrorMessage:@"Error"];
        }
    }];
}


-(void)setupLeftMenuButton{
    self.viewDeckController.leftSize = 160;
    HNLeftViewController *leftController = (HNLeftViewController *)self.viewDeckController.leftController;
    leftController.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStylePlain target:self.viewDeckController action:@selector(toggleLeftView)];
}

- (void)previewBounceLeftView {
    [self.viewDeckController previewBounceView:IIViewDeckLeftSide];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stories.count ?: 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HNMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    HNStoryModel *story = self.stories[indexPath.row];
    [cell configureUI:story];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewDeckController closeLeftView];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (IsArrayEmpty(self.stories)) {
        return;
    }
    HNStoryModel *story = self.stories[indexPath.row];
    if (IsStringEmpty(story.originPath)) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"HNMain" bundle:nil];
        HNCommentViewController *commentController = [storyBoard instantiateViewControllerWithIdentifier:@"HNCommentViewController"];
        commentController.story = story;
        [self.navigationController pushViewController:commentController animated:YES];
    } else {
        NSURL *url = [NSURL URLWithString:story.originPath];
        if(NSClassFromString(@"SFSafariViewController")) {
            SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:url];
            svc.delegate = self;
            [self presentViewController:svc animated:YES completion:nil];
        } else {
            TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
            [self.navigationController pushViewController:webViewController animated:YES];
        }
    }
}

#pragma mark - SFSafariViewControllerDelegate
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [self dismissViewControllerAnimated:true completion:nil];
}


#pragma mark - HNLeftControllerDelegate
- (void)shouldRequestDataWithKind:(RequestKind)kind;
{
    p_currentKind = kind;
    [self.viewDeckController closeLeftView];
    NSString *title;
    switch (kind) {
        case RequestKindNews:
            title = @"News";
            break;
        case RequestKindAsk:
            title = @"Ask";
            break;
        case RequestKindShow:
            title = @"Show";
            break;
        case RequestKindJobs:
            title = @"Job";
            break;
        case RequestKindBest:
            title = @"Best";
            break;
    }
    
    self.title = title;
    self.stories = [[HNDataBaseManager manager] getStoriesWithKind:kind];
    [self.tableView reloadData];
    [self showHudWithMessage:@"Loading"];
    @weakify(self);
    [[HNRequestManager manager] getNewStoryIDsWithKind:p_currentKind hanlder:^(id object, BOOL state) {
        @strongify(self);
        if (state == requestSuccess) {
            [self hideHudWithSuccessMessage:@"Completed"];
            NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:object];
            self.stories = [dictionary objectForKey:@"models"];
            self.allStoryIDs = [dictionary objectForKey:@"id"];
            [self.tableView reloadData];
        } else {
            [self hideHudWithErrorMessage:@"Error"];
        }
    }];
}

#pragma mark - LazyLoading
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = ({
            UITableView *tempTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
            tempTableView.delegate = self;
            tempTableView.dataSource = self;
            tempTableView;
        });
    }
    return _tableView;
}

@end
