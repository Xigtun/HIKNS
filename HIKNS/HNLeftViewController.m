//
//  HNLeftViewController.m
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "HNLeftViewController.h"
#import "UIColor+Hex.h"

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
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f1ed"];
    self.tableView.tableFooterView = [UIView new];
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
    NSString *celltext = [NSString stringWithFormat:@"   %@", self.titles[indexPath.row]];
    cell.textLabel.text = celltext;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#676664"];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithHexString:@"#e8e7e3"];
    [cell setSelectedBackgroundView:bgColorView];
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#f2f1ed"];
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
            tempTableView.backgroundColor = [UIColor colorWithHexString:@"#f2f1ed"];
            [tempTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
            tempTableView;
        });
    }
    return _tableView;
}


@end