//
//  LiveTableViewCell.m
//  Live直播
//
//  Created by cz on 16/11/7.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "LiveTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Reimage.h"

@interface LiveTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *smallPic;
@property (weak, nonatomic) IBOutlet UIImageView *bigPic;
@property (weak, nonatomic) IBOutlet UILabel *visitNumberLabel;


@end

@implementation LiveTableViewCell

- (void)setIngkeeAnchor:(IngkeeAnchor *)ingkeeAnchor
{
    _ingkeeAnchor = ingkeeAnchor;
    self.myNameLabel.text = ingkeeAnchor.creator.nick;
    self.detailLabel.text = ingkeeAnchor.city;
    self.visitNumberLabel.text = [NSString stringWithFormat:@"%ld人在线",ingkeeAnchor.online_users];
    [self.smallPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",ingkeeAnchor.creator.portrait]]];
    [self.bigPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",ingkeeAnchor.creator.portrait]]];
    
}

- (void)setAnchor:(Anchor *)anchor
{
    _anchor = anchor;
    self.myNameLabel.text = anchor.myname;
    self.detailLabel.text = anchor.gps;
    self.visitNumberLabel.text = [NSString stringWithFormat:@"%ld人在线",anchor.allnum];
    [self.smallPic sd_setImageWithURL:[NSURL URLWithString:anchor.smallpic]];
    [self.bigPic sd_setImageWithURL:[NSURL URLWithString:anchor.bigpic]];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.smallPic.layer.cornerRadius = 60/2;
    self.smallPic.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
