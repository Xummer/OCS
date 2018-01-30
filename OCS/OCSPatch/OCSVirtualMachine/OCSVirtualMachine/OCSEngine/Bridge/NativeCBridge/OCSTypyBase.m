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

	// r0: self
	// r1: @selector(setMaxMemberSize:)
	// r2: size
	// r4: self
	// r5: size

    size_t size = [self getBitForType:self.charType];
    self.totalSize = size;
    self.maxMemberSize = size;
}

- (void)makeFfi_type {
	// r0: &@selector(setMy_ffi_type:)
	// r1: @selector(setMy_ffi_type:)
	// r2: _getFfi_typeForCharType(self.charType)
	// r4: self
    self.my_ffi_type = getFfi_typeForCharType(self.charType);
}

@end
