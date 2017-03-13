//
//  AssetEmptyView.m
//  PhotoPickerDemo
//
//  Created by jamesSU on 2017/3/13.
//  Copyright © 2017年 Arp77. All rights reserved.
//

#import "AssetEmptyView.h"

@implementation AssetEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.messageLabel];
        [self addSubview:self.titleImageView];
    }
    return self;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel) {
        CGRect rect = CGRectInset(self.bounds, 10, 10);
        _titleLabel = [[UILabel alloc] initWithFrame:rect];
        _titleLabel.text  = @"无 视频或者照片";
        _titleLabel.font  = [UIFont systemFontOfSize:19.0];
        _titleLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 5;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel
{
    if(!_messageLabel) {
        CGRect rect = CGRectInset(self.bounds, 10, 10);
        _messageLabel = [[UILabel alloc] initWithFrame:rect];
        _messageLabel.text = @"你可以通过iTunes同步照片和视频到手机上";
        _messageLabel.font = [UIFont systemFontOfSize:15.0];
        _messageLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 5;
    }
    return _messageLabel;
}

- (UIImageView *)titleImage
{
    if(!_titleImageView) {
        _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YHAssetPickerController.bundle/YHAP_ico_no_image"]];
        _titleImageView.contentMode = UIViewContentModeCenter;
        _titleImageView.frame = (CGRect){0,0,_titleImageView.image.size};
    }
    return _titleImageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_titleLabel sizeToFit];
    [_messageLabel sizeToFit];
    _titleImageView.center = CGPointMake(self.center.x, self.center.y - 10 - _titleImageView.frame.size.height /2);
    _titleLabel.center  = CGPointMake(self.center.x, CGRectGetMaxY(_titleImageView.frame) + 40);
    _messageLabel.center  = CGPointMake(self.center.x, CGRectGetMaxY(_titleLabel.frame) + 30);
}

- (void)setNoImage
{
    self.titleImageView.image = [UIImage imageNamed:@"Resouce.bundle/icon_no_image"];
    self.titleLabel.text = @"无 照片";
    self.messageLabel.text = @"你可以通过iTunes同步照片到手机上.";
    [self layoutIfNeeded];
}

- (void)setNoVideo
{
    self.titleImageView.image = [UIImage imageNamed:@"Resouce.bundle/icon_no_video"];
    self.titleLabel.text = @"无 视频";
    self.messageLabel.text = @"你可以通过iTunes同步视频到手机上.";
    [self layoutIfNeeded];
}

- (void)setNoAllow
{
    self.titleImageView.image = [UIImage imageNamed:@"Resouce.bundle/icon_no_access"];
    self.titleLabel.text = @"无法访问您的照片或视频";
    self.messageLabel.text = @"您可以通过设置-应用-照片开启访问权限.";
    [self layoutIfNeeded];
}

@end
