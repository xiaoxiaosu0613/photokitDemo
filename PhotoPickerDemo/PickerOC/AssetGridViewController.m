//
//  AssetGridViewController.m
//  PhotoPickerDemo
//
//  Created by jamesSU on 2017/3/13.
//  Copyright © 2017年 Arp77. All rights reserved.
//

#import "AssetGridViewController.h"
#import "AssetViewCell.h"

#define kBottomViewH 48
#define kThumbnailRowCount 4
#define kThumbnailSpacing 4

@interface AssetGridViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) CGSize thumbnailSize;

@property (nonatomic, strong) PHCachingImageManager  *imageManager;

/*bottomView*/
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *previewButton;

@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) UIButton *selectCountButton;

@end

@implementation AssetGridViewController

static NSString *identifier =  @"AssetsViewCellIdentifier";

- (instancetype)init
{
    self = [super init];
    if(self) {
        PHFetchOptions *options = [[PHFetchOptions alloc]init];
        options.sortDescriptors = @[[[NSSortDescriptor alloc]initWithKey:@"creationDate" ascending:YES]];
        self.assets = [PHAsset fetchAssetsWithOptions:options];
        self.imageManager = [PHCachingImageManager new];
        self.maxNumberOfSelection = 4;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:0 target:self action:@selector(popout)];
    [self setupCollectionView];
    [self setupBottomView];
}

- (void)popout
{
    if(self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    NSInteger itemSize = (screenSize.width - 5 * kThumbnailSpacing)/kThumbnailRowCount;
    layout.itemSize = CGSizeMake(itemSize, itemSize);
    layout.sectionInset = UIEdgeInsetsMake(kThumbnailSpacing, kThumbnailSpacing, kThumbnailSpacing,kThumbnailSpacing);
    layout.minimumInteritemSpacing = kThumbnailSpacing;
    layout.minimumLineSpacing = kThumbnailSpacing;
    self.thumbnailSize = layout.itemSize;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) collectionViewLayout:layout];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, kBottomViewH, 0);
    self.collectionView.allowsMultipleSelection = YES;
    [self.collectionView registerClass:[AssetViewCell class]
            forCellWithReuseIdentifier:identifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.bounces = YES;
    self.collectionView.alwaysBounceVertical = YES;
    [self.view insertSubview:self.collectionView atIndex:0];
}

- (void)setupBottomView
{
     CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, screenSize.height - kBottomViewH, screenSize.width, kBottomViewH)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIView *divider = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenSize.width, 0.5)];
    divider.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:divider];
    
    UIButton *previewButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 50, kBottomViewH)];
    previewButton.enabled = NO;
    previewButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [previewButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.previewButton = previewButton;
    [bottomView addSubview:previewButton];
    
    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(screenSize.width - 70, 0, 60, kBottomViewH)];
    nextButton.enabled = NO;
    nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.nextButton = nextButton;
    [bottomView addSubview:nextButton];
    
    UIButton *selectCountButton = [[UIButton alloc]initWithFrame:CGRectMake(screenSize.width - 90, (kBottomViewH - 20)/2, 20, 20)];
    selectCountButton.backgroundColor = [UIColor blueColor];
    selectCountButton.clipsToBounds = YES;
    selectCountButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    selectCountButton.layer.cornerRadius = 10;
    selectCountButton.alpha = 0;
    [selectCountButton setTitle:@"0" forState:UIControlStateNormal];
    [selectCountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectCountButton = selectCountButton;
    [bottomView addSubview:selectCountButton];
}

#pragma collectionDatasouce
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AssetViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [self.imageManager requestImageForAsset:self.assets[indexPath.row] targetSize:self.thumbnailSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.imageView.image = result;
    }];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([_collectionView indexPathsForSelectedItems].count >= self.maxNumberOfSelection) {   UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"" message:@"所选照片数已经达到最大可选数" preferredStyle: UIAlertControllerStyleAlert];
        [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:vc animated:YES completion:nil];
        return NO;
    }
    return YES;
}


- (void)updateDisplaySelectionCount:(NSInteger)count
{
    [self.selectCountButton setTitle:[NSString stringWithFormat:@"%@",@(count)] forState:UIControlStateNormal];
    if(count > 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.selectCountButton.alpha = 1.0;
            self.previewButton.enabled = YES;
            self.nextButton.enabled = YES;
        }];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            self.selectCountButton.alpha = 0;
            self.previewButton.enabled = NO;
            self.nextButton.enabled = NO;
        }];
    }
}

@end
