//
//  HNLeftViewController.m
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "HNLeftViewController.h"

@interface HNLeftViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titles;


@end

@implementation HNLeftViewController

static NSString *const kCellIdentifier = @"UITableViewCellTitle";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.titles = @[@"story", @"job", @"comment", @"poll", @"pollopt"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    [self.view addSubview:self.tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = ({
            CGRect frame = self.view.frame;
//            frame.origin.y = 100;
//            frame.size.height = frame.size.height - 100;
            UITableView *tempTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
            tempTableView.backgroundColor = [UIColor whiteColor];
            tempTableView.scrollEnabled = NO;
            tempTableView.delegate = self;
            tempTableView.dataSource = self;
            tempTableView;
        });
    }
    return _tableView;
}


@end