//
//  OCSTypyCommon.h
//  OCS
//
//  Created by Xummer on 2017/5/27.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ffi.h"

@interface OCSTypyCommon : NSObject

@property(nonatomic) ffi_type *my_ffi_type; // @synthesize my_ffi_type=_my_ffi_type;
@property(nonatomic) size_t maxMemberSize; // @synthesize maxMemberSize=_maxMemberSize;
@property(nonatomic) size_t totalSize; // @synthesize totalSize=_totalSize;
@property(nonatomic) NSUInteger startIndex; // @synthesize startIndex=_startIndex;
@property(retain, nonatomic) NSString *encode; // @synthesize encode=_encode;

- (instancetype)initWithEncode:(NSString *)structEncode;
- (char)charType;
- (void)countValue;
- (void)makeFfi_type;
- (void)countValueAndMakeFfi_type;
- (size_t)getBitForType:(char)type;

@end
