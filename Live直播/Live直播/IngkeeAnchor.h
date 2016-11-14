//
//  IngkeeAnchor.h
//  Live直播
//
//  Created by cz on 16/11/6.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "Anchor.h"
#import "Creator.h"

@interface IngkeeAnchor : Anchor

@property (nonatomic, strong) Creator *creator;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic) NSInteger room_id;
@property (nonatomic, copy) NSString *share_addr;
@property (nonatomic, copy) NSString *stream_addr;
@property (nonatomic) NSInteger online_users;

@end
