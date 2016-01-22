//
//  HNMainTableViewController.m
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "HNMainTableViewController.h"
#import <ViewDeck/ViewDeck.h>
#import <TOWebViewController/TOWebViewController.h>
#import <SafariServices/SafariServices.h>



#import "HNRequestManager.h"
#import "HNDataBaseManager.h"

#import "HNMainTableViewCell.h"

@interface HNMainTableViewController() <SFSafariViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *stories;

@end

@implementation HNMainTableViewController

static NSString *const kCellIdentifier = @"HNMainTableViewCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"hnn";
    [self setupLeftMenuButton];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HNMainTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.tableView.estimatedRowHeight = 150;
    self.tableView.tableFooterView = [UIView new];
    
//    [[HNDataBaseManager manager] getStoryByID:@10942314];
    
//    @weakify(self);
//    [[HNRequestManager manager] getNewStoryIDs:^(id object, BOOL state) {
//        @strongify(self);
//        if (state == requestSuccess) {
//            self.stories = [NSMutableArray arrayWithArray:object];
//            [self.tableView reloadData];
//        } else {
//            
//        }
//    }];
}

-(void)setupLeftMenuButton{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStylePlain target:self.viewDeckController action:@selector(toggleLeftView)];
}

- (void)previewBounceLeftView {
    [self.viewDeckController previewBounceView:IIViewDeckLeftSide];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stories.count ?: 10;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HNStoryModel *story = self.stories[indexPath.row];
    NSURL *url = [NSURL URLWithString:story.originPath];
//    SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:url];
//    svc.delegate = self;
//    [self presentViewController:svc animated:YES completion:nil];
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
