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
    
    self.titles = @[@"  ", @"News", @"Ask", @"Show", @"Jobs", @"Best"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    [self.view addSubview:self.tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = CGRectGetHeight([UIScreen mainScreen].bounds)/8;
    return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.textLabel.text = self.titles[indexPath.row];
    UIImage *image;
    switch (indexPath.row) {
        case 1:
            image = [UIImage imageNamed:@"nav_news"];
            break;
        case 2:
            image = [UIImage imageNamed:@"nav_ask"];
            break;
        case 3:
            image = [UIImage imageNamed:@"nav_show"];
            break;
        case 4:
            image = [UIImage imageNamed:@"nav_job"];
            break;
        case 5:
            image = [UIImage imageNamed:@"nav_best"];
            break;
    }
    cell.imageView.image = image;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        case 1:
            [self.delegate shouldRequestDataWithKind:RequestKindNews];
            break;
        case 2:
            [self.delegate shouldRequestDataWithKind:RequestKindAsk];
            break;
        case 3:
            [self.delegate shouldRequestDataWithKind:RequestKindShow];
            break;
        case 4:
            [self.delegate shouldRequestDataWithKind:RequestKindJobs];
            break;
        case 5:
            [self.delegate shouldRequestDataWithKind:RequestKindBest];
            break;
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = ({
            CGRect frame = self.view.frame;
            UITableView *tempTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
            tempTableView.backgroundColor = [UIColor whiteColor];
            tempTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tempTableView.scrollEnabled = NO;
            tempTableView.delegate = self;
            tempTableView.dataSource = self;
            tempTableView;
        });
    }
    return _tableView;
}


@end