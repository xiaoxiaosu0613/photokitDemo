//
//  ViewController.m
//  PhotoPickerDemo
//
//  Created by jamesSU on 2017/3/13.
//  Copyright © 2017年 Arp77. All rights reserved.
//

#import "ViewController.h"
#import "AssetGroupViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)presentView:(id)sender
{
    UINavigationController *nav = [[UINavigationController alloc]init];
    [nav setViewControllers:@[[AssetGroupViewController new]]];
    [self presentViewController:nav animated:YES completion:nil];

}

@end
