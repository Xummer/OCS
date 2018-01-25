//
//  OCSNativeCStruct.m
//  OCS
//
//  Created by Xummer on 2017/5/8.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSVM_code.h"
#import <CoreGraphics/CoreGraphics.h>
#import <mach-o/dyld.h>
#import "OCSStructTypeParser.h"

// sub_2a123ba
void
OCSSetUpCFunctionEnvironment() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // sub_2a123e6
        initAppImagebase();
        CFMutableDictionaryRef dictRef =
        CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, 0);
        
        CFDictionaryAddValue(dictRef, @"CGRectMake", &CGRectMake);
        CFDictionaryAddValue(dictRef, @"CGPointMake", &CGPointMake);
        CFDictionaryAddValue(dictRef, @"CGSizeMake", &CGSizeMake);
        CFDictionaryAddValue(dictRef, @"CGVectorMake", &CGVectorMake);
        CFDictionaryAddValue(dictRef, @"__CGPointEqualToPoint", &__CGPointEqualToPoint);
        CFDictionaryAddValue(dictRef, @"__CGSizeEqualToSize", &__CGSizeEqualToSize);
        CFDictionaryAddValue(dictRef, @"NSMakeRange", &NSMakeRange);
        CFDictionaryAddValue(dictRef, @"NSMaxRange", &NSMaxRange);
        CFDictionaryAddValue(dictRef, @"NSLocationInRange", &NSLocationInRange);
        CFDictionaryAddValue(dictRef, @"NSEqualRanges", &NSEqualRanges);
        CFDictionaryAddValue(dictRef, @"UIEdgeInsetsMake", &UIEdgeInsetsMake);
        CFDictionaryAddValue(dictRef, @"UIEdgeInsetsInsetRect", &UIEdgeInsetsInsetRect);
        CFDictionaryAddValue(dictRef, @"UIOffsetMake", &UIOffsetMake);
        CFDictionaryAddValue(dictRef, @"UIEdgeInsetsEqualToEdgeInsets", &UIEdgeInsetsEqualToEdgeInsets);
        CFDictionaryAddValue(dictRef, @"UIOffsetEqualToOffset", &UIOffsetEqualToOffset);
        CFDictionaryAddValue(dictRef, @"__CGSizeApplyAffineTransform", &__CGSizeApplyAffineTransform);
        CFDictionaryAddValue(dictRef, @"__CGPointApplyAffineTransform", &__CGPointApplyAffineTransform);
        CFDictionaryAddValue(dictRef, @"__CGAffineTransformMake", &__CGAffineTransformMake);
        dictCFunction = dictRef;
        dict_367d20c = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, 0);
        dict_367d210 = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, 0);
        cInvokeReadWriteQueue = dispatch_queue_create("ocscript.cInvokeRead.read-write-qeueu", DISPATCH_QUEUE_CONCURRENT);
    });
}

/*
void sub_2a123e6(void * _block) {
    r0 = _block;
    stack[2043] = r4;
    stack[2044] = r5;
    stack[2045] = r6;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0x14) + 0xc;
    r0 = sub_2a1344e();
    r0 = CFDictionaryCreateMutable(*_kCFAllocatorSystemDefault, 0x0, _kCFTypeDictionaryKeyCallBacks, 0x0);
    r6 = r0;
    r0 = CFDictionaryAddValue(r0, @"CGRectMake", 0x2a1264f);
    r0 = CFDictionaryAddValue(r6, @"CGPointMake", 0x2a12663);
    r0 = CFDictionaryAddValue(r6, @"CGSizeMake", 0x2a12669);
    r0 = CFDictionaryAddValue(r6, @"CGVectorMake", 0x2a1266f);
    r0 = CFDictionaryAddValue(r6, @"__CGPointEqualToPoint", 0x2a12675);
    r0 = CFDictionaryAddValue(r6, @"__CGSizeEqualToSize", 0x2a126a1);
    r0 = CFDictionaryAddValue(r6, @"NSMakeRange", 0x2a126cd);
    r0 = CFDictionaryAddValue(r6, @"NSMaxRange", 0x2a126d3);
    r0 = CFDictionaryAddValue(r6, @"NSLocationInRange", 0x2a126d7);
    r0 = CFDictionaryAddValue(r6, @"NSEqualRanges", 0x2a126eb);
    r0 = CFDictionaryAddValue(r6, @"UIEdgeInsetsMake", 0x2a126fd);
    r0 = CFDictionaryAddValue(r6, @"UIEdgeInsetsInsetRect", 0x2a12711);
    r0 = CFDictionaryAddValue(r6, @"UIOffsetMake", 0x2a1275f);
    r0 = CFDictionaryAddValue(r6, @"UIEdgeInsetsEqualToEdgeInsets", 0x2a12765);
    r0 = CFDictionaryAddValue(r6, @"UIOffsetEqualToOffset", 0x2a127c3);
    r0 = CFDictionaryAddValue(r6, @"__CGSizeApplyAffineTransform", 0x2a127ef);
    r0 = CFDictionaryAddValue(r6, @"__CGPointApplyAffineTransform", 0x2a12849);
    r0 = CFDictionaryAddValue(r6, @"__CGAffineTransformMake", 0x2a128bb);
    *0x367d208 = r6;
    *0x367d20c = CFDictionaryCreateMutable(*_kCFAllocatorSystemDefault, 0x0, _kCFTypeDictionaryKeyCallBacks, 0x0);
    *0x367d210 = CFDictionaryCreateMutable(*_kCFAllocatorSystemDefault, 0x0, _kCFTypeDictionaryKeyCallBacks, 0x0);
    *0x367d214 = dispatch_queue_create("ocscript.cInvokeRead.read-write-qeueu", __dispatch_queue_attr_concurrent);
    return;
}
 */

// sub_2a12b08
void
OCSSetUpCStructEnvironment() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // sub_2a12b34
        structTypeDictReadWriteQueue = dispatch_queue_create("ocscript.OCSEngine.structTypeDict.read-write-qeueu", DISPATCH_QUEUE_CONCURRENT);
        dictStructType = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, 0);
    });
}

// sub_2a12b8e
OCS_StructType *
OCSGetStructType(NSString *typeString) {
    NSCAssert(typeString, @"structTypeEncode && \"Get StructType With typeName NULL\"");
    
    __block OCS_StructType *st = NULL;
    dispatch_sync(structTypeDictReadWriteQueue, ^{
        // sub_2a12c70
        st = (OCS_StructType *)CFDictionaryGetValue(dictStructType, (__bridge CFStringRef)typeString);
    });
    
    if (!st) {
        dispatch_barrier_sync(structTypeDictReadWriteQueue, ^{
            // sub_2a12ca2
            st = (OCS_StructType *)CFDictionaryGetValue(dictStructType, (__bridge CFStringRef)typeString);
            if (!st) {
                if (!typeString) {
                    [NSException raise:@"OCSException" format:@"OCSGetStructType structTypeEncode == NULL"];
                }
                
                st = malloc(sizeof(OCS_StructType));
                st->_0x0 = 0;
                st->typeStruct = [OCSStructTypeParser parseStructEncode:typeString];
                
                CFDictionarySetValue(dictStructType, (__bridge CFStringRef)typeString, st);
            }
        });
    }
    
    return st;
}

/*
int sub_2a12b8e(int arg0) {
    stack[2043] = r4;
    stack[2044] = r5;
    stack[2045] = r6;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0x14) + 0xc;
    stack[4611686018427389944] = r8;
    stack[4611686018427389945] = r10;
    stack[4611686018427389946] = r11;
    sp = sp - 0x6c;
    r4 = arg0;
    if (r4 != 0x0) {
        r5 = 0x367d21c;
        r6 = __NSConcreteStackBlock;
        r0 = 0x14;
        stack[2035] = 0x0;
        stack[2036] = sp + 0x38;
        r1 = 0x2a12c71;
        stack[2037] = 0x20000000;
        r2 = 0x2f01d00;
        asm { strd       r0, fp, [sp, #0x64 + var_20] };
        r10 = 0xc2000000;
        r0 = *r5;
        r3 = sp + 0x28;
        stack[2028] = r6;
        asm { strd       sl, fp, [sp, #0x64 + var_44] };
        asm { stm.w      r3, {r1, r2, r8} };
        stack[2034] = r4;
        r0 = dispatch_sync(r0, sp + 0x1c);
        r5 = *(stack[2036] + 0x10);
        if (r5 == 0x0) {
            r3 = sp + 0xc;
            r1 = 0x2a12ca3;
            r0 = *0x367d21c;
            r2 = 0x4ef0f4;
            asm { stm.w      sp, {r6, sl, fp} };
            r2 = r2 + 0x2a12c2c;
            asm { stm.w      r3, {r1, r2, r8} };
            stack[2027] = r4;
            r0 = dispatch_barrier_sync(r0, sp);
            r5 = *(stack[2036] + 0x10);
        }
        r0 = sp + 0x38;
        r1 = 0x8;
        r0 = _Block_object_dispose();
        r0 = r5;
        sp = sp + 0x4c;
    }
    else {
        r2 = 0x31;
        r0 = "OCSGetStructType";
        r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/Bridge/NativeCBridge/OCSNativeCStruct.m";
        r3 = "structTypeEncode && \"Get StructType With typeName NULL\"";
        r0 = __assert_rtn();
    }
    return r0;
}
*/

/*
int sub_2a12c70(int arg0) {
    stack[2045] = r4;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0xc) + 0x4;
    r0 = CFDictionaryGetValue(*0x367d220, *(arg0 + 0x18));
    *(*(*(arg0 + 0x14) + 0x4) + 0x10) = r0;
    return r0;
}
 */

/*
int sub_2a12ca2(int arg0) {
    stack[2043] = r4;
    stack[2044] = r5;
    stack[2045] = r6;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0x14) + 0xc;
    r4 = arg0;
    *(*(*(r4 + 0x14) + 0x4) + 0x10) = CFDictionaryGetValue(*0x367d220, *(r4 + 0x18));
    r0 = *(*(*(r4 + 0x14) + 0x4) + 0x10);
    if (r0 == 0x0) {
        if (*(r4 + 0x18) == 0x0) {
            r0 = [NSException raise:@"OCSException" format:@"OCSGetStructType structTypeEncode == NULL"];
            r2 = *(r4 + 0x18);
        }
        r5 = [[OCSStructTypeParser parseStructEncode:r2] retain];
        *(*(*(r4 + 0x14) + 0x4) + 0x10) = malloc(0x8);
        **(*(*(r4 + 0x14) + 0x4) + 0x10) = 0x0;
        *(*(*(*(r4 + 0x14) + 0x4) + 0x10) + 0x4) = r5;
        r1 = *(r4 + 0x18);
        r0 = *0x367d220;
        r2 = *(*(*(r4 + 0x14) + 0x4) + 0x10);
        r0 = CFDictionarySetValue(r0, r1, r2);
    }
    return r0;
}
 */

OCS_Struct *
OCSCreateRValueStruct(NSString *type) {
    OCS_Struct* r = malloc(sizeof(OCS_Struct));
    OCS_StructType *st = OCSGetStructType(type);
    r->structType = st;
    r->type = OCSStrucValueTypeR;
    r->value = malloc([st->typeStruct totalSize]);
    return r;
}

OCS_Struct *
OCSCreateRValueStructWithData(NSString *type, const void *data) {
    OCS_Struct* r = malloc(sizeof(OCS_Struct));
    OCS_StructType *st = OCSGetStructType(type);
    
    void *buf = malloc([st->typeStruct totalSize]);
    memcpy(buf, data, [st->typeStruct totalSize]);
    r->structType = st;
    r->type = OCSStrucValueTypeR;
    r->value = buf;
    return r;
}

OCS_Struct *
OCSCreateLValueStruct(NSString *type, void *data) {
    OCS_Struct* r = malloc(sizeof(OCS_Struct));
    OCS_StructType *st = OCSGetStructType(type);
    r->structType = st;
    r->type = OCSStrucValueTypeL;
    r->value = data;
    return r;
}

// sub_2a12e24
OCS_Struct *
OCSCreateCopyStruct(OCS_Struct *s, OCSStrucValueType valueType) {
    NSCAssert(s, @"s && \"Copy NULL OCSStruct\"");
    if (s) {
        OCS_Struct* cp = malloc(sizeof(OCS_Struct));
        if (valueType == OCSStrucValueTypeL) {
            cp->structType = s->structType;
            cp->value = s->value;
        }
        else {
            OCS_StructType *st = s->structType;
            void *buf = malloc([st->typeStruct totalSize]);
            memcpy(buf, s->value, [st->typeStruct totalSize]);
            cp->structType = st;
            cp->type = OCSStrucValueTypeR;
            cp->value = buf;
        }
        
        cp->type = valueType;
        
        return cp;
    }
    
    return NULL;
}


/*
int sub_2a12e24(int arg0, int arg1) {
    stack[2043] = r4;
    stack[2044] = r5;
    stack[2045] = r6;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0x14) + 0xc;
    stack[4611686018427389944] = r8;
    stack[4611686018427389945] = r10;
    stack[4611686018427389946] = r11;
    sp = sp - 0x20;
    r6 = arg0;
    r4 = arg1;
    if (r6 != 0x0) {
        r5 = malloc(0xc);
        if ((r4 & 0xff) != 0x0) {
            *r5 = *r6;
            *(r5 + 0x8) = *(r6 + 0x8);
        }
        else {
            r10 = malloc([*(*r6 + 0x4) totalSize]);
            r0 = [*(*r6 + 0x4) totalSize];
            r0 = memcpy(r10, *(r6 + 0x8), r0);
            *r5 = *r6;
            *(r5 + 0x8) = r10;
        }
        *(r5 + 0x4) = r4;
        r0 = r5;
    }
    else {
        r2 = 0x80;
        r0 = "OCSCreateCopyStruct";
        r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/Bridge/NativeCBridge/OCSNativeCStruct.m";
        r3 = "s && \"Copy NULL OCSStruct\"";
        r0 = __assert_rtn();
    }
    return r0;
}
*/

// sub_2a11118
void
OCSDestroyStruct(OCS_Struct *s) {
    NSCAssert(s, @"s && \"Destroy NULL OCSStruct\"");
    if (s->type == OCSStrucValueTypeR) {
        free(s->value);
    }
    
    free(s);
}

void
OCSPutField(OCS_Struct *d, NSUInteger idx, OCS_Param *s, OCSStrucValueType valueType) {

    // r0: typeC.charType
    // r1: @selector(charType)
    // r2: arg1
    // r4: @selector(charType)
    // r5: arg0->value
    // r6: typeC
    // r8: d->value + typeC.startIndex
    // sl: arg2

    OCSTypeStruct *ts = d->structType->typeStruct;
    OCSTypyCommon *typeC = [ts memberStructSizeValues][idx];
    // void *r8 = &(d->value[typeC.startIndex]);
    switch(typeC.charType) {
        case '#': // Class
        case '*': // char *
        case ':': // SEL
        case '@': // id
        case 'I': // unsigned int
        case 'L': // unsigned long
        case '^': // pointer
        case 'f': // float
        case 'i': // int
        case 'l': // long
        {
            // loc_357b78

            // var_20: arg2->_0x4
            // r0: arg2->_0x4

            d->value[typeC.startIndex] = s->arg;

            // loc_357be2

        }
            break;
        case 'B': // bool
        case 'C': // usigned char
        case 'c': // char
        {
            // loc_357b2a
            // var_20: s->arg
            // r0: s->arg

            d->value[typeC.startIndex] = s->arg;

            // loc_357be2
        }
            break;
        case 'Q': // unsigned long long
        case 'q': // long long
        {
            // loc_357b9e

            // var_20: s->arg, s->arg + 0x4
            // d16: s->arg, s->arg + 0x4

            // loc_357bde
            d->value[typeC.startIndex] = s->arg, s->arg;

            // loc_357be2

            
        }
            break;
        case 'S': // unsigned short
        case 's': // short
        {
            // loc_357b8c

            // var_20: s->arg
            // r0: s->arg

            d->value[typeC.startIndex] = s->arg;

            // loc_357be2

        }
            break;
        case 'd': // double
        {
            // loc_357bd6

            // var_20: s->arg;
            // d16: s->arg;

            // loc_357bde
            d->value[typeC.startIndex] = s->arg;

            // loc_357be2
        }
            break;
        // case 'v': // void
        // {
            
        // }
        //     break;
        case '{': // struct
        {
            // loc_357b52

            r0: d->value + typeC.startIndex
            r1: st->type
            r2: [typeC totalSize]
            r4: st->type

            OCS_Struct* st = s->arg;

            memcpy(d->value + typeC.startIndex, st->type, [typeC totalSize]);

            // loc_357be2
        }
            break;
        default:
        {
            // loc_357bb0
            [NSException raise:@"OCSCommonException" format:@"OCSPutField Unsupported return type: %c", typeC.charType];

            // loc_357be2
            
        }
            break;

    }

    /*
            // [ 0x5d
            if (aType > '[') {
                // loc_357b0c
                // aType - 0x63
                // v 0x63 + 0x10
                // 0x73
                if (aType > 0x73) {
                    // loc_357b4a
                    
                    // ^ 0x5e
                    if (aType == '^') {
                        // loc_357b78
                    }
                    // { 0x7b
                    else if (aType == '{') {
                        // loc_357b52
                    }
                    else {
                        // loc_357bb0
                    }
                }
                else {
                    // loc_3554d4

                    // aType - 0x63
                    switch (aType) {
                        // tb 0x09
                        case 'c': // 0x63 0
                        {
                            // loc_357b2a
                        }
                            break;
                        // tb 0x5f
                        case 'd': // 0x64 1
                        {
                            // loc_357bd6
                        }
                            break;
                       // // tb 0x4c
                       // // tb 2 dup (0x3f)
                       // // 4  5
                       // // 67 68
                       // // g  h
                       // // tb 2 dup (0x3f)
                       // // 7  8
                       // // 6a 6b
                       // // j  k
                       // case 'e': // 0x65 2
                       // case 'g':
                       // case 'h':
                       // {
                       //     // loc_357d1c
                       // }
                       //     break;
                        // tb 0x30
                        case 'f': // 0x66 3
                        {
                            // loc_357b78
                        }
                            break;
                        // tb 0x30
                        case 'i': // 0x69 6
                        {
                            // loc_357b78
                        }
                            break;
                        // tb 0x30
                        case 'l': // 0x6c 9
                        {
                            // loc_357b78
                        }
                            break;
                        // tb 0x43
                        case 'q': // 0x71 14
                        {
                            // loc_357b9e
                        }
                            break;
                        // tb 0x3a
                        case 's': // 0x73 16
                        {
                            // loc_357b8c
                        }
                            break;
                        //case 'v': // 0x76 19
                        //{
                        //}
                        //    break;
                        default:
                        {
                            // loc_35597a
                        }
                            break;
                    }
                }
            }
            // H 0x48
            else if (aType > 'H') {
                // loc_357b3c
                // 0x50
                if (aType > 0x50) {
                    // loc_357b84
                    // 0x51 Q
                    if (aType == 'Q') {
                        // loc_357b9e
                    }
                    // 0x53 S
                    else if (aType == 'S') {
                        // loc_357b8c
                    }
                    else {
                        // loc_357bb0
                    }
                }
                else {
                    // loc_3558ee
                    // 0x49 I
                    if (aType == 'I') {
                        // loc_357b78
                    }
                    // 0x4c L
                    else if (aType == 'L') {
                        // loc_357b78
                    }
                    else {
                        // loc_357bb0
                    }
                    
                }
            }
            // C 0x43
            else if (aType > 'C') {
                // loc_357b70
                if (aType == '#') {
                    // loc_357b78
                }
                else if (aType == '*') {
                    // loc_357b78
                }
                else {
                    // loc_357bb0
                }
            }
            else {
                // loc_357c7
                // rType - 0x3a
                switch (aType) {
                    // tb 0x3b
                    case ':': // 0x3a 0
                    {
                        // loc_357b78
                    }
                        break;
                   // // tb 5 dup (0x57)
                   // // 1  2  3  4  5
                   // // 3b 3c 3d 3e 3f
                   // // ;  <  =  >  ?
                   // case ';':
                   // case '<':
                   // case '=':
                   // case '>':
                   // case '?': // 0x3f
                   // case 'A': // 0x41
                   // {
                   //     // loc_357bb0
                   // }
                   //     break
                    // tb 0x3b
                    case '@': // 0x40
                    {
                        // loc_357b78
                    }
                        break;
                    // tb 0x14
                    case 'B': // 0x42
                    {
                        // loc_357b2a
                    }
                        break;
                    // tb 0x14
                    case 'C': // 0x43
                    {
                        // loc_357b2a
                    }
                        break;
                    default:
                    {
                        // loc_357b2a
                    }
                        break;
                }
            }
        */
    
}


void
OCSGetFieldValue(OCS_Param *d, OCS_Struct *s, NSUInteger idx, OCSStrucValueType valueType) {

    // var_1C: arg0

    // r0: typeC.charType
    // r1: 0xffff0000
    // r2: 0x330c68
    // r4: @selector(charType)
    // r5: typeC
    // r6: s->value + typeC.startIndex
    // r8: s->value
    // fp: arg3
    // sl: 0x00000000

    OCSTypeStruct *ts = s->structType->typeStruct;

    OCSTypyCommon *typeC = [ts memberStructSizeValues][ idx ];



    switch(typeC.charType) {
        case '#': // Class
        {
            // loc_357db8

            // r0: 0x23
            // sl: s->value[ typeC.startIndex ]

            // loc_357dc6
            // r0: valueTag(0x23);

            // loc_357dca
            // r4: 0x0


        }
            break;
        case '*': // char *
        {
            // loc_357cfe
            // r0: 0x2a
            // sl: s->value[ typeC.startIndex ]

            // loc_357dc6
            // r0: valueTag(0x2a);

            // loc_357dca
            // r4: 0x0

        }
            break;
        case ':': // SEL
        {
            // loc_357c8a
            // r0: 0x3a
            // sl: s->value[ typeC.startIndex ]

            // loc_357dc6
            // r0: valueTag(0x3a);

            // loc_357dca
            // r4: 0x0
        }
            break;
        case '@': // id
        {
            // loc_357d44
            // r0: 0x40
            // sl: s->value[ typeC.startIndex ]

            // loc_357dc6
            // r0: valueTag(0x40);

            // loc_357dca
            // r4: 0x0
        }
            break;
        case 'B': // bool
        {
            // loc_357d4c
            // r0: 0x42
            // sl: s->value[ typeC.startIndex ] & 0xff

            // loc_357dc6
            // r0: valueTag(0x42);

            // loc_357dca
            // r4: 0x0
        }
            break;
        case 'C': // usigned char
        {
            // loc_357d5a
            // r0: 0x43
            // sl: s->value[ typeC.startIndex ] & 0xff

            // loc_357dc6
            // r0: valueTag(0x43);

            // loc_357dca
            // r4: 0x0
        }
            break;
        case 'I': // unsigned int
        {
            // loc_357da2
            // r0: 0x49
            // sl: s->value[ typeC.startIndex ]

            // loc_357dc6
            // r0: valueTag(0x49);

            // loc_357dca
            // r4: 0x0
        }
            break;
        case 'L': // unsigned long
        {
            // loc_357cca
            // r0: 0x4c
            // sl: s->value[ typeC.startIndex ]

            // loc_357dc6
            // r0: valueTag(0x43);

            // loc_357dca
            // r4: 0x0

            // loc_357dcc
        }
            break;
        case 'Q': // unsigned long long
        {
            // loc_357daa
            // r0: 0x51
            // r4: s->value[ typeC.startIndex + 0x4 ]
            // sl: s->value[ typeC.startIndex ]

            // loc_357db2
            // r0: valueTag(0x51);

            // loc_357dcc
        }
            break;
        case 'S': // unsigned short
        {
            // loc_357d0e
            // r0: 0x53
            // r1: 0x0 &  0xffff0000
            // sl: s->value[ typeC.startIndex ] | (0x0 &  0xffff0000)
            // loc_357dc6
            // r0: valueTag(0x53);

            // loc_357dca
            // r4: 0x0
        }
            break;

        case '^': // pointer
        {
            // loc_357dc0
            // r0: 0x5e
            // sl: s->value[ typeC.startIndex ]

            // loc_357dc6
            // r0: valueTag(0x5e);

            // loc_357dca
            // r4: 0x0
        }
            break;
        case 'c': // char
        {
            // loc_357cb0
            // r0: 0x63
            // sl: s->value[ typeC.startIndex ]

            // loc_357dc6
            // r0: valueTag(0x63);

            // loc_357dca
            // r4: 0x0

        }
            break;
        case 'd': // double
        {
            // loc_357d68
            // r0: 0x64
            // r4: s->value[ typeC.startIndex + 0x4 ]
            // sl: s->value[ typeC.startIndex ]

            // loc_357db2
            // r0: valueTag(0x64);

            // loc_357dcc
        }
            break;
        case 'f': // float
        {
            // loc_357d72
            // r0: 0x66
            // sl: s->value[ typeC.startIndex ]

            // loc_357dc6
            // r0: valueTag(0x66);

            // loc_357dca
            // r4: 0x0
        }
            break;
        case 'i': // int
        {
            // loc_357d7a
            // r0: 0x69
            // sl: s->value[ typeC.startIndex ]

            // loc_357dc6
            // r0: valueTag(0x69);

            // loc_357dca
            // r4: 0x0
        }
            break;
        case 'l': // long
        {
            // loc_357d82
            // r0: 0x6c
            // sl: s->value[ typeC.startIndex ]

            // loc_357dc6
            // r0: valueTag(0x6c);

            // loc_357dca
            // r4: 0x0
        }
            break;
        case 'q': // long long
        {
            // loc_357d8a
            // r0: 0x71
            // r4: s->value[ typeC.startIndex + 0x4 ]
            // sl: s->value[ typeC.startIndex ]

            // loc_357db2
            // r0: valueTag(0x71);

            // loc_357dcc
        }
            break;
        case 's': // short
        {
            // loc_357d94
            // r0: 0x73
            // r1: 0x0 &  0xffff0000
            // sl: s->value[ typeC.startIndex ] | (0x0 &  0xffff0000)
            // loc_357dc6
            // r0: valueTag(0x73);

            // loc_357dca
            // r4: 0x0
        }
            break;
        // case 'v': // void
        // {
            
        // }
        //     break;
        case '{': // struct
        {
            // loc_357cda

            // r0: [typeC encode]
            // r1: @selector(encode)

            // [typeC encode]

            if (valueType == OCSStrucValueTypeR) {
                // loc_357ddc
                // r0: st->value
                // r1: s->value + typeC.startIndex
                // r2: [typeC totalSize]
                // r4: st->value
                // sl: st

                OCS_Struct *st = OCSCreateRValueStruct([typeC encode]);
                memcpy(st->value, s->value + typeC.startIndex, [typeC totalSize]);

                // loc_357dfc
            }
            else {
                // 357cec

                // r1: s->value + typeC.startIndex
                // sl: st

                OCS_Struct *st = OCSCreateLValueStruct([typeC encode], s->value + typeC.startIndex);

                // loc_357dfc
            }

            // loc_357dfc
            // r0: 0x11
            // r4: 0x0

            // loc_357dcc


            
        }
            break;
        default:
        {
            [NSException raise:@"OCSCommonException" format:@"OCSGetFieldValue Unsupported return type: %c", typeC.charType];
            
        }
            break;
    }

    /*
            // [ 0x5d
            if (aType > '[') {
                // loc_357c92
                // aType - 0x63
                // v 0x63 + 0x10
                // 0x73
                if (aType > 0x73) {
                    // loc_357cd2
                    
                    // ^ 0x5e
                    if (aType == '^') {
                        // loc_357dc0
                    }
                    // { 0x7b
                    else if (aType == '{') {
                        // loc_357cda
                    }
                    else {
                        // loc_357d1c
                    }
                }
                else {
                    // loc_3554d4

                    // aType - 0x63
                    switch (aType) {
                        // tb 0x09
                        case 'c': // 0x63 0
                        {
                            // loc_357cb0
                        }
                            break;
                        // tb 0x65
                        case 'd': // 0x64 1
                        {
                            // loc_357d68
                        }
                            break;
                       // // tb 0x3f
                       // // tb 2 dup (0x3f)
                       // // 4  5
                       // // 67 68
                       // // g  h
                       // // tb 2 dup (0x3f)
                       // // 7  8
                       // // 6a 6b
                       // // j  k
                       // case 'e': // 0x65 2
                       // case 'g':
                       // case 'h':
                       // {
                       //     // loc_357d1c
                       // }
                       //     break;
                        // tb 0x6a
                        case 'f': // 0x66 3
                        {
                            // loc_357d72
                        }
                            break;
                        // tb 0x6e
                        case 'i': // 0x69 6
                        {
                            // loc_357d7a
                        }
                            break;
                        // tb 0x72
                        case 'l': // 0x6c 9
                        {
                            // loc_357d82
                        }
                            break;
                        // tb 0x76
                        case 'q': // 0x71 14
                        {
                            // loc_357d8a
                        }
                            break;
                        // tb 0x7b
                        case 's': // 0x73 16
                        {
                            // loc_357d94
                        }
                            break;
                        //case 'v': // 0x76 19
                        //{
                        //}
                        //    break;
                        default:
                        {
                            // loc_35597a
                        }
                            break;
                    }
                }
            }
            // H 0x48
            else if (aType > 'H') {
                // loc_357cbe
                // 0x50
                if (aType > 0x50) {
                    // loc_357d06
                    // 0x51 Q
                    if (aType == 'Q') {
                        // loc_357daa
                    }
                    // 0x53 S
                    else if (aType == 'S') {
                        // loc_357d0e
                    }
                    else {
                        // loc_357d1c
                    }
                }
                else {
                    // loc_3558ee
                    // 0x49 I
                    if (aType == 'I') {
                        // loc_357da2
                    }
                    // 0x4c L
                    else if (aType == 'L') {
                        // loc_357cca
                    }
                    else {
                        // loc_357d1c
                    }
                    
                }
            }
            // C 0x43
            else if (aType > 'C') {
                // loc_357cf6
                if (aType == '#') {
                    // loc_357db8
                }
                else if (aType == '*') {
                    // loc_357cfe
                }
                else {
                    // loc_35597a
                }
            }
            else {
                // loc_357c7
                // rType - 0x3a
                switch (aType) {
                    // tb 0x05
                    case ':': // 0x3a 0
                    {
                        // loc_357c8a
                    }
                        break;
                   // // tb 5 dup (0x4e)
                   // // 1  2  3  4  5
                   // // 3b 3c 3d 3e 3f
                   // // ;  <  =  >  ?
                   // case ';':
                   // case '<':
                   // case '=':
                   // case '>':
                   // case '?': // 0x3f
                   // case 'A': // 0x41
                   // {
                   //     // loc_357d1c
                   // }
                   //     break
                    // tb 0x62
                    case '@': // 0x40
                    {
                        // loc_357d44
                    }
                        break;
                    // tb 0x66
                    case 'B': // 0x42
                    {
                        // loc_357d4c
                    }
                        break;
                    // tb 0x6d
                    case 'C': // 0x43
                    {
                        // loc_357d5a
                    }
                        break;
                    default:
                    {
                        // loc_35597a
                    }
                        break;
                }
            }
        */


    // loc_357dcc

    // r1: arg0

    d->vTag = r0;
    d->arg = sl;
    d->arg + 0x4 = r4;
}


void
getFfi_typeForCharType(const char type) {}

// sub_2a1264e
//CGRect
//QPCGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
//    return CGRectMake(x, y, width, height);
//}

// sub_2a1344e
void
initAppImagebase() {
    NSString *mainBundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    //Get count of all currently loaded DYLD
    uint32_t count = _dyld_image_count();
    for(uint32_t i = 0; i < count; i++) {
        
        //Name of image (includes full path)
        const char *dyld = _dyld_get_image_name(i);
        
        NSString *imgeName = [[NSString stringWithUTF8String:dyld] lastPathComponent];
        
        if ([imgeName isEqualToString:mainBundleName]) {
            // loc_2a13514
            int_35d3dcc = 0;
            image_header = _dyld_get_image_header(i);
            printf("imageName:%s base:%zd\n", [imgeName UTF8String], image_header);
            break;
        }
    }
}

/*
int sub_2a1344e() {
    stack[2043] = r4;
    stack[2044] = r5;
    stack[2045] = r6;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0x14) + 0xc;
    stack[4611686018427389944] = r8;
    stack[4611686018427389945] = r10;
    stack[4611686018427389946] = r11;
    sp = sp - 0x28;
    stack[2039] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    r0 = _dyld_image_count();
    stack[2038] = r0;
    if (r0 == 0x0) goto loc_2a1354c;
    
loc_2a134aa:
    r6 = 0x0;
    r11 = @selector(isEqualToString:);
    r4 = @selector(lastPathComponent);
    r5 = @selector(stringWithUTF8String:);
    goto loc_2a134d2;
    
loc_2a134d2:
    r0 = r6;
    r8 = _dyld_get_image_header();
    r0 = r6;
    r0 = [NSString stringWithUTF8String:_dyld_get_image_name()];
    r0 = [r0 lastPathComponent];
    r10 = r0;
    if (([r0 isEqualToString:stack[2039]] & 0xff) != 0x0) goto loc_2a13514;
    
loc_2a1350a:
    r0 = stack[2038];
    r6 = r6 + 0x1;
    if (r6 < r0) goto loc_2a134d2;
    
loc_2a1354c:
    sp = sp + 0x8;
    return r0;
    
loc_2a13514:
    *0x35d3dcc = 0x0;
    *0x35d3dc8 = r8;
    r0 = [r10 UTF8String];
    r2 = *0x35d3dc8;
    r3 = *0x35d3dcc;
    r0 = printf("imageName:%s base:%zd\n", r0, r2);
    goto loc_2a1354c;
}
*/

// sub_2a13760
void
OCSSetUpEnvironment() {
    OCSSetUpCStructEnvironment();
    OCSSetUpCFunctionEnvironment();
}

/*
 int sub_2a13760() {
 stack[2046] = r7;
 stack[2047] = lr;
 r7 = sp - 0x8;
 r0 = sub_2a12b08();
 r0 = sub_2a123ba();
 return r0;
 }
 */
