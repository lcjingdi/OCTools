//
//  ViewController.m
//  OCTools
//
//  Created by jingdi on 2016/10/27.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSArray *arr;
    
    NSArray *array = @[@"123",@"12"];
    [array objectAtIndex:20];
//
//
    NSMutableArray *arrayM = [@[@"1", @"3433",@"4343"] mutableCopy];
    [arrayM removeObjectAtIndex:30];
    
//    NSMutableArray *arrayM = [NSMutableArray array];
//    [arrayM addObject:nil];
//
//    arr
}


@end
