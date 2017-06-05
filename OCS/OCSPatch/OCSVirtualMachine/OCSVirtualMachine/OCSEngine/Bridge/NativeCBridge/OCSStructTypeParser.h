//
//  OCSStructTypeParser.h
//  OCS
//
//  Created by Xummer on 2017/3/13.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OCSTypeStruct, OCSStructTypeI;
@interface OCSStructTypeParser : NSObject

+ (NSArray *)componentsOfMembersEncode:(NSString *)mEcode;

+ (OCSTypeStruct *)parseStructEncode:(NSString *)structEncode;

+ (OCSStructTypeI *)getStructType:(NSString *)structS;

@end
