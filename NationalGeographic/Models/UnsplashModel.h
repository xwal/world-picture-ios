//
//  UnsplashModel.h
//  NationalGeographic
//
//  Created by Chaosky on 2017/10/11.
//  Copyright © 2017年 ChaosVoid. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface UnsplashModel : AVObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *full_url;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;
@end
