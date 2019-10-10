//
//  UnsplashModel.m
//  WorldPicture
//
//  Created by Chaosky on 2017/10/11.
//  Copyright © 2017年 ChaosVoid. All rights reserved.
//

#import "UnsplashModel.h"

@implementation UnsplashModel

@dynamic type;
@dynamic full_url;
@dynamic width;
@dynamic height;

+ (NSString *)parseClassName {
    return @"unsplash";
}

@end
