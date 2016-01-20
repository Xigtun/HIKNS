//
//  HNMainTableViewController.m
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "HNMainTableViewController.h"
#import <MMDrawerController/MMDrawerBarButtonItem.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>

#import "HNRequestManager.h"
#import "HNMainTableViewCell.h"

@interface HNMainTableViewController()
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
    
    @weakify(self);
    [[HNRequestManager manager] getNewStoryIDs:^(id object, BOOL state) {
        @strongify(self);
        if (state == requestSuccess) {
            self.stories = [NSMutableArray arrayWithArray:object];
            [self.tableView reloadData];
        } else {
            
        }
    }];
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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


@end
