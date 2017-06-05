//
//  OCSExecutableManager.m
//  OCS
//
//  Created by Xummer on 2017/5/8.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSVM_code.h"

void
_setUpExecutableManagerEnvironment();



// sub_2a0b75c
OCS_Executable*
_OCSGetExecutable(NSString *executableName, NSUInteger *errorCode) {
    NSCAssert(executableName, @"executableName && \"executableName is NULL\"");
    _setUpExecutableManagerEnvironment();
    
    __block OCS_Executable* exec;
    dispatch_sync(OCSExecutableManagerReadWriteQueue, ^{
        // sub_2a0b934
        exec = (OCS_Executable*)CFDictionaryGetValue(dictExecutables, (__bridge const void *)(executableName));
    });
    
    if (!exec) {
        dispatch_barrier_sync(OCSExecutableManagerReadWriteQueue, ^{
            // sub_2a0b966
            exec = (OCS_Executable*)CFDictionaryGetValue(dictExecutables, (__bridge const void *)(executableName));
            if (!exec) {
                // loc_2a0ba1c
                NSCAssert(_OCSExecutableManagerLoadDataCallback_fun, @"OCSExecutableManagerLoadDataCallback_fun && \"OCSExecutableManagerLoadDataCallback_fun is NULL\"");
                // loc_2a0b99e
                
                exec =
                _OCSExecutableCreate(executableName, ((NSData *(*)())_OCSExecutableManagerLoadDataCallback_fun)(executableName), errorCode);
                
                if (*errorCode) {
                    
                }
                else {
                    CFDictionarySetValue(dictExecutables, (__bridge const void *)(executableName), exec);
                    
                    dispatch_barrier_async(OCSExecutableManagerReadWriteQueue, ^{
                        // sub_2a0ba40
                        CFMutableArrayRef arr = (CFMutableArrayRef)CFDictionaryGetValue(dictClassNameTables, exec->clsName);
                        if (!arr) {
                            arr = CFArrayCreateMutable(kCFAllocatorDefault, 0, nil);
                            CFDictionaryAddValue(dictClassNameTables, exec->clsName, arr);
                        }
                        CFArrayAppendValue(arr, exec);
                    });
                }
            }
            else {
                // loc_2a0ba18
            }
        });
    }
    
    return exec;
}

/*
int sub_2a0b75c(int arg0, int arg1) {
    r1 = arg1;
    stack[2043] = r4;
    stack[2044] = r5;
    stack[2045] = r6;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0x14) + 0xc;
    stack[4611686018427389944] = r8;
    stack[4611686018427389945] = r10;
    stack[4611686018427389946] = r11;
    sp = sp - 0x74;
    r5 = arg0;
    if (r5 != 0x0) {
        if (*0x367d1ec == 0xffffffff) {
            stack[2019] = r1;
        }
        else {
            stack[2019] = r1;
            r0 = dispatch_once(0x367d1ec, 0x2f01ba0);
        }
        r6 = 0x367d1f4;
        r8 = __NSConcreteStackBlock;
        r0 = 0x14;
        stack[2035] = 0x0;
        stack[2036] = sp + 0x40;
        r1 = 0x2a0b935;
        stack[2037] = 0x20000000;
        r2 = 0x2f01bc0;
        asm { strd       r0, r4, [sp, #0x6c + var_20] };
        r11 = 0xc2000000;
        r0 = *r6;
        r3 = sp + 0x30;
        stack[2028] = r8;
        asm { strd       fp, r4, [sp, #0x6c + var_44] };
        asm { stm.w      r3, {r1, r2, sl} };
        stack[2034] = r5;
        r0 = dispatch_sync(r0, sp + 0x24);
        r6 = *(stack[2036] + 0x10);
        if (r6 == 0x0) {
            r1 = 0x2a0b967;
            r0 = *0x367d1f4;
            r2 = 0x4f63f4;
            asm { strd       r8, fp, [sp, #0x6c + var_68] };
            r2 = r2 + 0x2a0b80c;
            asm { strd       r4, r1, [sp, #0x6c + var_60] };
            asm { strd       r2, sl, [sp, #0x6c + var_58] };
            stack[2026] = r5;
            stack[2027] = stack[2019];
            r0 = dispatch_barrier_sync(r0, sp + 0x4);
            r6 = *(stack[2036] + 0x10);
        }
        r0 = sp + 0x40;
        r1 = 0x8;
        r0 = _Block_object_dispose();
        r0 = r6;
        sp = sp + 0x54;
    }
    else {
        r2 = 0x1f;
        r0 = "OCSGetExecutable";
        r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/Executable/OCSExecutableManager.m";
        r3 = "executableName && \"executableName is NULL\"";
        r0 = __assert_rtn();
    }
    return r0;
}
 */

void
_OCSGetClassProtocolExtend(NSString *relativePath, NSString *executableName, NSMutableDictionary *dictCls, NSMutableDictionary *dictProtocol) {
    NSCAssert(executableName, @"executableName && \"executableName is NULL\"");
    
    NSString *path = [relativePath stringByAppendingPathComponent:executableName];
    
#if __LP64__
    NSString *fullPath = [path stringByAppendingPathExtension:@"64.ocs"];
#else
    NSString *fullPath = [path stringByAppendingPathExtension:@"32.ocs"];
#endif
    
    _setUpExecutableManagerEnvironment();
    
    __block NSData *data = nil;
    
    dispatch_barrier_sync(OCSExecutableManagerReadWriteQueue, ^{
        NSCAssert(_OCSExecutableManagerLoadDataCallback_fun, @"OCSExecutableManagerLoadDataCallback_fun && \"OCSExecutableManagerLoadDataCallback_fun is NULL\"");
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
            data = [NSData dataWithContentsOfFile:fullPath];
        }
    });
    
    OCSLog(@"GetClassProtocolExtend:fileName(%s)", [executableName UTF8String]);
    
    _OCSExtendClassProtocolSegment(data, dictCls, dictProtocol);
}

void
_setUpExecutableManagerEnvironment() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // sub_2a0b874
        dictExecutables = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, 0);
        OCSExecutableManagerReadWriteQueue =
        dispatch_queue_create("ocscript.executable-manager.read-write-qeueu", DISPATCH_QUEUE_CONCURRENT);
        dictClassNameTables = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, 0);
        exeClassNameTablesQueue = dispatch_queue_create("ocscript.executable-manager.exeClassNameTablesQueue", DISPATCH_QUEUE_CONCURRENT);
        codeBlockCache = [NSMutableDictionary new];
        classMethodBlockQueue = dispatch_queue_create("ocscript.ClassMethodBlockQueue-Queue", DISPATCH_QUEUE_CONCURRENT);
    });
}

// ??
// sub_2a0bac0
OCS_CodeBlock *
_OCSGetCodeBlock(NSString *clsName, NSString *codeBlockName) {
    NSString *keyStr = [NSString stringWithFormat:@"%@_%@", clsName, codeBlockName];
    NSCAssert(clsName.length > 0 && codeBlockName.length > 0 && keyStr.length > 0, @"keyStr.length > 0 && \"OCSGetCodeBlock className codeBlockName is nil\"");
    
    __block OCS_CodeBlock *codeBlock = [[codeBlockCache objectForKey:keyStr] pointerValue];
    
    if (!codeBlock) {
        dispatch_sync(exeClassNameTablesQueue, ^{
            // sub_2a0bc50
            Class cls = NSClassFromString(clsName);
            if (cls) {
                // loc_2a0bc68:
                // loc_2a0bca0
                while (![cls isEqual:[NSObject class]]) {
                    // loc_2a0bcc2:
                    CFArrayRef arr = CFDictionaryGetValue(dictClassNameTables, (__bridge const void *)(NSStringFromClass(cls)));
                    
                    if (arr) {
                        // loc_2a0bcec:
                        CFIndex c = CFArrayGetCount(arr);
                        if (c > 0) {
                            // loc_2a0bcf6
                            // loc_2a0bcfa
                            OCS_Executable* exec;
                            CFIndex i;
                            for (i = 0; i < c; i++) {
                                exec = (OCS_Executable *)CFArrayGetValueAtIndex(arr, i);
                                if (exec) {
                                    // loc_2a0bd04
                                    codeBlock = (OCS_CodeBlock *)CFDictionaryGetValue(exec->dictCodes,(__bridge const void *)(keyStr));
                                    [codeBlockCache setObject:[NSValue valueWithPointer:codeBlock] forKey:keyStr];
                                    return;
                                }
                            }
                        }
                        
                    }
                    cls = class_getSuperclass(cls);
                }
            }
        });
    }
    
    NSCAssert(codeBlock, @"codeBlock && \"codeBlock is NULL\"");
    
    return codeBlock;
}

/*
int sub_2a0bac0(int arg0, int arg1) {
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
    r4 = sp - 0x60;
    asm { bfc        r4, #0x0, #0x4 };
    sp = r4;
    asm { vst1.64    {d8, d9, d10, d11}, [r4, #0x80]! };
    asm { vst1.64    {d12, d13, d14, d15}, [r4, #0x80] };
    sp = sp - 0x70;
    r3 = r0;
    r0 = [NSString stringWithFormat:@"%@_%@", r3, r1];
    stack[2022] = 0x0;
    stack[2023] = sp + 0x28;
    stack[2024] = 0x20000000;
    stack[2025] = 0x14;
    stack[2026] = [[*0x367d200 objectForKey:r0, r3] pointerValue];
    r4 = *(stack[2023] + 0x10);
    stack[2033] = ___objc_personality_v0;
    stack[2034] = 0x2e4fee4;
    stack[2035] = r7;
    stack[2037] = sp;
    stack[2036] = 0x2a0bc25;
    r0 = sp + 0x3c;
    r0 = _Unwind_SjLj_Register();
    if (r4 == 0x0) {
        r0 = *0x367d1fc;
        r3 = 0x4f6060;
        stack[2013] = __NSConcreteStackBlock;
        r1 = 0xc2000000;
        r2 = 0x2a0bc51;
        asm { strd       r1, fp, [sp, #0x88 + var_80] };
        r3 = r3 + 0x2a0bbc0;
        r1 = sp + 0x10;
        asm { strd       r5, r8, [sp, #0x88 + var_68] };
        asm { stm.w      r1, {r2, r3, r6, sl} };
        r0 = dispatch_sync(r0, sp + 0x4);
        r4 = *(stack[2023] + 0x10);
        if (r4 != 0x0) {
            r0 = sp + 0x28;
            r1 = 0x8;
            r0 = _Block_object_dispose();
            r0 = sp + 0x3c;
            r0 = _Unwind_SjLj_Unregister();
            r0 = r4;
            r4 = sp + 0x70;
            asm { vld1.64    {d8, d9, d10, d11}, [r4, #0x80]! };
            asm { vld1.64    {d12, d13, d14, d15}, [r4, #0x80] };
            sp = r7 - 0x18;
        }
        else {
            r0 = "OCSGetCodeBlock";
            r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/Executable/OCSExecutableManager.m";
            r3 = "codeBlock && \"codeBlock is NULL\"";
            stack[2028] = 0x1;
            r2 = 0x7d;
            r0 = __assert_rtn();
        }
    }
    else {
        r0 = sp + 0x28;
        r1 = 0x8;
        r0 = _Block_object_dispose();
        r0 = sp + 0x3c;
        r0 = _Unwind_SjLj_Unregister();
        r0 = r4;
        r4 = sp + 0x70;
        asm { vld1.64    {d8, d9, d10, d11}, [r4, #0x80]! };
        asm { vld1.64    {d12, d13, d14, d15}, [r4, #0x80] };
        sp = r7 - 0x18;
    }
    return r0;
}
 */
