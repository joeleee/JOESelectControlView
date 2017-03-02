//
//  Created by Joe Lee on 2017/2/24.
//  Copyright © 2017 joelee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JOESelectControlView;


@protocol JOESelectControlDelegate <NSObject>

@optional
- (BOOL)selectControl:(JOESelectControlView *)selectControl shouldSelect:(BOOL)select atIndex:(NSUInteger)index;
- (BOOL)selectControl:(JOESelectControlView *)selectControl didSelect:(BOOL)select atIndex:(NSUInteger)index;

@end


@interface JOESelectControlView : UIView

@property (nonatomic, strong) UIImage *selectImage; // image for selected icon
@property (nonatomic, strong) UIImage *unselectImage; // image for unselected icon
@property (nonatomic, assign) CGSize imageSize; // size of each icon
@property (nonatomic, strong) UIFont *font; // font of icon label.text
@property (nonatomic, strong) UIColor *color; // color of icon label.text
@property (nonatomic, assign) BOOL enableMultiselect; // Whether to allow multiple choice. Default NO

@property (nonatomic, weak) id<JOESelectControlDelegate> delegate;
@property (nonatomic, readonly) NSArray<NSNumber *> *selectedIndexList; // current selected indexes

/**
 * @param titleList - the title list
 * @param countPerRow - how many icons per line
 */
- (instancetype)initWithTitleList:(NSArray<NSString *> *)titleList countPerRow:(NSUInteger)countPerRow;

- (BOOL)select:(BOOL)select index:(NSUInteger)index;

- (void)cleanAllSelected;

@end
