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
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "HNRequestManager.h"
#import "HNDataBaseManager.h"
#import "HNLeftViewController.h"
#import "HNMainTableViewCell.h"
#import "HNCommentViewController.h"
#import "UIView+Positioning.h"
#import "UIViewController+HUD.h"
#import "DZNWebViewController.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>

@interface HNCenterViewController ()<UITableViewDelegate, UITableViewDataSource, HNLeftControllerDelegate, IIViewDeckControllerDelegate>

@property (nonatomic, strong) NSMutableArray *stories;
@property (nonatomic, strong) NSMutableArray *allStoryIDs;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *filterView;
@end

@implementation HNCenterViewController {
    RequestKind p_currentKind;
}

static NSString *const kCellIdentifier = @"HNMainTableViewCell";
static NSString *const kPlaceHolderCellIdentifier = @"kPlaceHolderCellIdentifier";
static NSString *const kLastRequestTime = @"kPlaceHolderCellIdentifier";
const char *kViewControllerKey = "kViewControllerKey";

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"News";
    [self setupLeftMenuButton];
    self.fd_prefersNavigationBarHidden = NO;
    self.view.backgroundColor = kMainBackgroundColor;
    
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.tableFooterView = [UIView new];
    
    NSArray *array = [[HNDataBaseManager manager] getStoriesWithKind:RequestKindNews];
    self.stories = [NSMutableArray arrayWithArray:array];

    [self setupRefreshAction];
    self.viewDeckController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.scrollNavigationBar.scrollView = self.tableView;
    self.viewDeckController.navigationController.toolbarHidden = YES;
    self.navigationController.toolbarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.scrollNavigationBar.scrollView = nil;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
//    [self.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:NO];
}

#pragma mark - Refresh
- (void)setupRefreshAction
{
    p_currentKind = RequestKindNews;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.automaticallyChangeAlpha = YES;
    [header beginRefreshing];

    self.tableView.mj_header = header;

    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"Click or drag up to refresh" forState:MJRefreshStateIdle];
    [footer setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
    footer.automaticallyRefresh = NO;
    footer.automaticallyChangeAlpha = YES;

    self.tableView.mj_footer = footer;
}

- (void)loadNewData
{
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
}

- (void)loadMoreData
{
    if (self.allStoryIDs.count <= self.stories.count) {
        [self.view makeToast:@"There's no more data!" duration:0.5 position:CSToastPositionCenter];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    NSArray *requestStories = [self.allStoryIDs subarrayWithRange:NSMakeRange(MIN(self.stories.count, self.allStoryIDs.count), MIN(kRequestCountEachTime, self.allStoryIDs.count - self.stories.count))];
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
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
}

#pragma mark - SetLeftBarButtonItem
-(void)setupLeftMenuButton{
    CGFloat screenWidth = CGRectGetWidth(self.view.frame);
    self.viewDeckController.leftSize = screenWidth * 2 / 3;
    HNLeftViewController *leftController = (HNLeftViewController *)self.viewDeckController.leftController;
    leftController.delegate = self;
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"navi_menu"] forState:UIControlStateNormal];
    [leftButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)previewBounceLeftView {
    [self.viewDeckController previewBounceView:IIViewDeckLeftSide];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stories.count ?: 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IsArrayEmpty(self.stories)) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlaceHolderCellIdentifier];
        cell.contentView.backgroundColor = kMainBackgroundColor;
        return cell;
    }
    HNMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (self.stories.count > 0) {
        HNStoryModel *story = self.stories[indexPath.row];
        [cell configureUI:story];
    }
    
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
        [commentController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:commentController animated:YES];
    } else {
        NSURL *url = [NSURL URLWithString:story.originPath];
        DZNWebViewController *webViewController = [[DZNWebViewController alloc] initWithURL:url];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

#pragma mark - HNLeftControllerDelegate
- (void)shouldRequestDataWithKind:(RequestKind)kind;
{
    p_currentKind = kind;
    [self.viewDeckController closeLeftView];
    self.fd_prefersNavigationBarHidden = NO;
    [self.tableView.mj_header endRefreshing];
    
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
    
    [self.stories removeAllObjects];
    [self.allStoryIDs removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *array = [[HNDataBaseManager manager] getStoriesWithKind:kind];
        self.stories = [NSMutableArray arrayWithArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            [self.tableView reloadData];
            [self.tableView.mj_header beginRefreshing];
        });
    });
}

#pragma mark - IIViewDeckControllerDelegate
- (void)viewDeckController:(IIViewDeckController*)viewDeckController willOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    [self.navigationController.view addSubview:self.filterView];
    
    self.filterView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.filterView.alpha = 0.4;
    }];
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    self.filterView.alpha = 0.4;
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController willCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    [UIView animateWithDuration:0.3 animations:^{
        self.filterView.alpha = 0;
    }];
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    [self.filterView removeFromSuperview];
}

- (void)filterViewTapped:(id)sender
{
    [self.viewDeckController closeLeftView];
}

#pragma mark - LazyLoading
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = ({
            UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            tempTableView.delegate = self;
            tempTableView.dataSource = self;
            [tempTableView registerNib:[UINib nibWithNibName:@"HNMainTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
            [tempTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kPlaceHolderCellIdentifier];
            tempTableView.estimatedRowHeight = 150;
            tempTableView.backgroundColor = kMainBackgroundColor;
            tempTableView;
        });
    }
    return _tableView;
}

- (UIView *)filterView
{
    if (!_filterView) {
        _filterView = ({
            UIView *tempView = [[UIView alloc] initWithFrame:self.view.frame];
            tempView.backgroundColor = [UIColor darkGrayColor];
            tempView.alpha = 0.4;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterViewTapped:)];
            [tempView addGestureRecognizer:singleTap];
            tempView;
        });
    }
    return _filterView;
}

@end
