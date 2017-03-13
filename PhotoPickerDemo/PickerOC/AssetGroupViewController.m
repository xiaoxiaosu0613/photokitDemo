//
//  AssetGroupViewController.m
//  PhotoPickerDemo
//
//  Created by jamesSU on 2017/3/13.
//  Copyright © 2017年 Arp77. All rights reserved.
//

#import "AssetGroupViewController.h"
#import "AssetGroupViewCell.h"
#import <Photos/Photos.h>
#import "AssetGridViewController.h"

typedef NS_ENUM(NSUInteger, kPhotoSection) {
    allPhotos = 0,
    smartAlbums = 1,
    userCollections = 2,
};


@interface AssetGroupViewController ()

@property (nonatomic, strong) PHFetchResult<PHAsset *> *allPhotos;

@property (nonatomic, strong) PHFetchResult<PHAssetCollection *> *smartAlbums;

@property (nonatomic, strong) PHFetchResult<PHCollection *> *userCollections;

@property (nonatomic, strong) PHCachingImageManager *imageManager;

@end

@implementation AssetGroupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"照片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:0 target:self action:@selector(popout)];
    [self.tableView registerClass:[AssetGroupViewCell class] forCellReuseIdentifier:@"AssetGroupViewCell"];
    [self setup];
    [self.tableView reloadData];
}

- (void)popout
{
    if(self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setup
{
    PHFetchOptions *options = [[PHFetchOptions alloc]init];
    options.sortDescriptors = @[[[NSSortDescriptor alloc]initWithKey:@"creationDate" ascending:YES]];
    self.allPhotos = [PHAsset fetchAssetsWithOptions:options];
    self.smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    self.userCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    self.imageManager = [[PHCachingImageManager alloc]init];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case userCollections:
            return self.userCollections.count;
            break;
        case smartAlbums:
            return self.smartAlbums.count;
            break;
        default:
            return 1;
            break;
    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetGroupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetGroupViewCell" forIndexPath:indexPath];
    PHFetchOptions *options = [[PHFetchOptions alloc]init];
    options.sortDescriptors = @[[[NSSortDescriptor alloc]initWithKey:@"creationDate" ascending:YES]];
    
    PHAsset *asset = nil;
    
    switch (indexPath.section) {
        case userCollections:
        {
            cell.textLabel.text = self.userCollections[indexPath.row].localizedTitle;
            PHCollection *colection = self.userCollections[indexPath.row];
            if([colection isKindOfClass:[PHAssetCollection class]]) {
                PHFetchResult<PHAsset *> *fetchResult = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)colection options:nil];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@)",@(fetchResult.count)];
                if(fetchResult.count) {
                    asset = fetchResult.lastObject;
                }
            }
        }
            break;
        case smartAlbums:
        {
            cell.textLabel.text = self.smartAlbums[indexPath.row].localizedTitle;
            PHCollection *colection = self.smartAlbums[indexPath.row];
            if([colection isKindOfClass:[PHAssetCollection class]]) {
                PHFetchResult<PHAsset *> *fetchResult = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)colection options:nil];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@)",@(fetchResult.count)];
                if(fetchResult.count) {
                    asset = fetchResult.lastObject;
                }
            }
        }
            break;
        default:
            cell.textLabel.text  = @"所有照片";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@)",@(self.allPhotos.count)];
            if(self.allPhotos.count) {
                asset = self.allPhotos.lastObject;
            }
            break;
    };
    if(asset) {
        [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(70, 70) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            cell.coverView.image = result;
        }];
    }else {
        cell.coverView.image = [UIImage imageNamed:@"photo_placeholder"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AssetGridViewController *vc = [[AssetGridViewController alloc]init];
    
    switch (indexPath.section) {
        case userCollections:
        {
            vc.title = self.userCollections[indexPath.row].localizedTitle;
            PHCollection *colection = self.userCollections[indexPath.row];
            if([colection isKindOfClass:[PHAssetCollection class]]) {
                PHFetchResult<PHAsset *> *fetchResult = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)colection options:nil];
                vc.assets = fetchResult;
            }
        }
            break;
        case smartAlbums:
        {
            vc.title = self.smartAlbums[indexPath.row].localizedTitle;
            PHCollection *colection = self.smartAlbums[indexPath.row];
            if([colection isKindOfClass:[PHAssetCollection class]]) {
                PHFetchResult<PHAsset *> *fetchResult = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)colection options:nil];
                vc.assets = fetchResult;
            }
        }
            break;
        default:
            vc.title  = @"所有照片";
            vc.assets = self.allPhotos;
            break;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end
