//
//  HNCenterViewController.m
//  HIKNS
//
//  Created by cysu on 16/1/22.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "HNCenterViewController.h"
#import <ViewDeck/ViewDeck.h>
#import <TOWebViewController/TOWebViewController.h>
#import <SafariServices/SafariServices.h>

#import <TLYShyNavBar/TLYShyNavBarManager.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "HNRequestManager.h"
#import "HNDataBaseManager.h"
#import "HNLeftViewController.h"
#import "HNMainTableViewCell.h"
#import "HNCommentViewController.h"

@interface HNCenterViewController ()<SFSafariViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, HNLeftControllerDelegate>

@property (nonatomic, strong) NSMutableArray *stories;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HNCenterViewController


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
    
    /* Library code */
    self.shyNavBarManager.scrollView = self.tableView;
    
    @weakify(self);
    [[HNRequestManager manager] getNewStoryIDsWithKind:RequestKindNews hanlder:^(id object, BOOL state) {
        @strongify(self);
        if (state == requestSuccess) {
            self.stories = [NSMutableArray arrayWithArray:object];
            [self.tableView reloadData];
        } else {
            
        }
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbar.hidden = YES;
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

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)shouldRequestDataWithKind:(RequestKind)kind;
{
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
    
    @weakify(self);
    [[HNRequestManager manager] getNewStoryIDsWithKind:kind hanlder:^(id object, BOOL state) {
        @strongify(self);
        if (state == requestSuccess) {
            [self.stories removeAllObjects];
            self.stories = [NSMutableArray arrayWithArray:object];
            [self.tableView reloadData];
        } else {
            
        }
    }];
}

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
