//
//  OCSConfigureFileEngine.h
//  OCS
//
//  Created by Xummer on 2017/5/31.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCSConfigureFileEngine : NSObject

+ (instancetype)sharedInstance;

- (void)runWithConfigure:(id)configure configurefileNames:(NSArray *)fileNames errorCode:(NSUInteger *)errorCode;

@end
