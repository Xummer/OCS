//
//  OCSExecutable.m
//  OCS
//
//  Created by Xummer on 2017/5/10.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSVM_code.h"

// sub_2a137d4
OCS_Executable*
OCSExecutableCreate(NSString *fileName, NSData *data, NSUInteger* errorCode) {
    if (data) {
        
        // XTest: 记得释放
        OCS_Executable *exe = malloc(sizeof(OCS_Executable));
        
        // loc_2a137f2
        exe->fileName = CFStringCreateCopy(kCFAllocatorDefault, (__bridge CFStringRef)fileName);
        
        const char *bytes = [data bytes];
        
#define OCS_READ_VALUE(type, offset) (*(type *)(bytes + offset))
#define OCSBYTE_FROM(n) ((int8_t)bytes[n]&0xff)
#define OCS2BYTE_FROM(n) ((int16_t)OCSBYTE_FROM(n) << 0x8 | OCSBYTE_FROM(n + 1))
#define OCS4BYTE_FROM(n) ((int32_t)OCS2BYTE_FROM(n) << 0x10 | OCS2BYTE_FROM(n + 2))
#define OCS8BYTE_FROM(n) ((int64_t)OCS4BYTE_FROM(n) << 0x20 | OCS4BYTE_FROM(n + 4))
        
        if ((OCS4BYTE_FROM(0) == 0xdabb1e67) &&
            (OCS2BYTE_FROM(4) == 0) &&
            (OCS2BYTE_FROM(6) == 0x2))
            //            if ((*((uint32_t *)bytes) == 0xdabb1e67) &&
            //                (*(uint16_t *)(bytes + 4) == 0) &&
            //                (*(uint16_t *)(bytes + 6) == 0x2))
        {
            //loc_2a13878:
            if (OCS2BYTE_FROM(8) == 0x20) {
                // loc_2a13886
                exe->clsName = CFStringCreateWithCString(kCFAllocatorDefault, &bytes[0xc], kCFStringEncodingUTF8);
                
                int16_t clsLen = OCS2BYTE_FROM(0xa);
                
                //                    NSLog(@"0x%x", clsLen);
                
                int32_t methodNamesOffset = OCS4BYTE_FROM(clsLen+0x11);
                
                //                    NSLog(@"0x%x", methodNamesOffset); // 0x0a52
                
                //                    int8_t r8 = OCSBYTE_FROM(offset);
                //
                //                    NSLog(@"r8 0x%x", r8);
                
                int32_t size /*r4*/ = OCS4BYTE_FROM(methodNamesOffset); // 00 00 15 70
                exe->size = size;
                
                exe->methodNames = malloc(size);
                
                int32_t tableOffset = methodNamesOffset+0x4;
                
                memcpy(exe->methodNames, &bytes[tableOffset], size);
                
                NSLog(@"%s", &exe->methodNames[5]);
                
                int32_t constPoolOffset /*r10*/ = OCS4BYTE_FROM(clsLen+0xd);
                
                //                    NSLog(@"r10 0x%x", constPoolOffset); // 0x32
                
                int32_t constPoolCount = OCS4BYTE_FROM(constPoolOffset);
                
                exe->constPoolCount = constPoolCount;
                
                //                    NSLog(@"r5 0x%x", constPoolCount); // 00 00 00 D8 (216)
                
                // loc_2a13e3c
                NSCAssert(exe->constPoolCount < 65536, @"exe->constPoolCount < 65536 && \"const pool count shuold not exceed 65536\"");
                
                // loc_2a13956
                OCS_ConstantPool *constPool = malloc(constPoolCount * sizeof(OCS_ConstantPool));
                exe->constPool = constPool;
                
                if (constPoolCount == 0) {
                    // loc_2a13c3c
                    //                            stack[2035] = r5;
                    //                            stack[2018] = r8;
                }
                else {
                    // loc_2a1397e
                    //                            stack[2031] = r4;
                    //                            r11 = r10 + 0x4;
                    //                            r4 = 0x0;
                    //                            r10 = 0x0;
                    //                            stack[2032] = @selector(raise:format:);
                    
                    
                    int32_t nextOffset = constPoolOffset + 0x4;
                    //                            int32_t delta = 0;
                    
                    for (int32_t i = 0; i < constPoolCount; i ++) {
                        // loc_2a13998
                        //                                r1 = *(int8_t *)r11;
                        //                                r5 = r11 + 0x4;
                        //                                r0 = r1 - 0x1;
                        //                                if (r0 > 0x8)
                        
                        int8_t constPoolItemTag = OCSBYTE_FROM(nextOffset);
                        
                        NSLog(@"-0x%x", constPoolItemTag);
                        
                        int32_t itemLen = 0x4;
                        
                        if (constPoolItemTag > OCS_CONSTANT_8) {
                            // loc_2a13bc0
                            [NSException raise:@"OCSCommonException" format:@"Invalid ConstPoolItem Tag while parsing data constTag:%d", constPoolItemTag];
                            //                                r11 = r5;
                        }
                        else {
                            // loc_2a139a6
                            OCS_ConstantPool cp;
                            switch (constPoolItemTag) {
                                case OCS_CONSTANT_0://0x0009:
                                    // loc_2a139bc
                                {
                                    //                                            stack[2023] = *(r8 + 0x4);
                                    //                                            *(*(r8 + 0x4) + r4) = 0x1;
                                    //                                            *(0x4 + *(r8 + 0x4) + r4) = *(int8_t *)(r11 + 0x5) << 0x10 | *(int8_t *)(r11 + 0x4) * 0x1000000 | *(int8_t *)(r11 + 0x6) * 0x100 | *(int8_t *)(r11 + 0x7);
                                    //                                            goto loc_2a13a74;
                                    cp.tag = OCS_CONSTANT_0;
                                    cp.u.c_int = OCS4BYTE_FROM(nextOffset + 0x4);
                                    exe->constPool[i] = cp;
                                    
                                    // loc_2a13a74
                                    itemLen = 0x8;
                                    
                                }
                                    break;
                                case OCS_CONSTANT_1://0x001f:
                                    // loc_2a139e8
                                {
                                    cp.tag = OCS_CONSTANT_1;
                                    cp.u.c_long = OCS8BYTE_FROM(nextOffset + 0x4);
                                    exe->constPool[i] = cp;
                                    
                                    // loc_2a13c1e:
                                    itemLen = 0xc;
                                }
                                    break;
                                case OCS_CONSTANT_2://0x004e:
                                    // loc_2a13a46
                                {
                                    cp.tag = OCS_CONSTANT_2;
                                    cp.u.c_float = OCS4BYTE_FROM(nextOffset + 0x4);
                                    exe->constPool[i] = cp;
                                    
                                    // loc_2a13a74
                                    itemLen = 0x8;
                                }
                                    break;
                                case OCS_CONSTANT_3://0x0068:
                                    // loc_2a13a7a
                                {
                                    cp.tag = OCS_CONSTANT_3;
                                    cp.u.c_double = OCS8BYTE_FROM(nextOffset + 0x4);
                                    exe->constPool[i] = cp;
                                    
                                    // loc_2a13c1e:
                                    itemLen = 0xc;
                                }
                                    break;
                                case OCS_CONSTANT_4://0x0093:
                                    // loc_2a13ad0
                                {
                                    cp.tag = OCS_CONSTANT_4;
                                    int32_t startOffset = OCS4BYTE_FROM(nextOffset + 0x8);
                                    
                                    OCS_String c_s;
                                    
                                    c_s.offset = startOffset;
                                    
                                    CFStringRef strRef = CFStringCreateWithCString(kCFAllocatorDefault, &exe->methodNames[startOffset], kCFStringEncodingUTF8);
                                    
                                    NSLog(@"5 str: %@", strRef);
                                    
                                    // loc_2a13c1c
                                    c_s.value = strRef;
                                    cp.u.c_string = &c_s;
                                    exe->constPool[i] = cp;
                                    
                                    // loc_2a13c1e:
                                    itemLen = 0xc;
                                }
                                    break;
                                case OCS_CONSTANT_CLASS://0x00b3:
                                    // loc_2a13b10
                                {
                                    cp.tag = OCS_CONSTANT_CLASS;
                                    int32_t startOffset = OCS4BYTE_FROM(nextOffset + 0x8);
                                    
                                    OCS_Class c_c;
                                    
                                    c_c.offset = startOffset;
                                    
                                    Class cls = objc_getClass(&exe->methodNames[startOffset]);
                                    
                                    NSLog(@"6 cls: %@", cls);
                                    
                                    // loc_2a13c1c
                                    c_c.value = cls;
                                    cp.u.c_class = &c_c;
                                    exe->constPool[i] = cp;
                                    // loc_2a13c1e:
                                    itemLen = 0xc;
                                }
                                    break;
                                case OCS_CONSTANT_SEL://0x00ce:
                                    // loc_2a13b46
                                {
                                    cp.tag = OCS_CONSTANT_SEL;
                                    int32_t startOffset = OCS4BYTE_FROM(nextOffset + 0x8);
                                    
                                    OCS_SEL c_s;
                                    
                                    c_s.offset = startOffset;
                                    
                                    SEL sel = sel_registerName(&exe->methodNames[startOffset]);
                                    
                                    NSLog(@"7 SEL: %@", NSStringFromSelector(sel));
                                    
                                    // loc_2a13bb4
                                    c_s.value = sel;
                                    cp.u.c_sel = &c_s;
                                    exe->constPool[i] = cp;
                                    // loc_2a13c1e:
                                    itemLen = 0xc;
                                }
                                    break;
                                case OCS_CONSTANT_PROTOCOL://0x00ea:
                                    // loc_2a13b7e
                                {
                                    cp.tag = OCS_CONSTANT_PROTOCOL;
                                    int32_t startOffset = OCS4BYTE_FROM(nextOffset + 0x8);
                                    
                                    OCS_Protocol c_p;
                                    
                                    c_p.offset = startOffset;
                                    
                                    Protocol* protocol = objc_getProtocol(&exe->methodNames[startOffset]);
                                    
                                    NSLog(@"8 Ptc: %@", protocol);
                                    
                                    // loc_2a13bb4
                                    c_p.value = protocol;
                                    cp.u.c_protocol = &c_p;
                                    exe->constPool[i] = cp;
                                    // loc_2a13c1e:
                                    itemLen = 0xc;
                                }
                                    break;
                                case OCS_CONSTANT_8://0x0121:
                                    // loc_2a13bec
                                {
                                    cp.tag = OCS_CONSTANT_8;
                                    int32_t startOffset = OCS4BYTE_FROM(nextOffset + 0x8);
                                    
                                    OCS_Char c_cs;
                                    c_cs.offset = startOffset;
                                    
                                    NSLog(@"9 ??: %s", &exe->methodNames[startOffset]);
                                    
                                    
                                    // loc_2a13bb4
                                    c_cs.value = &exe->methodNames[startOffset];
                                    cp.u.c_cString = &c_cs;
                                    exe->constPool[i] = cp;
                                    // loc_2a13c1e:
                                    itemLen = 0xc;
                                }
                                    break;
                                default:
                                    break;
                            }
                        }
                        
                        // loc_2a13c22
                        //                                r10 = r10 + 0x1;
                        //                                r4 = r4 + 0x10;
                        //                                if (r10 < stack[2035]) goto loc_2a13998;
                        
                        nextOffset += itemLen;
                        //                                delta += 0x10;
                    }
                    
                    // loc_2a13c30
                    
                }
                
                // loc_2a13c42
                int32_t codeOffset /*r4*/ = OCS4BYTE_FROM(clsLen+0x15);
                int32_t codeCount /*r5*/ = OCS4BYTE_FROM(codeOffset);
                CFMutableDictionaryRef codesDict = CFDictionaryCreateMutable(CFAllocatorGetDefault(), codeCount, &kCFTypeDictionaryKeyCallBacks, 0);
                
                if (codeCount > 0) {
                    // loc_2a13c80
                    int32_t r6_offset = codeOffset + 0x4;
                    
                    for (int32_t i = 0; i < codeCount; i ++) {
                        // loc_2a13c84
                        int32_t delta = OCS4BYTE_FROM(r6_offset + 0x10);
                        
                        CFStringRef keyStr =
                        CFStringCreateWithCString(kCFAllocatorDefault, &exe->methodNames[delta], kCFStringEncodingUTF8);
                        
                        NSLog(@"%@", keyStr);
                        OCS_CodeBlock* codeBlock = malloc(sizeof(OCS_CodeBlock));
                        codeBlock->methodSignature = keyStr;
                        
                        size_t codeSize = OCS4BYTE_FROM(r6_offset);
                        codeBlock->codeSize = codeSize;
                        
                        // loc_2a13d82:
                        NSCAssert(codeBlock->codeSize < 65536, @"codeBlock->codeSize < 65536 && \"code block size shuold not exceed 65536\"");
                        
                        // loc_2a13d16
                        r6_offset += 0x14;
                        void *buf = malloc(codeSize);
                        codeBlock->buf = buf;
                        memcpy(buf, &bytes[r6_offset], codeSize);
                        codeBlock->localVarCount = OCS4BYTE_FROM(r6_offset + 0x4);
                        
                        // loc_2a13da8;
                        NSCAssert(codeBlock->localVarCount < 256, @"codeBlock->localVarCount < 256 && \"local var count shuold not exceed 256\"");
                        
                        codeBlock->stackSize = OCS4BYTE_FROM(r6_offset + 0x8);
                        // loc_2a13d46
                        NSCAssert(codeBlock->stackSize < 65536, @"codeBlock->stackSize < 65536 && \"stack size shuold not exceed 65536\"");
                        
                        // loc_2a13d64
                        CFDictionarySetValue(codesDict, keyStr, codeBlock);
                        
                        r6_offset += codeSize;
                        
                    }
                    
                    // loc_2a13d7a
                    
                }
                
                // loc_2a13d7a
                exe->dictCodes = codesDict;
                return exe;
                
            }
            else {
                // loc_2a13e18:
                NSCAssert(NO, @"(kArchMagicNum == kOCSExecutableArchMagicNum) && \"OCSExecutable architecture not match,update OCScript File \"");
            }
        }
        
#undef OCSBYTE_FROM
#undef OCS2BYTE_FROM
#undef OCS4BYTE_FROM
#undef OCS8BYTE_FROM
    }
    else {
        // loc_2a13df4
        NSCAssert(data, @"data && \"Create OCSExecutable from nil NSData\"");
    }
    
    return nil;
}

/*
int sub_2a137d4(int arg0, int arg1, int arg2) {
    r2 = arg2;
    r1 = arg1;
    r0 = arg0;
    stack[2043] = r4;
    stack[2044] = r5;
    stack[2045] = r6;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0x14) + 0xc;
    stack[4611686018427389944] = r8;
    stack[4611686018427389945] = r10;
    stack[4611686018427389946] = r11;
    r4 = sp - 0x80;
    asm { bfc        r4, #0x0, #0x3 };
    sp = r4;
    r4 = r1;
    r8 = r2;
    r6 = r0;
    if (r4 == 0x0) goto loc_2a13df4;
    
loc_2a137f2:
    r10 = malloc(0x1c);
    stack[2022] = *_kCFAllocatorSystemDefault;
    *(r10 + 0x14) = CFStringCreateCopy(*_kCFAllocatorSystemDefault, r6);
    r6 = [r4 bytes];
    if ((*(int8_t *)(r6 + 0x1) << 0x10 | *(int8_t *)r6 * 0x1000000 | *(int8_t *)(r6 + 0x2) * 0x100 | *(int8_t *)(r6 + 0x3)) != 0xdabb1e67) goto loc_2a13856;
    
loc_2a13848:
    if ((*(int8_t *)(r6 + 0x5) | *(int8_t *)(r6 + 0x4) * 0x100) == 0x0) goto loc_2a1386a;
    
loc_2a13852:
    r0 = 0x2;
    goto loc_2a13858;
    
loc_2a13858:
    *r8 = r0;
    r0 = 0x0;
    goto loc_2a1385e;
    
loc_2a1385e:
    sp = r7 - 0x18;
    return r0;
    
loc_2a1386a:
    if ((*(int8_t *)(r6 + 0x7) | *(int8_t *)(r6 + 0x6) * 0x100) != 0x2) goto loc_2a13c38;
    
loc_2a13878:
    if ((*(int8_t *)(r6 + 0x9) | *(int8_t *)(r6 + 0x8) * 0x100) != 0x20) goto loc_2a13e18;
    
loc_2a13886:
    stack[2022] = *_kCFAllocatorSystemDefault;
    *(r10 + 0x18) = CFStringCreateWithCString(stack[2022], r6 + 0xc, 0x8000100);
    r0 = *(int8_t *)(r6 + 0xb) | *(int8_t *)(r6 + 0xa) * 0x100;
    r1 = *(int8_t *)(r0 + r6 + 0x12) << 0x10;
    r1 = r1 | *(int8_t *)(r0 + r6 + 0x11) * 0x1000000;
    r1 = r1 | *(int8_t *)(r0 + r6 + 0x13) * 0x100;
    r1 = r1 | *(int8_t *)(r0 + r6 + 0x14);
    r8 = r6 + r1;
    r2 = *(int8_t *)(r6 + r1);
    r1 = *(int8_t *)(r8 + 0x1) << 0x10;
    r1 = r1 | r2 * 0x1000000 | *(int8_t *)(r8 + 0x2) * 0x100;
    stack[2033] = *(int8_t *)(r0 + r6 + 0x18);
    r4 = r1 | *(int8_t *)(r8 + 0x3);
    stack[2032] = *(int8_t *)(r0 + r6 + 0x17);
    stack[2031] = *(int8_t *)(r0 + r6 + 0x16);
    stack[2030] = *(int8_t *)(r0 + r6 + 0x15);
    stack[2035] = *(int8_t *)(r0 + r6 + 0xd);
    r5 = *(int8_t *)(r0 + r6 + 0xe);
    r11 = *(int8_t *)(r0 + r6 + 0xf);
    stack[2034] = *(int8_t *)(r0 + r6 + 0x10);
    *(r10 + 0x8) = r4;
    r0 = malloc(r4);
    r1 = r8 + 0x4;
    r8 = r10;
    stack[2020] = r1;
    *(r8 + 0xc) = r0;
    r0 = memcpy(r0, r1, r4);
    r10 = r6 + (r5 << 0x10 | stack[2035] * 0x1000000 | r11 * 0x100 | stack[2034]);
    r5 = *(int8_t *)(r10 + 0x1) << 0x10 | *(int8_t *)(r6 + (r5 << 0x10 | stack[2035] * 0x1000000 | r11 * 0x100 | stack[2034])) * 0x1000000 | *(int8_t *)(r10 + 0x2) * 0x100 | *(int8_t *)(r10 + 0x3);
    stack[2035] = r5;
    *r8 = r5;
    if (r5 >= 0x10000) goto loc_2a13e3c;
    
loc_2a13956:
    r4 = stack[2031] << 0x10 | stack[2030] * 0x1000000 | stack[2032] * 0x100 | stack[2033];
    r0 = malloc(r5 << 0x4);
    stack[2023] = r0;
    *(r8 + 0x4) = r0;
    if (r5 == 0x0) goto loc_2a13c3c;
    
loc_2a1397e:
    stack[2031] = r4;
    r11 = r10 + 0x4;
    r4 = 0x0;
    r10 = 0x0;
    stack[2032] = @selector(raise:format:);
    goto loc_2a13998;
    
loc_2a13998:
    r1 = *(int8_t *)r11;
    r5 = r11 + 0x4;
    r0 = r1 - 0x1;
    if (r0 > 0x8) goto loc_2a13bc0;
    
loc_2a139a6:
    goto *0x2a139aa[r0];
    
loc_2a139bc:
    stack[2023] = *(r8 + 0x4);
    *(*(r8 + 0x4) + r4) = 0x1;
    *(0x4 + *(r8 + 0x4) + r4) = *(int8_t *)(r11 + 0x5) << 0x10 | *(int8_t *)(r11 + 0x4) * 0x1000000 | *(int8_t *)(r11 + 0x6) * 0x100 | *(int8_t *)(r11 + 0x7);
    goto loc_2a13a74;
    
loc_2a13a74:
    r11 = r11 + 0x8;
    goto loc_2a13c22;
    
loc_2a13c22:
    r10 = r10 + 0x1;
    r4 = r4 + 0x10;
    if (r10 < stack[2035]) goto loc_2a13998;
    
loc_2a13c30:
    stack[2018] = r8;
    r4 = stack[2031];
    goto loc_2a13c42;
    
loc_2a13c42:
    r1 = *(int8_t *)(r6 + r4);
    r4 = r4 + r6;
    r5 = *(int8_t *)(r4 + 0x1) << 0x10 | r1 * 0x1000000 | *(int8_t *)(r4 + 0x2) * 0x100 | *(int8_t *)(r4 + 0x3);
    stack[2019] = r5;
    stack[2021] = CFDictionaryCreateMutable(*_kCFAllocatorSystemDefault, r5, _kCFTypeDictionaryKeyCallBacks, 0x35bbb08);
    if (r5 == 0x0) goto loc_2a13d7a;
    
loc_2a13c80:
    r6 = r4 + 0x4;
    r1 = 0x0;
    goto loc_2a13c84;
    
loc_2a13c84:
    stack[2025] = r1;
    r0 = *(int8_t *)(r6 + 0x11) << 0x10;
    r0 = r0 | *(int8_t *)(r6 + 0x10) * 0x1000000;
    r0 = r0 | *(int8_t *)(r6 + 0x12) * 0x100;
    r0 = r0 | *(int8_t *)(r6 + 0x13);
    stack[2030] = *(int8_t *)(r6 + 0x7);
    r8 = *(int8_t *)(r6 + 0x6);
    r10 = *(int8_t *)(r6 + 0x5);
    r5 = *(int8_t *)(r6 + 0x4);
    stack[2029] = *(int8_t *)(r6 + 0xb);
    stack[2028] = *(int8_t *)(r6 + 0xa);
    stack[2027] = *(int8_t *)(r6 + 0x9);
    stack[2026] = *(int8_t *)(r6 + 0x8);
    r4 = CFStringCreateWithCString(*_kCFAllocatorSystemDefault, stack[2020] + r0, 0x8000100);
    stack[2024] = r4;
    r11 = malloc(0x1c);
    *(r11 + 0x18) = r4;
    *(r11 + 0x8) = stack[2035];
    *(r11 + 0xc) = stack[2023];
    r4 = *(int8_t *)(r6 + 0x1) << 0x10 | *(int8_t *)r6 * 0x1000000 | *(int8_t *)(r6 + 0x2) * 0x100 | *(int8_t *)(r6 + 0x3);
    *r11 = r4;
    if (r4 >= 0x10000) goto loc_2a13d82;
    
loc_2a13d16:
    r6 = r6 + 0x14;
    r0 = malloc(r4);
    *(r11 + 0x4) = r0;
    r0 = memcpy(r0, r6, r4);
    *(r11 + 0x10) = r10 << 0x10 | r5 * 0x1000000 | r8 * 0x100 | stack[2030];
    if ((r10 << 0x10 | r5 * 0x1000000 | r8 * 0x100 | stack[2030]) >= 0x100) goto loc_2a13da8;
    
loc_2a13d46:
    *(r11 + 0x14) = stack[2027] << 0x10 | stack[2026] * 0x1000000 | stack[2028] * 0x100 | stack[2029];
    if ((stack[2027] << 0x10 | stack[2026] * 0x1000000 | stack[2028] * 0x100 | stack[2029]) >= 0x10000) goto loc_2a13dce;
    
loc_2a13d64:
    r0 = CFDictionarySetValue(stack[2021], stack[2024], r11);
    r6 = r6 + r4;
    r1 = stack[2025] + 0x1;
    if (r1 < stack[2019]) goto loc_2a13c84;
    
loc_2a13d7a:
    r0 = stack[2018];
    *(r0 + 0x10) = stack[2021];
    goto loc_2a1385e;
    
loc_2a13dce:
    r2 = 0x129;
    r0 = "OCSExecutableCreate";
    r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/Executable/OCSExecutable.m";
    r3 = "codeBlock->stackSize < 65536 && \"stack size shuold not exceed 65536\"";
    r0 = __assert_rtn();
    return r0;
    
loc_2a13da8:
    r2 = 0x126;
    r0 = "OCSExecutableCreate";
    r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/Executable/OCSExecutable.m";
    r3 = "codeBlock->localVarCount < 256 && \"local var count shuold not exceed 256\"";
    r0 = __assert_rtn();
    return r0;
    
loc_2a13d82:
    r2 = 0x121;
    r0 = "OCSExecutableCreate";
    r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/Executable/OCSExecutable.m";
    r3 = "codeBlock->codeSize < 65536 && \"code block size shuold not exceed 65536\"";
    r0 = __assert_rtn();
    return r0;
    
loc_2a139e8:
    stack[2023] = *(r8 + 0x4);
    r1 = *(int8_t *)(r11 + 0x5) << 0x10;
    r1 = r1 | *(int8_t *)(r11 + 0x4) * 0x1000000;
    r1 = r1 | *(int8_t *)(r11 + 0x6) * 0x100;
    r1 = r1 | *(int8_t *)(r11 + 0x7);
    *(*(r8 + 0x4) + r4) = 0x2;
    r3 = r8;
    r8 = *(r8 + 0x4) + r4;
    *(r8 + 0x8) = r1;
    *(r8 + 0x4) = *(int8_t *)(r11 + 0x9) << 0x10 | *(int8_t *)(r11 + 0x8) * 0x1000000 | *(int8_t *)(r11 + 0xa) * 0x100 | *(int8_t *)(r11 + 0xb);
    r8 = r3;
    goto loc_2a13c1e;
    
loc_2a13c1e:
    r11 = r11 + 0xc;
    goto loc_2a13c22;
    
loc_2a13a46:
    r0 = *(int8_t *)(r11 + 0x5) << 0x10 | *(int8_t *)(r11 + 0x4) * 0x1000000;
    r0 = r0 | *(int8_t *)(r11 + 0x6) * 0x100;
    stack[2023] = *(r8 + 0x4);
    r0 = r0 | *(int8_t *)(r11 + 0x7);
    *(*(r8 + 0x4) + r4) = 0x3;
    *(0x4 + *(r8 + 0x4) + r4) = r0;
    goto loc_2a13a74;
    
loc_2a13a7a:
    stack[2037] = *(int8_t *)(r11 + 0x5) << 0x10 | *(int8_t *)(r11 + 0x4) * 0x1000000 | *(int8_t *)(r11 + 0x6) * 0x100 | *(int8_t *)(r11 + 0x7);
    stack[2036] = *(int8_t *)(r11 + 0x9) << 0x10 | *(int8_t *)(r11 + 0x8) * 0x1000000 | *(int8_t *)(r11 + 0xa) * 0x100 | *(int8_t *)(r11 + 0xb);
    stack[2023] = *(r8 + 0x4);
    *(*(r8 + 0x4) + r4) = 0x4;
    r0 = *(r8 + 0x4) + r4;
    r0 = r0 + 0x4;
    d16 = stack[2036];
    asm { vst1.8     d16, [r0] };
    goto loc_2a13c1e;
    
loc_2a13ad0:
    stack[2022] = *_kCFAllocatorSystemDefault;
    stack[2023] = *(r8 + 0x4);
    r1 = *(int8_t *)(r11 + 0x9) << 0x10;
    *(*(r8 + 0x4) + r4) = 0x5;
    r0 = r1 | *(int8_t *)(r11 + 0x8) * 0x1000000;
    r0 = r0 | *(int8_t *)(r11 + 0xa) * 0x100;
    r5 = *(r8 + 0x4) + r4;
    r1 = *(r8 + 0xc) + (r0 | *(int8_t *)(r11 + 0xb));
    *(r5 + 0xc) = r1;
    r0 = CFStringCreateWithCString(stack[2022], r1, 0x8000100);
    goto loc_2a13c1c;
    
loc_2a13c1c:
    *(r5 + 0x4) = r0;
    goto loc_2a13c1e;
    
loc_2a13b10:
    stack[2023] = *(r8 + 0x4);
    r1 = *(int8_t *)(r11 + 0x9) << 0x10;
    *(*(r8 + 0x4) + r4) = 0x6;
    r0 = r1 | *(int8_t *)(r11 + 0x8) * 0x1000000;
    r0 = r0 | *(int8_t *)(r11 + 0xa) * 0x100;
    r0 = r0 | *(int8_t *)(r11 + 0xb);
    r5 = *(r8 + 0x4) + r4;
    r0 = r0 + *(r8 + 0xc);
    *(r5 + 0xc) = r0;
    r0 = objc_getClass(r0);
    goto loc_2a13c1c;
    
loc_2a13b46:
    r9 = *(r8 + 0x4) + r4;
    *(*(r8 + 0x4) + r4) = 0x7;
    r0 = *(int8_t *)(r11 + 0x9) << 0x10;
    r0 = r0 | *(int8_t *)(r11 + 0x8) * 0x1000000;
    r0 = r0 | *(int8_t *)(r11 + 0xa) * 0x100;
    r0 = r0 | *(int8_t *)(r11 + 0xb);
    r0 = r0 + *(r8 + 0xc);
    *(r9 + 0xc) = r0;
    r0 = sel_registerName(r0);
    goto loc_2a13bb4;
    
loc_2a13bb4:
    stack[2023] = *(r8 + 0x4);
    *(0x4 + *(r8 + 0x4) + r4) = r0;
    goto loc_2a13c1e;
    
loc_2a13b7e:
    r9 = *(r8 + 0x4) + r4;
    *(*(r8 + 0x4) + r4) = 0x8;
    r0 = *(int8_t *)(r11 + 0x9) << 0x10;
    r0 = r0 | *(int8_t *)(r11 + 0x8) * 0x1000000;
    r0 = r0 | *(int8_t *)(r11 + 0xa) * 0x100;
    r0 = r0 | *(int8_t *)(r11 + 0xb);
    r0 = r0 + *(r8 + 0xc);
    *(r9 + 0xc) = r0;
    r0 = objc_getProtocol(r0);
    goto loc_2a13bb4;
    
loc_2a13bec:
    stack[2023] = *(r8 + 0x4);
    r1 = *(int8_t *)(r11 + 0x9) << 0x10;
    *(*(r8 + 0x4) + r4) = 0x9;
    r0 = r1 | *(int8_t *)(r11 + 0x8) * 0x1000000;
    r0 = r0 | *(int8_t *)(r11 + 0xa) * 0x100;
    r0 = r0 | *(int8_t *)(r11 + 0xb);
    r5 = *(r8 + 0x4) + r4;
    r0 = r0 + *(r8 + 0xc);
    *(r5 + 0xc) = r0;
    goto loc_2a13c1c;
    
loc_2a13bc0:
    r0 = [NSException raise:@"OCSCommonException" format:@"Invalid ConstPoolItem Tag while parsing data constTag:%d", r1, stack[2017], stack[2018], stack[2019], stack[2020], stack[2021], stack[2022], stack[2023], stack[2024], stack[2025], stack[2026], stack[2027], stack[2028]];
    r11 = r5;
    goto loc_2a13c22;
    
loc_2a13c3c:
    stack[2035] = r5;
    stack[2018] = r8;
    goto loc_2a13c42;
    
loc_2a13e3c:
    r2 = 0x95;
    r0 = "OCSExecutableCreate";
    r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/Executable/OCSExecutable.m";
    r3 = "exe->constPoolCount < 65536 && \"const pool count shuold not exceed 65536\"";
    r0 = __assert_rtn();
    return r0;
    
loc_2a13e18:
    r2 = 0x76;
    r0 = "OCSExecutableCreate";
    r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/Executable/OCSExecutable.m";
    r3 = "(kArchMagicNum == kOCSExecutableArchMagicNum) && \"OCSExecutable architecture not match,update OCScript File \"";
    r0 = __assert_rtn();
    return r0;
    
loc_2a13c38:
    r0 = 0x3;
    goto loc_2a13858;
    
loc_2a13856:
    r0 = 0x1;
    goto loc_2a13858;
    
loc_2a13df4:
    r2 = 0x50;
    r0 = "OCSExecutableCreate";
    r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/Executable/OCSExecutable.m";
    r3 = "data && \"Create OCSExecutable from nil NSData\"";
    r0 = __assert_rtn();
    return r0;
}
 */

// sub_2a13e60
void
_OCSCodeBlockReleaseCallBack() {}

/*
int sub_2a13e60() {
    stack[2045] = r4;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0xc) + 0x4;
    r4 = r1;
    if (r4 != 0x0) {
        r0 = free(*(r4 + 0x4));
        r0 = CFRelease(*(r4 + 0x18));
        r0 = loc_2dee7e8(r4);
    }
    else {
        r2 = 0x153;
        r0 = "_OCSCodeBlockReleaseCallBack";
        r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/Executable/OCSExecutable.m";
        r3 = "codeBlock && \"release a NULL OCSCodeBlock\"";
        r0 = __assert_rtn();
    }
    return r0;
}
 */
