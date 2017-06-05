//
//  OCSTypyBase.m
//  OCS
//
//  Created by Xummer on 2017/5/27.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSTypyBase.h"

@implementation OCSTypyBase

- (void)countValue {
    size_t size = [self getBitForType:self.charType];
    self.totalSize = size;
    self.maxMemberSize = size;
}

- (void)makeFfi_type {
    //    self.my_ffi_type = _getFfi_typeForCharType(self.charType);
}

@end
