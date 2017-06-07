//
//  OCSTypyCommon.m
//  OCS
//
//  Created by Xummer on 2017/5/27.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSTypyCommon.h"
@import CoreGraphics;

@implementation OCSTypyCommon

- (instancetype)initWithEncode:(NSString *)structEncode {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self->_encode = structEncode;
    
    return self;
}

- (char)charType {
    return [self.encode UTF8String][0];
}

- (void)countValue {
    [NSException raise:@"OCSERROR" format:@"countValue never be revert"];
}

- (void)makeFfi_type {
    [NSException raise:@"OCSERROR" format:@"makeFfi_type never be revert"];
}

- (void)countValueAndMakeFfi_type {
    [self countValue];
    [self makeFfi_type];
}

- (size_t)getBitForType:(char)type {
    // ??
    size_t size = 0;
    switch (type) {
#define JP_STRUCT_SIZE_CASE(_typeChar, _type)   \
case _typeChar: \
    size = sizeof(_type);  \
    break;
        
        JP_STRUCT_SIZE_CASE('c', char)
        JP_STRUCT_SIZE_CASE('C', unsigned char)
        JP_STRUCT_SIZE_CASE('s', short)
        JP_STRUCT_SIZE_CASE('S', unsigned short)
        JP_STRUCT_SIZE_CASE('I', unsigned int)
        JP_STRUCT_SIZE_CASE('l', long)
        JP_STRUCT_SIZE_CASE('L', unsigned long)
        JP_STRUCT_SIZE_CASE('q', long long)
        JP_STRUCT_SIZE_CASE('Q', unsigned long long)
        JP_STRUCT_SIZE_CASE('f', float)
        JP_STRUCT_SIZE_CASE('F', CGFloat)
        JP_STRUCT_SIZE_CASE('N', NSInteger)
        JP_STRUCT_SIZE_CASE('U', NSUInteger)
        JP_STRUCT_SIZE_CASE('d', double)
        JP_STRUCT_SIZE_CASE('B', BOOL)
        JP_STRUCT_SIZE_CASE('*', void *)
        JP_STRUCT_SIZE_CASE('^', void *)
            
        default:
            [NSException raise:@"OCSCommonException" format:@"getBitForType 不支持的数据类型:%c", type];
            break;
    }
    
    return size;
}

@end
