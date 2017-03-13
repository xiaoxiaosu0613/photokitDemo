//
//  AssetViewCell.m
//  PhotoPickerDemo
//
//  Created by jamesSU on 2017/3/13.
//  Copyright © 2017年 Arp77. All rights reserved.
//

#import "AssetViewCell.h"

@interface AssetViewCell()

@property (nonatomic, strong) UIButton *selectButton;

@end


@implementation AssetViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.imageView = [UIImageView new];
        [self.contentView addSubview:self.imageView];
        self.selectButton = [UIButton new];
        [self.selectButton setImage:[UIImage imageNamed:@"Resouce.bundle/icon_photo_thumb_uncheck"] forState:UIControlStateNormal];
        [self.selectButton setImage:[UIImage imageNamed:@"Resouce.bundle/icon_photo_thumb_check"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.selectButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
    self.selectButton.frame = CGRectMake(self.contentView.frame.size.width - 30, 0, 30, 30);
}


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.selectButton.selected = selected;
    if(selected) {
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction animations:^{
            self.selectButton.transform = CGAffineTransformMakeScale(0.95, 0.95);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                self.selectButton.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {}];
        }];
    }
    else {
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction animations:^{
            self.selectButton.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                self.selectButton.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {}];
        }];
        
    }
}

+ (NSString *)getTimeStringOfTimeInterval:(NSTimeInterval)timeInterval
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *dateRef = [[NSDate alloc] init];
    NSDate *dateNow = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:dateRef];
    
    unsigned int uFlags =
    NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour |
    NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *components = [calendar components:uFlags
                                               fromDate:dateRef
                                                 toDate:dateNow
                                                options:0];
    NSString *retTimeInterval = @"00:00";
    if (components.hour > 0) {
        retTimeInterval = [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)components.hour, (long)components.minute, (long)components.second];
    }else {
        retTimeInterval = [NSString stringWithFormat:@"%ld:%02ld", (long)components.minute, (long)components.second];
    }
    return retTimeInterval;
}

@end
