//
//  OCSTypyCommon.m
//  OCS
//
//  Created by Xummer on 2017/5/27.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSTypyCommon.h"

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

- (unsigned char)getBitForType:(char)type {
    
    switch (type) {
        case 'I':
            // 0x360444,0x360454,0x36047a
            return 1;
            break;
            
        default:
            [NSException raise:@"OCSCommonException" format:@"getBitForType 不支持的数据类型:%c", type];
            break;
    }
    
    //    if (type <= 'P') { //0x50
    //        // loc_2a153dc
    //        if (type >= 'D') { //0x44
    //            if (type != 'I') { //0x49
    //
    //            }
    //            else if (type != 'L') {
    //
    //            }
    //        }
    //        else {
    //
    //        }
    //    }
    //    else if (type > 's') { //0x73
    //        // loc_2a153f0
    //    }
    //    else {
    //        // loc_2a153c6
    //    }
    
    return NULL;
}

@end
