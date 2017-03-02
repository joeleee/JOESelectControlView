//
//  Created by Joe Lee on 2017/2/24.
//  Copyright © 2017 joelee. All rights reserved.
//

#import "JOESelectControlView.h"


#pragma mark - JOESelectControlItemView

@interface JOESelectControlItemView : UIControl

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) NSLayoutConstraint *imageViewHeight;
@property (nonatomic, strong) NSLayoutConstraint *imageViewWidth;

@end

@implementation JOESelectControlItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_imageView]-5-[_label]->=10-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_imageView, _label)]];
        self.imageViewWidth = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:20];
        self.imageViewHeight = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:20];
        [self addConstraints:@[self.imageViewWidth, self.imageViewHeight]];
    }
    return self;
}

#pragma mark getters & setters

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }

    _imageView = [[UIImageView alloc] init];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.contentMode = UIViewContentModeScaleToFill;
    _imageView.clipsToBounds = YES;
    return _imageView;
}

- (UILabel *)label {
    if (_label) {
        return _label;
    }

    _label = [[UILabel alloc] init];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _label.font = [UIFont systemFontOfSize:15];
    _label.textColor = [UIColor blackColor];
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.minimumScaleFactor = 0.6;
    _label.adjustsFontSizeToFitWidth = YES;
    return _label;
}

@end


#pragma mark - JOESelectControlView

@interface JOESelectControlView ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewLayout *collectionViewLayout;

@property (nonatomic, copy) NSArray<JOESelectControlItemView *> *itemViewList;
@property (nonatomic, strong) NSMutableArray<JOESelectControlItemView *> *selectedList;

@end

@implementation JOESelectControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:15];
        self.color = [UIColor blackColor];
        self.imageSize = CGSizeMake(20, 20);
        self.enableMultiselect = NO;
        self.selectedList = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithTitleList:(NSArray<NSString *> *)titleList countPerRow:(NSUInteger)count {
    if (self = [self initWithFrame:CGRectZero]) {
        [self resetSubViewsWithTitles:titleList countPerRow:count];
    }
    return self;
}

- (void)didItemViewTapped:(JOESelectControlItemView *)itemView {
    BOOL selected = [self.selectedList containsObject:itemView];
    if (!self.enableMultiselect && selected) {
        return;
    }

    NSUInteger index = [self.itemViewList indexOfObject:itemView];
    BOOL shouldSelect = YES;
    if ([self.delegate respondsToSelector:@selector(selectControl:shouldSelect:atIndex:)]) {
        shouldSelect = [self.delegate selectControl:self shouldSelect:!selected atIndex:index];
    }

    if (shouldSelect) {
        selected = !selected;
        if (selected) {
            if (!self.enableMultiselect) {
                [self cleanAllSelected];
            }
            [self.selectedList addObject:itemView];
        } else {
            [self.selectedList removeObject:itemView];
        }
        itemView.imageView.image = selected ? self.selectImage : self.unselectImage;
        if ([self.delegate respondsToSelector:@selector(selectControl:didSelect:atIndex:)]) {
            [self.delegate selectControl:self didSelect:selected atIndex:index];
        }
    }
}

- (void)resetSubViewsWithTitles:(NSArray<NSString *> *)titleList countPerRow:(NSUInteger)countPerRow {
    for (UIView *view in self.itemViewList) {
        [view removeFromSuperview];
    }

    if (0 == countPerRow) {
        return;
    }

    NSMutableArray<JOESelectControlItemView *> *itemViewList = [NSMutableArray array];
    NSUInteger rowCount = titleList.count / countPerRow + ((titleList.count % countPerRow > 0) ? 1 : 0);
    JOESelectControlItemView *leftView = nil;
    JOESelectControlItemView *topView = nil;

    for (NSString *title in titleList) {
        JOESelectControlItemView *view = [[JOESelectControlItemView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view.imageView.image = self.unselectImage;
        view.imageViewWidth.constant = self.imageSize.width;
        view.imageViewHeight.constant = self.imageSize.height;
        view.label.font = self.font;
        view.label.textColor = self.color;
        view.label.text = title;
        [view addTarget:self action:@selector(didItemViewTapped:) forControlEvents:UIControlEventTouchUpInside];
        [itemViewList addObject:view];

        [self addSubview:view];
        NSUInteger index = [titleList indexOfObject:title] + 1;
        BOOL isLastLine = (0 == index % countPerRow);
        BOOL isLastRow = (index > (rowCount - 1) * countPerRow);

        // top
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:view
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:topView ?: self
                                      attribute:topView ? NSLayoutAttributeBottom : NSLayoutAttributeTop
                                     multiplier:1
                                       constant:0]];

        // left
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:view
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:leftView ?: self
                                      attribute:leftView ? NSLayoutAttributeRight : NSLayoutAttributeLeft
                                     multiplier:1
                                       constant:0]];

        // bottom
        if (isLastRow) {
            [self addConstraint:
             [NSLayoutConstraint constraintWithItem:view
                                          attribute:NSLayoutAttributeBottom
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self
                                          attribute:NSLayoutAttributeBottom
                                         multiplier:1
                                           constant:0]];
        }

        // right
        if (isLastLine) {
            [self addConstraint:
             [NSLayoutConstraint constraintWithItem:view
                                          attribute:NSLayoutAttributeRight
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self
                                          attribute:NSLayoutAttributeRight
                                         multiplier:1
                                           constant:0]];
        }

        // width & height
        UIView *neighbourView = topView ?: leftView;
        if (neighbourView) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:neighbourView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:neighbourView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        }

        NSUInteger topIndex = index - countPerRow;
        topView = topIndex < itemViewList.count ? [itemViewList objectAtIndex:topIndex] : nil;
        leftView = isLastLine ? nil : view;
    }
    [self.selectedList removeAllObjects];
    self.itemViewList = itemViewList;
}

- (BOOL)select:(BOOL)select index:(NSUInteger)index {
    if (index >= self.itemViewList.count) {
        NSLog(@"The index is out of bounds! index:%zd, count:%zd", index, self.itemViewList.count);
        return NO;
    }

    JOESelectControlItemView *itemView = [self.itemViewList objectAtIndex:index];

    BOOL selected = [self.selectedList containsObject:itemView];
    if (select == selected) {
        return YES;
    }

    if (select) {
        if (!self.enableMultiselect) {
            [self cleanAllSelected];
        }
        [self.selectedList addObject:itemView];
    } else {
        [self.selectedList removeObject:itemView];
    }
    itemView.imageView.image = select ? self.selectImage : self.unselectImage;
    return YES;
}

- (void)cleanAllSelected {
    for (JOESelectControlItemView *itemView in self.selectedList) {
        itemView.imageView.image = self.unselectImage;
    }
    [self.selectedList removeAllObjects];
}

- (NSArray<NSNumber *> *)selectedIndexList {
    NSMutableArray *selectedIndexList = [NSMutableArray array];
    for (JOESelectControlItemView *itemView in self.selectedList) {
        NSUInteger index = [self.itemViewList indexOfObject:itemView];
        [selectedIndexList addObject:@(index)];
    }
    return [selectedIndexList copy];
}

- (void)refreshSelectItemViews {
    for (JOESelectControlItemView *itemView in self.itemViewList) {
        BOOL isSelected = [self.selectedList containsObject:itemView];
        itemView.imageView.image = isSelected ? self.selectImage : self.unselectImage;
        itemView.imageViewWidth.constant = self.imageSize.width;
        itemView.imageViewHeight.constant = self.imageSize.height;
        itemView.label.font = self.font;
        itemView.label.textColor = self.color;
    }
}

#pragma mark setters & getters

- (void)setSelectImage:(UIImage *)selectImage {
    if (_selectImage == selectImage) {
        return;
    }
    _selectImage = selectImage;
    [self refreshSelectItemViews];
}

- (void)setUnselectImage:(UIImage *)unselectImage {
    if (_unselectImage == unselectImage) {
        return;
    }
    _unselectImage = unselectImage;
    [self refreshSelectItemViews];
}

- (void)setImageSize:(CGSize)imageSize {
    if (CGSizeEqualToSize(_imageSize, imageSize)) {
        return;
    }
    _imageSize = imageSize;
    [self refreshSelectItemViews];
}

- (void)setFont:(UIFont *)font {
    if (_font == font) {
        return;
    }
    _font = font;
    [self refreshSelectItemViews];
}

- (void)setColor:(UIColor *)color {
    if (_color == color) {
        return;
    }
    _color = color;
    [self refreshSelectItemViews];
}

@end
