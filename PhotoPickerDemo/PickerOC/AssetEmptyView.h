//
//  AssetEmptyView.h
//  PhotoPickerDemo
//
//  Created by jamesSU on 2017/3/13.
//  Copyright © 2017年 Arp77. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetEmptyView : UIView

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *titleImageView;

- (void)setNoImage;

- (void)setNoVideo;

- (void)setNoAllow;

@end
