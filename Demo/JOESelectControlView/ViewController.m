//
//  Created by Joe Lee on 2017/3/2.
//  Copyright © 2017年 joelee. All rights reserved.
//

#import "ViewController.h"

#import "JOESelectControlView.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];

    NSArray<NSString *> *titleList = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"14", @"14", @"15"];
    JOESelectControlView *view1 = [[JOESelectControlView alloc] initWithTitleList:titleList countPerRow:3];
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    view1.backgroundColor = [UIColor whiteColor];
    view1.selectImage = [UIImage imageNamed:@"selected"];
    view1.unselectImage = [UIImage imageNamed:@"unselect"];
    view1.imageSize = CGSizeMake(10, 10);
    view1.font = [UIFont systemFontOfSize:10];
    view1.color = [UIColor redColor];

    JOESelectControlView *view2 = [[JOESelectControlView alloc] initWithTitleList:titleList countPerRow:4];
    view2.translatesAutoresizingMaskIntoConstraints = NO;
    view2.backgroundColor = [UIColor blackColor];
    view2.enableMultiselect = YES;
    view2.selectImage = [UIImage imageNamed:@"selected"];
    view2.unselectImage = [UIImage imageNamed:@"unselect"];
    view2.imageSize = CGSizeMake(10, 10);
    view2.font = [UIFont systemFontOfSize:10];
    view2.color = [UIColor redColor];

    [self.view addSubview:view1];
    [self.view addSubview:view2];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[view1]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view1)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[view2]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view2)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[view1]-10-[view2]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view1, view2)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
}

@end
