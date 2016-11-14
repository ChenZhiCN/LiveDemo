//
//  IngkeeViewController.m
//  Live直播
//
//  Created by cz on 16/11/6.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "IngkeeViewController.h"
#import "HttpRequest.h"
#import "NSObject+CZModel.h"
#import "IngkeeAnchor.h"
#import "LiveTableViewCell.h"
#import "ShowViewController.h"
#import "AFNetworking.h"

#define KscreenW [UIScreen mainScreen].bounds.size.width
#define KscreenH [UIScreen mainScreen].bounds.size.height

@interface IngkeeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *anchors;

@end

@implementation IngkeeViewController

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
    self.title = @"映客";
    
    [self handleNetWorking];
    
    
}

- (void)handleNetWorking
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary] ;
    //http://service.inke.com/api/live/aggregation?imsi=&uid=147808343&proto=6&imei=&interest=1&location=0
    parameters[@"uid"] = @"147808343";
    parameters[@"proto"] = @"6" ;
    parameters[@"interest"] = @"1" ;
    parameters[@"location"] = @"0";
    NSLog(@"%@", parameters);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    
    [manager GET:@"http://service.inke.com/api/live/aggregation" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [self handleDataSource:dict];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

     
- (void)handleDataSource:(id)object
{
    NSArray *list = object[@"lives"];
    
    self.anchors = [NSMutableArray arrayWithArray:[IngkeeAnchor ModelArrayWithArray:list]];
    
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.anchors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LiveTableViewCell"];
    
    IngkeeAnchor *anchor = self.anchors[indexPath.row];
    
    cell.ingkeeAnchor = anchor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IngkeeAnchor *anchor = self.anchors[indexPath.row];
    
    ShowViewController *show = [[ShowViewController alloc] init];
    show.anchor = anchor;
    show.type = @"映客";
    
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
