//
//  HttpRequest.m
//  01-IJKPlayerPull
//
//  Created by vera on 16/11/4.
//  Copyright © 2016年 deli. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"

@implementation HttpRequest

+ (void)GET:(NSString *)urlString paramaters:(NSDictionary *)paramters success:(HttpRequestDidRequestSuccessCallback)success failure:(HttpRequestDidRequestFailureCallback)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager GET:urlString parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //成功回调
        if (success)
        {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //失败回调
        if (failure)
        {
            failure(error);
        }
    }];
    
}

@end
