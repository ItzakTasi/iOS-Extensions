//
//  UtilityMacros.h
//  iOS-Extensions
//
//  Created by Itzak Tasi on 12/3/5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#pragma mark - 角度與弧度轉換
// 角度轉換弧度
#define DegreesToRadians(degrees)       (degrees * (M_PI / 180.0))

// 弧度轉換角度
#define RadiansToDegrees(radians)       (radians * (180 / M_PI))


#pragma mark - 型態轉換成字串
// 布林值轉換成文字
#define NSStringFromBOOL(boolFlag)      ((boolFlag) ? @"YES" : @"NO")