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

// sub_2a123ba
void
OCSSetUpNativeCFunc() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // sub_2a123e6
        sub_2a1344e();
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
OCSSetUpStructType() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // sub_2a12b34
        structTypeDictReadWriteQueue = dispatch_queue_create("ocscript.OCSEngine.structTypeDict.read-write-qeueu", DISPATCH_QUEUE_CONCURRENT);
        dictStructType = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, 0);
    });
}

// sub_2a12b8e
void
OCSGetStructType() {}

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

// sub_2a12e24
void OCSCreateCopyStruct() {}

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

// sub_2a1264e
//CGRect
//QPCGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
//    return CGRectMake(x, y, width, height);
//}

// sub_2a1344e
void
sub_2a1344e() {
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
OCSSetUpCFuncEnvironment() {
    OCSSetUpStructType();
    OCSSetUpNativeCFunc();
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


// sub_2a13fb4
NSData *
OCSGetExecutableData(NSString *fileName) {
    dispatch_sync(classExecutableRootReadWriteQueue, ^{
        // sub_2a14b20
        [dict3 objectForKey:];
    });
    
    NSString *path = [*(stack[2021] + 0x18) stringByAppendingPathComponent:fileName];
    
#if TARGET_IPHONE_SIMULATOR
    // DONOTHING
#else
    
#if __LP64__
    NSString *fullPath = [path stringByAppendingPathExtension:@"64.ocs"];
#else
    NSString *fullPath = [path stringByAppendingPathExtension:@"32.ocs"];
#endif
    
#endif // TARGET_IPHONE_SIMULATOR
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        [NSException raise:@"OCSERROR" format:@"executable not find! path:%@", fullPath];
    }
    
    return [NSData dataWithContentsOfFile:fullPath];
}

/*
int sub_2a14b20(int arg0) {
    stack[2045] = r4;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0xc) + 0x4;
    r0 = [*0x367d234 objectForKey:*(arg0 + 0x18)];
    *(*(*(arg0 + 0x14) + 0x4) + 0x18) = r0;
    return r0;
}
 */

/*
int sub_2a13fb4(int arg0) {
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
    r4 = sp - 0x60;
    asm { bfc        r4, #0x0, #0x4 };
    sp = r4;
    asm { vst1.64    {d8, d9, d10, d11}, [r4, #0x80]! };
    asm { vst1.64    {d12, d13, d14, d15}, [r4, #0x80] };
    sp = sp - 0x80;
    r4 = r0;
    r5 = 0x0;
    stack[2020] = r5;
    stack[2021] = sp + 0x30;
    r2 = 0x367d230;
    stack[2022] = 0x52000000;
    r1 = 0x2a14b0f;
    r6 = __NSConcreteStackBlock;
    stack[2023] = 0x1c;
    r9 = 0x2a14b21;
    r0 = 0x2a14b19;
    r12 = 0x2f01e10;
    asm { strd       r1, r0, [sp, #0x98 + var_58] };
    r1 = 0xc2000000;
    r0 = *r2;
    r2 = sp + 0x18;
    stack[2026] = r5;
    stack[2013] = r6;
    asm { stm.w      r2, {r1, r5, sb, ip} };
    r1 = sp + 0x14;
    asm { strd       r3, r4, [sp, #0x98 + var_70] };
    r0 = dispatch_sync(r0, r1);
    stack[2033] = ___objc_personality_v0;
    stack[2034] = 0x2e4ff24;
    stack[2035] = r7;
    stack[2037] = sp;
    stack[2036] = 0x2a14167;
    stack[2028] = 0x1;
    r0 = sp + 0x4c;
    r0 = _Unwind_SjLj_Register();
    r0 = [*(stack[2021] + 0x18) stringByAppendingPathComponent:r4];
    stack[2028] = 0x2;
    stack[2012] = [r0 stringByAppendingPathExtension:@"32.ocs"];
    stack[2028] = 0x3;
    r0 = [NSFileManager defaultManager];
    stack[2028] = 0x4;
    if (([r0 fileExistsAtPath:stack[2012]] & 0xff) == 0x0) {
        stack[2028] = 0x5;
        r0 = [NSException raise:@"OCSERROR" format:@"executable not find! path:%@", stack[2012], stack[2009], stack[2010], stack[2011], stack[2012], stack[2013], stack[2014], stack[2015], stack[2016], stack[2017], stack[2018], stack[2019], stack[2020], stack[2021], stack[2022], stack[2023], stack[2024]];
    }
    stack[2028] = 0x6;
    r4 = [NSData dataWithContentsOfFile:stack[2012]];
    r0 = sp + 0x30;
    r1 = 0x8;
    r0 = _Block_object_dispose();
    r0 = sp + 0x4c;
    r0 = _Unwind_SjLj_Unregister();
    r0 = r4;
    r4 = sp + 0x80;
    asm { vld1.64    {d8, d9, d10, d11}, [r4, #0x80]! };
    asm { vld1.64    {d12, d13, d14, d15}, [r4, #0x80] };
    sp = r7 - 0x18;
    return r0;
}
 */
