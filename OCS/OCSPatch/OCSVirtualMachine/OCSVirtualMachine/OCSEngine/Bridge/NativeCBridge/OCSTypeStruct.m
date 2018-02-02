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

    // ;    var_1C: -28   ___stack_chk_guard
    // ;    var_78: -120
    // ;    var_7C: -124
    // ;    var_84: -132
    // ;    var_88: -136 @selector(totalSize)
    // ;    var_8C: -140 @selector(startIndex)
    // ;    var_90: -144 @selector(setStartIndex:)
    // ;    var_94: -148
    // ;    var_98: -152 self->memberStructSizeValues
    // ;    var_9C: -156 &@selector(countByEnumeratingWithState:objects:count:)
    // ;    var_A0: -160 &@selector(totalSize)
    // ;    var_A4: -164 &@selector(startIndex)
    // ;    var_A8: -168 &@selector(setStartIndex:)
    // ;    var_AC: -172 &@selector(maxMemberSize)
    // ;    var_B0: -176 self
    // ;    var_B8: -184 0x10

    // r0: self->memberStructSizeValues
    // r1: @selector(countByEnumeratingWithState:objects:count:)
    // r2: sp + 0x38
    // r3: sp + 0x5c
    // r4: sp + 0x38
    // r5: &@selector(countByEnumeratingWithState:objects:count:)
    // q8: 0x0

    // [self->memberStructSizeValues retain];

    // [self->memberStructSizeValues countByEnumeratingWithState:objects:count:]

    // 00360636

    // var_94: *(var_78)

    // r0: @selector(countByEnumeratingWithState:objects:count:)
    // r8: 0x0
    // fp: 0x0

    NSUInteger index = 0;
    size_t currentMaxSize = 0;
    // loc_360660

    // r0: &@selector(maxMemberSize)
    // r4: @selector(maxMemberSize)
    // sl: 0x0

    for (OCSTypyCommon *item in self->memberStructSizeValues) {
        

        // loc_36067a

        // r0: *(var_78)
        // r1: var_94

        // if (*(var_78) != var_94) {
        //     objc_enumerationMutation(self->memberStructSizeValues);
        // }

        // r0: item.maxMemberSize
        // r1: @selector(maxMemberSize)
        // r2: item.maxMemberSize * r8
        // r6: item.startIndex
        // r8: item.totalSize + item.startIndex

        // 0x0/item.maxMemberSize
        
        r8 = index/item.maxMemberSize;
        if (index%item.maxMemberSize != 0)  {
            r8 = r8 + 1;
        }

        // item.maxMemberSize * r8

        item.setStartIndex(item.maxMemberSize * r8);

        if (item.maxMemberSize > currentMaxSize) {
            // 003606f2

            // r0: item
            // r1: maxMemberSize

            currentMaxSize = item.maxMemberSize;
        }
        
        // loc_3606fc

        // r0: var_84
        // sl: 0x1

        index = item.totalSize + item.startIndex；

    }

    // 00360706
    // r0: 0x10
    // r1:  &@selector(countByEnumeratingWithState:objects:count:)
    // r2: sp + 0x38
    // r3: sp + 0x5c

    // var_B8: 0x10

    // loc_360726

    // [self->memberStructSizeValues release];

    // r0: self
    // r1: @selector(setMaxMemberSize:)
    // r2: fp
    // r4: self

    self.maxMemberSize = currentMaxSize;

    if (_maxMemberSize == 0) {
        // loc_360764

        [NSException raise:@"OCSException" format:@"maxMemberSize is 0!"];
    }
    else {
        // 00360742
        // r0: r8%fp
        // r1: fp

        // __umodsi3(r8, fp)

        // if (index%_maxMemberSize != 0x0) {
        //     // 0036074c
        //     r0: self
        //     r1: @selector(setTotalSize:)
        //     r2: (index/_maxMemberSize + 0x1) * _maxMemberSize

        //     // loc_360788
        // }
        // else {
        //     // loc_36077e

        //     r0: self
        //     r1: @selector(setTotalSize:)
        //     r2: index

        //     // loc_360788
        // }

        self.totalSize = (index%_maxMemberSize != 0x0) ? (index + _maxMemberSize) : index;
    }

    // r0: ___stack_chk_guard
    // r1: ___stack_chk_guard

}

- (void)makeFfi_type {
    /*
    typedef struct _ffi_type
    {
      size_t size;
      unsigned short alignment;
      unsigned short type;
      struct _ffi_type **elements;
    } ffi_type;
    */

    ffi_type type = malloc(sizeof(ffi_type));

    NSUInteger count = [self->_memberStructSizeValues count];

    ffi_type *elements[] = malloc((count + 1) * sizeof(ffi_type *));

    NSUInteger i = 0;
    for (; i < count; i ++) {
        OCSTypyCommon *item = _memberStructSizeValues[ i ];
        elements[i] = item.my_ffi_type;
    }

    elements[i] = NULL;

    type.elements = elements;

    self.my_ffi_type = type;
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
