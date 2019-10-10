//
//  CSMParallaxCell.h
//  WorldPicture
//
//  Created by Chaosky on 2017/2/9.
//  Copyright © 2017年 ChaosVoid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSMParallaxCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *parallaxImage;

@property (nonatomic, assign) CGFloat parallaxRatio; //ratio of cell height, should between [1.0f, 2.0f], default is 1.5f;

@end
