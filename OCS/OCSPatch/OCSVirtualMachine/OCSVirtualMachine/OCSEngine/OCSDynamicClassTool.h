//
//  OCSDynamicClassTool.h
//  OCS
//
//  Created by Xummer on 2017/5/31.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OCSClassInfo;
@interface OCSDynamicClassTool : NSObject

+ (BOOL)setupDynamicClass:(OCSClassInfo *)clsInfo;

@end
