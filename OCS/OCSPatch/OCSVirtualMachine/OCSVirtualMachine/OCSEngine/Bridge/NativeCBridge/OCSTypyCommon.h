//
//  OCSTypyCommon.h
//  OCS
//
//  Created by Xummer on 2017/5/27.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCSTypyCommon : NSObject

@property(nonatomic) ffi_type *my_ffi_type; // @synthesize my_ffi_type=_my_ffi_type;
@property(nonatomic) unsigned long long maxMemberSize; // @synthesize maxMemberSize=_maxMemberSize;
@property(nonatomic) unsigned long long totalSize; // @synthesize totalSize=_totalSize;
@property(nonatomic) unsigned long long startIndex; // @synthesize startIndex=_startIndex;
@property(retain, nonatomic) NSString *encode; // @synthesize encode=_encode;

- (id)initWithEncode:(id)arg1;
- (BOOL)charType;
- (void)countValue;
- (void)makeFfi_type;
- (void)countValueAndMakeFfi_type;
- (unsigned char)getBitForType:(BOOL)arg1;

@end
