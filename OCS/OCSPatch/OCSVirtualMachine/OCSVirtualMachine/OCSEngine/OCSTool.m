//
//  OCSTool.m
//  OCS
//
//  Created by Xummer on 2017/6/8.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSTool.h"
#import "OCSVM_code.h"

OCSValueTag
_valueTag(char typeEncode) {
    OCSValueTag t;
    switch (typeEncode) {
#define OCS_VTAG_FROM_ENCODE_CASE(_typeChar, _tag) \
        case _typeChar: {   \
            t = _tag;   \
            break;  \
        }
            
        OCS_VTAG_FROM_ENCODE_CASE('c', OCSVTagChar)
        OCS_VTAG_FROM_ENCODE_CASE('C', OCSVTagUChar)
        OCS_VTAG_FROM_ENCODE_CASE('B', OCSVTagUChar)
        OCS_VTAG_FROM_ENCODE_CASE('s', OCSVTagShort)
        OCS_VTAG_FROM_ENCODE_CASE('S', OCSVTagUShort)
        OCS_VTAG_FROM_ENCODE_CASE('i', OCSVTagInt)
        OCS_VTAG_FROM_ENCODE_CASE('I', OCSVTagUInt)
        OCS_VTAG_FROM_ENCODE_CASE('l', OCSVTagLong)
        OCS_VTAG_FROM_ENCODE_CASE('L', OCSVTagULong)
        OCS_VTAG_FROM_ENCODE_CASE('q', OCSVTagLongLong)
        OCS_VTAG_FROM_ENCODE_CASE('Q', OCSVTagULongLong)
        OCS_VTAG_FROM_ENCODE_CASE('f', OCSVTagFloat)
        OCS_VTAG_FROM_ENCODE_CASE('d', OCSVTagDouble)
        OCS_VTAG_FROM_ENCODE_CASE('#', OCSVTagClass)
        OCS_VTAG_FROM_ENCODE_CASE('@', OCSVTagID)
        OCS_VTAG_FROM_ENCODE_CASE(':', OCSVTagSel)
        OCS_VTAG_FROM_ENCODE_CASE('*', OCSVTagPointer)
        OCS_VTAG_FROM_ENCODE_CASE('^', OCSVTagPointer)
        OCS_VTAG_FROM_ENCODE_CASE('{', OCSVTagStruct)
            
#undef OCS_VTAG_FROM_ENCODE_CASE
            
        default:
            [NSException raise:@"OCSCommonException" format:@"valueTag unsupported return type: %c", typeEncode];
            break;
    }
    
    return t;
}

/*
if (r9 > 0x5d) {
    // loc_35fb46
    if (r9 > 0x73) {
        // loc_35fb84
        if (r9 == 0x5e) { // ^
            // loc_35fba6
            r0 = 0x10;
        }
        else if (r9 == 0x7b) { // {
            r0 = 0x11;
        }
        else {
            // Defualt
        }
    }
    else {
        goto *0x35fb52[r0]; ; 0x35fb64,0x35fbbe,0x35fbe4,0x35fbee,0x35fbf2,0x35fbf6,0x35fbfa,0x35fbfe, case 17
    }
}
else if (r9 > 0x48) {
    // loc_35fb68
    if (r9 <= 0x50) {
        if (r9 == 0x49) { // I
            r0 = 0x6;
        }
        else if (r9 == 0x4c) { // L
            r0 = 0x8;
        }
    }
    else {
        if (r9 == 0x51) { // Q
            r0 = 0xa;
        }
        else if (r9 == 0x53){ // S
            r0 = 0x4;
        }
    }
    else {
        // Default
    }
}
else if (r9 < 0x43) {
    // loc_35fb96
    if (r9 == 0x23) { // #
        r0 = 0xd;
    }
    else if (r9 == 0x2a) { // *
        r0 = 0x10
    }
    else {
        // Default
    }
}
else {
    goto *0x35fb38[r0]; ; 0x35fb42,0x35fbbe,0x35fbe4,0x35fbe6,0x35fbea, case 10
}
 */

@implementation OCSTool

@end
