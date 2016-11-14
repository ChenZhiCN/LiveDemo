//
//  LiveViewController.m
//  Live直播
//
//  Created by cz on 16/11/6.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "LiveViewController.h"
#import "HttpRequest.h"
#import "NSObject+CZModel.h"
#import "Anchor.h"
#import "LiveTableViewCell.h"
#import "ShowViewController.h"

#define KscreenW [UIScreen mainScreen].bounds.size.width
#define KscreenH [UIScreen mainScreen].bounds.size.height

@interface LiveViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *anchors;

@end

@implementation LiveViewController

- (NSMutableArray *)anchors
{
    if (!_anchors) {
        _anchors = [NSMutableArray array];
    }
    return _anchors;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenW, KscreenH - 64) style:UITableViewStylePlain];
        tb.delegate = self;
        tb.dataSource = self;
        tb.backgroundColor = [UIColor whiteColor];
        tb.estimatedRowHeight = 300;
        tb.rowHeight = UITableViewAutomaticDimension;
        tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tb registerNib:[UINib nibWithNibName:@"LiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"LiveTableViewCell"];
        
        [self.view addSubview:tb];
        _tableView = tb;
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;

    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"喵播";
    
    [self handleNetWorking];
    
    
}

- (void)handleNetWorking
{
    [HttpRequest GET:@"http://live.9158.com/Fans/GetHotLive?page=1" paramaters:nil success:^(id responseObject) {
        [self handleDataSource:(id)responseObject];
    } failure:^(NSError *error) {
        NSLog(@"请求失败");
    }];
}

- (void)handleDataSource:(id)object
{
    NSArray *list = object[@"data"][@"list"];
    
    self.anchors = [NSMutableArray arrayWithArray:[Anchor ModelArrayWithArray:list]];
    
    [self.tableView reloadData];
     
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.anchors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LiveTableViewCell"];
    
    Anchor *anchor = self.anchors[indexPath.row];
    
    cell.anchor = anchor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Anchor *anchor = self.anchors[indexPath.row];
    
    ShowViewController *show = [[ShowViewController alloc] init];
    show.anchor = (IngkeeAnchor *)anchor;
    show.type = @"喵播";
    
    //动画
    CATransition *tran = [CATransition animation];
    tran.subtype = kCATransitionFromRight;
    tran.duration = 0.5;
    tran.type = @"rippleEffect";
    
    [self.navigationController.view.layer addAnimation:tran forKey:nil];
    [self.navigationController pushViewController:show animated:YES];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
