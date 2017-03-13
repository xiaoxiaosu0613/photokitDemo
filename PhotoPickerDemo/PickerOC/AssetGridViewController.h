//
//  AssetGridViewController.h
//  PhotoPickerDemo
//
//  Created by jamesSU on 2017/3/13.
//  Copyright © 2017年 Arp77. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface AssetGridViewController : UIViewController

@property (nonatomic, strong) PHFetchResult<PHAsset *> *assets;

@property (nonatomic, assign) NSUInteger maxNumberOfSelection;

@end
