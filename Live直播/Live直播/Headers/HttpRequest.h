//
//  HttpRequest.h
//  01-IJKPlayerPull
//
//  Created by vera on 16/11/4.
//  Copyright © 2016年 deli. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  成功回调
 *
 *  @param responseObject <#responseObject description#>
 */
typedef void(^HttpRequestDidRequestSuccessCallback)(id responseObject);

/**
 *  失败的回调
 *
 *  @param error <#error description#>
 */
typedef void(^HttpRequestDidRequestFailureCallback)(NSError *error);

@interface HttpRequest : NSObject

+ (void)GET:(NSString *)urlString paramaters:(NSDictionary *)paramters success:(HttpRequestDidRequestSuccessCallback)success failure:(HttpRequestDidRequestFailureCallback)failure;

@end
