//
//  LiveTableViewCell.h
//  Live直播
//
//  Created by cz on 16/11/7.
//  Copyright © 2016年 cz. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Anchor.h"
#import "IngkeeAnchor.h"

@interface LiveTableViewCell : UITableViewCell

@property (nonatomic, strong) Anchor *anchor;

@property (nonatomic, strong) IngkeeAnchor *ingkeeAnchor;

@end
