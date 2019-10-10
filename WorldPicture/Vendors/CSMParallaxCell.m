//
//  CSMParallaxCell.m
//  WorldPicture
//
//  Created by Chaosky on 2017/2/9.
//  Copyright © 2017年 ChaosVoid. All rights reserved.
//

#import "CSMParallaxCell.h"

@interface CSMParallaxCell()

@property (nonatomic, strong) UICollectionView *parentCollectionView;

@end

@implementation CSMParallaxCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void) setup
{
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.parallaxImage = [UIImageView new];
    [self.contentView addSubview:self.parallaxImage];
    [self.contentView sendSubviewToBack:self.parallaxImage];
    self.parallaxImage.backgroundColor = [UIColor whiteColor];
    self.parallaxImage.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    
    self.parallaxRatio = 1.5f;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    
    [self safeRemoveObserver];
    
    UIView *v = newSuperview;
    while ( v )
    {
        if ( [v isKindOfClass:[UICollectionView class]] )
        {
            self.parentCollectionView = (UICollectionView*)v;
            break;
        }
        v = v.superview;
    }
    [self safeAddObserver];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    [self safeRemoveObserver];
}

- (void)safeAddObserver
{
    if ( self.parentCollectionView )
    {
        @try
        {
            [self.parentCollectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }
        @catch(NSException *exception)
        {
            
        }
    }
}

- (void)safeRemoveObserver
{
    if ( self.parentCollectionView )
    {
        @try
        {
            [self.parentCollectionView removeObserver:self forKeyPath:@"contentOffset" context:nil];
        }
        @catch (NSException *exception)
        {
            
        }
        @finally
        {
            self.parentCollectionView = nil;
        }
    }
}

- (void)dealloc
{
    [self safeRemoveObserver];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.parallaxRatio = self.parallaxRatio;
    return;
}

- (void)setParallaxRatio:(CGFloat)parallaxRatio
{
    _parallaxRatio = MAX(parallaxRatio, 1.0f);
    _parallaxRatio = MIN(parallaxRatio, 2.0f);
    
    CGRect rect = self.bounds;
    rect.size.height = rect.size.height*parallaxRatio;
    self.parallaxImage.frame = rect;
    
    [self updateParallaxOffset];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( [keyPath isEqualToString:@"contentOffset"] )
    {
        if ( ![self.parentCollectionView.visibleCells containsObject:self] || (self.parallaxRatio==1.0f) )
        {
            return;
        }
        
        [self updateParallaxOffset];
    }
}

- (void)updateParallaxOffset
{
    CGFloat contentOffset = self.parentCollectionView.contentOffset.y;
    
    CGFloat cellOffset = self.frame.origin.y - contentOffset;
    
    CGFloat percent = (cellOffset+self.frame.size.height)/(self.parentCollectionView.frame.size.height+self.frame.size.height);
    
    CGFloat extraHeight = self.frame.size.height*(self.parallaxRatio-1.0f);
    
    CGRect rect = self.parallaxImage.frame;
    rect.origin.y = -extraHeight*percent;
    self.parallaxImage.frame = rect;
}

@end
