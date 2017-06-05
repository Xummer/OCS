//
//  OCSTypeStruct.m
//  OCS
//
//  Created by Xummer on 2017/5/27.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSTypeStruct.h"

@implementation OCSTypeStruct

- (void)countValue {
    // TODO
}

- (void)makeFfi_type {
    // TODO
}

- (BOOL)isHomogeneousFloatingPoint {
    return [self isHomogeneousType:'f'] || [self isHomogeneousType:'d'];
}

- (BOOL)isHomogeneousType:(char)type {
    for (OCSTypyCommon *typy in self->_memberStructSizeValues) {
        if (![typy isKindOfClass:[OCSTypeStruct class]]) {
            if (type != typy.charType) {
                return NO;
            }
        }
    }
    return YES;
}

- (NSUInteger)getHomogeneousCount {
    NSUInteger count = 0;
    for (OCSTypyCommon *typy in self->_memberStructSizeValues) {
        if ([typy isKindOfClass:[OCSTypeStruct class]]) {
            count += [(OCSTypeStruct *)typy getHomogeneousCount];
        }
        else {
            count += 1;
        }
    }
    return count;
}

- (BOOL)isOnlyOneFundamentalType {
    BOOL result = NO;
    if ([self->_memberStructSizeValues count] == 1) {
        OCSTypyCommon *typy = self->_memberStructSizeValues[0];
        if ([typy isKindOfClass:[OCSTypeStruct class]]) {
            result = [(OCSTypeStruct *)typy isOnlyOneFundamentalType];
        }
        else {
            result = YES;
        }
    }
    return result;
}

@end
