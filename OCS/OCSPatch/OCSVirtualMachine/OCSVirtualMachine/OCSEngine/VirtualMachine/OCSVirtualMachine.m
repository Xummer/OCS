//
//  OCSVirtualMachine.m
//  OCS
//
//  Created by Xummer on 2017/5/8.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <objc/objc.h>

// sub_2a0bda8
void OCSStackBlockCreate() {
    
}

/*
int sub_2a0bda8(int arg0, int arg1, int arg2) {
    stack[2043] = r4;
    stack[2044] = r5;
    stack[2045] = r6;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0x14) + 0xc;
    r4 = arg2;
    r5 = arg1;
    r6 = arg0;
    if (r4 != 0x0) {
        r0 = malloc(0xc + (r4 + r4 * 0x2) * 0x4);
        *r0 = r6;
        *(r0 + 0x4) = r5;
        *(r0 + 0x8) = r4;
    }
    else {
        r2 = 0x7c;
        r0 = "OCSStackBlockCreate";
        r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/VirtualMachine/OCSVirtualMachine.m";
        r3 = "size >= 1";
        r0 = __assert_rtn();
    }
    return r0;
}
 */

// sub_2a0bdee
void * sub_2a0bdee() {}

/*
int sub_2a0bdee() {
    stack[2044] = r4;
    stack[2045] = r5;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0x10) + 0x8;
    r4 = malloc(0x20);
    *(r4 + 0x14) = 0x0;
    r0 = malloc(0x39c);
    *r0 = 0x0;
    *(r0 + 0x4) = 0x0;
    *(r4 + 0xc) = r0;
    *(r4 + 0x8) = r0;
    *(r0 + 0x8) = 0x4c;
    *(r4 + 0x10) = 0x4c;
    *(r4 + 0x4) = r0 + 0xc;
    r0 = r4;
    *r4 = 0x0;
    *(r4 + 0x18) = 0x0;
    *(r4 + 0x1c) = 0x0;
    return r0;
}
 */

// sub_2a0be22
void OCSVirtualMachineDestroy(id vm) {
    if (vm) {
        NSLog(@"vm->currentFrame == NULL && \"Destroy a VirtualMachine with Frame Still Active.\"");
    }
    else {
        NSLog(@"vm && \"Destroy NULL OCSVirtualMachine\"");
    }
}

/*
int sub_2a0be22(int arg0) {
    stack[2044] = r4;
    stack[2045] = r5;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0x10) + 0x8;
    r4 = arg0;
    if (r4 != 0x0) {
        if (*r4 == 0x0) {
            r0 = *(r4 + 0x1c);
            if (r0 != 0x0) {
                r0 = CFRelease(r0);
                *(r4 + 0x1c) = 0x0;
            }
            r0 = *(r4 + 0xc);
            if (r0 != 0x0) {
                do {
                    r5 = *(r0 + 0x4);
                    r0 = free(r0);
                    r0 = r5;
                } while (r5 != 0x0);
            }
            r0 = loc_2dee7e8(r4);
        }
        else {
            r2 = 0xa6;
            r0 = "OCSVirtualMachineDestroy";
            r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/VirtualMachine/OCSVirtualMachine.m";
            r3 = "vm->currentFrame == NULL && \"Destroy a VirtualMachine with Frame Still Active.\"";
            r0 = __assert_rtn();
        }
    }
    else {
        r2 = 0xa5;
        r0 = "OCSVirtualMachineDestroy";
        r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/VirtualMachine/OCSVirtualMachine.m";
        r3 = "vm && \"Destroy NULL OCSVirtualMachine\"";
        r0 = __assert_rtn();
    }
    return r0;
}
 */

// sub_2a0c01c
void OCSVirtualMachineExecuteWithArr(void *content, void *codeBlock, int arg2, CFMutableArrayRef argList, int arg4) {
    if (r5) {
        // loc_2a0c07a
        if (codeBlock) {
            
        }
        else {
            // loc_2a0c368
            NSLog(@"codeBlock && \"Execute NULL OCSCodeBlock\"");
        }
    }
    else {
        // loc_2a0c33e
        NSLog(@"vm && \"Execute on NULL OCSVirtualMachine\"");
    }
}

/*
int sub_2a0c01c(int arg0, int arg1, int arg2, int arg3, int arg4) {
    stack[2048] = arg4;
    r3 = arg3;
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
    r4 = sp - 0x60;
    asm { bfc        r4, #0x0, #0x4 };
    sp = r4;
    asm { vst1.64    {d8, d9, d10, d11}, [r4, #0x80]! };
    asm { vst1.64    {d12, d13, d14, d15}, [r4, #0x80] };
    sp = sp - 0x80;
    r10 = r2;
    r2 = arg4;
    r4 = r1;
    r1 = 0x4501a0;
    r8 = r3;
    asm { strd       r0, r2, [sp, #0x98 + var_64] };
    stack[2033] = *(r1 + 0x2a0c050);
    stack[2034] = 0x2e4feec;
    stack[2035] = r7;
    stack[2037] = sp;
    stack[2036] = 0x2a0c39d;
    r0 = sp + 0x4c;
    r0 = _Unwind_SjLj_Register();
    if (stack[2021] == 0x0) goto loc_2a0c33e;
    
loc_2a0c07a:
    if (r4 == 0x0) goto loc_2a0c368;
    
loc_2a0c080:
    if (*(stack[2021] + 0x14) != 0x1) goto loc_2a0c0a6;
    
loc_2a0c088:
    r0 = printf("[OCS ERROR]");
    r0 = printf("OCSVirtualMachine is already running.");
    r0 = sp + 0x4c;
    r0 = _Unwind_SjLj_Unregister();
    r4 = sp + 0x80;
    asm { vld1.64    {d8, d9, d10, d11}, [r4, #0x80]! };
    asm { vld1.64    {d12, d13, d14, d15}, [r4, #0x80] };
    sp = r7 - 0x18;
    return r0;
    
loc_2a0c0a6:
    stack[2023] = *(stack[2021] + 0x8);
    stack[2024] = *(stack[2021] + 0x4);
    r2 = stack[2024];
    r3 = (SAR(0xc + stack[2023] + (*(stack[2023] + 0x8) + *(stack[2023] + 0x8) * 0x2) * 0x4 - r2, 0x2)) * 0xaaaaaaab;
    r0 = stack[2023];
    r1 = *(r4 + 0x10) + *(r4 + 0x14);
    if (r3 >= r1) goto loc_2a0c126;
    
loc_2a0c0e0:
    r0 = *(r0 + 0x4);
    if (r0 == 0x0) goto loc_2a0c0ec;
    
loc_2a0c0e4:
    if (*(r0 + 0x8) < r1) goto loc_2a0c0e0;
    
loc_2a0c11a:
    r2 = r0 + 0xc;
    *(stack[2021] + 0x8) = r0;
    *(stack[2021] + 0x4) = r2;
    goto loc_2a0c126;
    
loc_2a0c126:
    r5 = stack[2021];
    stack[2014] = *stack[2021];
    r1 = 0x0;
    stack[2015] = r2;
    r2 = sp + 0x20;
    r0 = *_kCFAllocatorSystemDefault;
    asm { stm.w      r2, {r1, r4, sl} };
    stack[2019] = r8;
    stack[2028] = 0xffffffff;
    stack[2020] = CFArrayCreateMutable(r0, 0x0, 0x0);
    *r5 = sp + 0x18;
    stack[2025] = *(stack[2021] + 0x14);
    *(stack[2021] + 0x14) = 0x1;
    *(stack[2021] + 0x4) = *(stack[2021] + 0x4) + (*(r4 + 0x10) + *(r4 + 0x10) * 0x2) * 0x4;
    stack[2028] = 0x1;
    r0 = sub_2a0e360(stack[2021]);
    stack[2027] = 0x0;
    r4 = *(stack[2021] + 0x4);
    r6 = sign_extend_32(*(int8_t *)stack[2022]);
    if (r6 > 0x5d) goto loc_2a0c1b0;
    
loc_2a0c194:
    if (r6 > 0x48) goto loc_2a0c1e2;
    
loc_2a0c198:
    r0 = r6 - 0x3a;
    if (r0 > 0x9) goto loc_2a0c244;
    
loc_2a0c1a2:
    goto *0x2a0c1a6[r0];
    
loc_2a0c24c:
    r0 = malloc(0x4);
    *(stack[2022] + 0x4) = r0;
    *r0 = *(r4 + 0xfffffffffffffff8);
    goto loc_2a0c2ce;
    
loc_2a0c2ce:
    stack[2028] = 0xf;
    r0 = CFArrayGetCount(stack[2020]);
    stack[2028] = 0x10;
    stack[2008] = 0x0;
    r0 = CFArrayApplyFunction(stack[2020], 0x0, r0, 0x2a11119);
    stack[2028] = 0x11;
    r0 = CFRelease(stack[2020]);
    *(stack[2021] + 0x14) = stack[2025];
    *(stack[2021] + 0x4) = stack[2024];
    *(stack[2021] + 0x8) = stack[2023];
    *stack[2021] = **stack[2021];
    if (0x0 != 0x1) {
        r0 = sp + 0x4c;
        r0 = _Unwind_SjLj_Unregister();
        r4 = sp + 0x80;
        asm { vld1.64    {d8, d9, d10, d11}, [r4, #0x80]! };
        asm { vld1.64    {d12, d13, d14, d15}, [r4, #0x80] };
        sp = r7 - 0x18;
    }
    else {
        stack[2028] = 0x12;
        r0 = objc_exception_rethrow();
    }
    return r0;
    
loc_2a0c290:
    stack[2028] = 0xe;
    r0 = [NSException raise:@"OCSCommonException" format:@"vm returnValue type not define:%c", r6, stack[2009], stack[2010], stack[2011], stack[2012], stack[2013], stack[2014], stack[2015], stack[2016], stack[2017], stack[2018], stack[2019], stack[2020], stack[2021], stack[2022], stack[2023], stack[2024]];
    goto loc_2a0c2ce;
    
loc_2a0c1d0:
    r0 = malloc(0x1);
    *(stack[2022] + 0x4) = r0;
    *r0 = *(int8_t *)(r4 + 0xfffffffffffffff8);
    goto loc_2a0c2ce;
    
loc_2a0c244:
    if (r6 != 0x23) {
        asm { cmpne      r6, #0x2a };
    }
    if (!CPU_FLAGS & NE) {
        r0 = malloc(0x4);
        *(stack[2022] + 0x4) = r0;
        *r0 = *(r4 + 0xfffffffffffffff8);
    }
    else {
        stack[2028] = 0xe;
        r0 = [NSException raise:@"OCSCommonException" format:@"vm returnValue type not define:%c", r6, stack[2009], stack[2010], stack[2011], stack[2012], stack[2013], stack[2014], stack[2015], stack[2016], stack[2017], stack[2018], stack[2019], stack[2020], stack[2021], stack[2022], stack[2023], stack[2024]];
    }
    goto loc_2a0c2ce;
    
loc_2a0c1e2:
    if (r6 <= 0x50) {
        if (r6 != 0x49) {
            asm { cmpne      r6, #0x4c };
        }
        if (!CPU_FLAGS & E) {
            stack[2028] = 0xe;
            r0 = [NSException raise:@"OCSCommonException" format:@"vm returnValue type not define:%c", r6, stack[2009], stack[2010], stack[2011], stack[2012], stack[2013], stack[2014], stack[2015], stack[2016], stack[2017], stack[2018], stack[2019], stack[2020], stack[2021], stack[2022], stack[2023], stack[2024]];
        }
        else {
            r0 = malloc(0x4);
            *(stack[2022] + 0x4) = r0;
            *r0 = *(r4 + 0xfffffffffffffff8);
        }
    }
    else {
        if (r6 != 0x51) {
            if (r6 == 0x53) {
                r0 = malloc(0x2);
                *(stack[2022] + 0x4) = r0;
                *r0 = *(int16_t *)(r4 + 0xfffffffffffffff8);
            }
            else {
                stack[2028] = 0xe;
                r0 = [NSException raise:@"OCSCommonException" format:@"vm returnValue type not define:%c", r6, stack[2009], stack[2010], stack[2011], stack[2012], stack[2013], stack[2014], stack[2015], stack[2016], stack[2017], stack[2018], stack[2019], stack[2020], stack[2021], stack[2022], stack[2023], stack[2024]];
            }
        }
        else {
            r0 = malloc(0x8);
            *(stack[2022] + 0x4) = r0;
            *(r0 + 0x4) = *(r4 + 0xfffffffffffffffc);
            *r0 = *(r4 + 0xfffffffffffffff8);
        }
    }
    goto loc_2a0c2ce;
    
loc_2a0c1b0:
    r0 = r6 - 0x63;
    if (r0 > 0x13) goto loc_2a0c1f0;
    
loc_2a0c1b8:
    goto *0x2a0c1bc[r0];
    
loc_2a0c278:
    r0 = malloc(0x8);
    *(stack[2022] + 0x4) = r0;
    *(r0 + 0x4) = *(r4 + 0xfffffffffffffffc);
    *r0 = *(r4 + 0xfffffffffffffff8);
    goto loc_2a0c2ce;
    
loc_2a0c266:
    r0 = malloc(0x2);
    *(stack[2022] + 0x4) = r0;
    *r0 = *(int16_t *)(r4 + 0xfffffffffffffff8);
    goto loc_2a0c2ce;
    
loc_2a0c2c8:
    *(stack[2022] + 0x4) = 0x0;
    goto loc_2a0c2ce;
    
loc_2a0c1f0:
    if (r6 != 0x5e) {
        if (r6 == 0x7b) {
            stack[2028] = 0xc;
            stack[2012] = malloc([*(**(r4 + 0xfffffffffffffff8) + 0x4) totalSize]);
            stack[2028] = 0xd;
            r0 = [*(**(r4 + 0xfffffffffffffff8) + 0x4) totalSize];
            r0 = memcpy(stack[2012], *(*(r4 + 0xfffffffffffffff8) + 0x8), r0);
            *(stack[2022] + 0x4) = stack[2012];
        }
        else {
            stack[2028] = 0xe;
            r0 = [NSException raise:@"OCSCommonException" format:@"vm returnValue type not define:%c", r6, stack[2009], stack[2010], stack[2011], stack[2012], stack[2013], stack[2014], stack[2015], stack[2016], stack[2017], stack[2018], stack[2019], stack[2020], stack[2021], stack[2022], stack[2023], stack[2024]];
        }
    }
    else {
        r0 = malloc(0x4);
        *(stack[2022] + 0x4) = r0;
        *r0 = *(r4 + 0xfffffffffffffff8);
    }
    goto loc_2a0c2ce;
    
loc_2a0c0ec:
    r5 = *(stack[2021] + 0x10);
    r0 = stack[2023];
    do {
        r6 = r0;
        r0 = *(r6 + 0x4);
    } while (r0 != 0x0);
    stack[2028] = 0xffffffff;
    if (r1 > r5) {
        asm { movhi      r5, r1 };
    }
    r0 = sub_2a0bda8(r6, 0x0, r5);
    *(r6 + 0x4) = r0;
    *(stack[2021] + 0x10) = *(stack[2021] + 0x10) + r5;
    goto loc_2a0c11a;
    
loc_2a0c368:
    r0 = "OCSVirtualMachineExecuteWithArr";
    r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/VirtualMachine/OCSVirtualMachine.m";
    r3 = "codeBlock && \"Execute NULL OCSCodeBlock\"";
    stack[2028] = 0xffffffff;
    r2 = 0xef;
    r0 = __assert_rtn();
    return r0;
    
loc_2a0c33e:
    r0 = "OCSVirtualMachineExecuteWithArr";
    r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/VirtualMachine/OCSVirtualMachine.m";
    r3 = "vm && \"Execute on NULL OCSVirtualMachine\"";
    stack[2028] = 0xffffffff;
    r2 = 0xee;
    r0 = __assert_rtn();
    return r0;
}
 */

// sub_2a0be9c
void OCSVirtualMachineAttachThread(void *contnet, pthread_t thread) {}

/*
void sub_2a0be9c(int arg0, int arg1) {
    r1 = arg1;
    r0 = arg0;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = sp - 0x8;
    if (r0 != 0x0) {
        if (r1 != 0x0) {
            *(r0 + 0x18) = r1;
        }
        else {
            r2 = 0xb9;
            r0 = "OCSVirtualMachineAttachThread";
            r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/VirtualMachine/OCSVirtualMachine.m";
            r3 = "thread && \"Attach NULL thread on OCSVirtualMachine\"";
            r0 = __assert_rtn();
        }
    }
    else {
        r2 = 0xb8;
        r0 = "OCSVirtualMachineAttachThread";
        r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/VirtualMachine/OCSVirtualMachine.m";
        r3 = "vm && \"Attach thread on NULL OCSVirtualMachine.\"";
        r0 = __assert_rtn();
    }
    return;
}
 */

// sub_2a0e360
void _virtualMachineEval(id arg) {
    if (arg) {
        
    }
    else {
        NSLog(@"vm && \"Eval on NULL OCSVirtualMachine\"");
    }
}

/*
int sub_2a0e360(int arg0) {
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
    r4 = sp - 0x1b0;
    asm { bfc        r4, #0x0, #0x3 };
    sp = r4;
    r5 = r0;
    stack[2039] = *___stack_chk_guard;
    if (r5 != 0x0) {
        stack[1951] = @selector(integerValue);
        stack[1974] = @selector(UTF8String);
        stack[1963] = @selector(methodReturnType);
        stack[1964] = @selector(methodSignatureForSelector:);
        stack[1971] = @selector(autorelease);
        stack[1970] = @selector(release);
        stack[1969] = @selector(retain);
        stack[1968] = @selector(new);
        stack[1967] = @selector(init);
        stack[1972] = @selector(alloc);
        stack[1958] = @selector(numberWithDouble:);
        stack[1957] = @selector(numberWithFloat:);
        stack[1950] = @selector(numberWithUnsignedLongLong:);
        stack[1956] = @selector(numberWithLongLong:);
        stack[1961] = @selector(numberWithUnsignedLong:);
        stack[1955] = @selector(numberWithLong:);
        stack[1954] = @selector(numberWithInteger:);
        stack[1962] = @selector(numberWithUnsignedShort:);
        stack[1953] = @selector(numberWithShort:);
        stack[1960] = @selector(numberWithUnsignedChar:);
        stack[1952] = @selector(numberWithChar:);
        stack[1959] = @selector(numberWithBool:);
        stack[1966] = @selector(dictionaryWithObjects:forKeys:count:);
        stack[1965] = @selector(arrayWithObjects:count:);
        stack[1973] = @selector(totalSize);
        r0 = @selector(raise:format:);
        stack[1975] = r0;
        r11 = *r5;
        r10 = *(r11 + 0xc);
        do {
            r1 = *(int8_t *)(*(r10 + 0x4) + *(r11 + 0x8));
            if (r1 <= 0xef) {
                break;
            }
            stack[1940] = r1;
            r2 = @"OCSCommonException";
            r3 = @"Invalid Opcode %d";
            r0 = objc_msgSend(@class(NSException), stack[1975]);
        } while (true);
        asm { addw       r0, pc, #0x8 };
        r0 = (r0 + r1 * 0x4)(r0 + r1 * 0x4);
    }
    else {
        r2 = 0x1c4;
        r0 = "_virtualMachineEval";
        r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/VirtualMachine/OCSVirtualMachine.m";
        r3 = "vm && \"Eval on NULL OCSVirtualMachine\"";
        r0 = __assert_rtn();
    }
    return r0;
}
*/

// sub_2a1111e
void _virtualMachineRegisterCStruct(id vm) {
    if (vm) {
        
    }
    else {
        NSLog(@"vm && \"Register CStruct on NULL OCSVirtualMachine\"");
    }
}

/*
int sub_2a1111e(int arg0) {
    r0 = arg0;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = sp - 0x8;
    if (r0 != 0x0) {
        r0 = *r0;
        if (r0 != 0x0) {
            r0 = loc_2def484(*(r0 + 0x18));
        }
        else {
            r2 = 0x1b6;
            r0 = "_virtualMachineRegisterCStruct";
            r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/VirtualMachine/OCSVirtualMachine.m";
            r3 = "vm->currentFrame && \"OCSVirtualMachine Frame is NULL\"";
            r0 = __assert_rtn();
        }
    }
    else {
        r2 = 0x1b5;
        r0 = "_virtualMachineRegisterCStruct";
        r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/VirtualMachine/OCSVirtualMachine.m";
        r3 = "vm && \"Register CStruct on NULL OCSVirtualMachine\"";
        r0 = __assert_rtn();
    }
    return r0;
}
*/

// sub_2a13770
void sub_2a13770(NSString *className, NSString *arg1, int arg2, CFMutableArrayRef argList) {
    const void *codeBlock = OCSGetCodeBlock(className, arg1);
    void *content = sub_2a1514a();
    OCSVirtualMachineExecuteWithArr(content, codeBlock, arg2, argList, ??);
}

/*
void sub_2a13770(int arg0, int arg1, int arg2, int arg3) {
    stack[2043] = r4;
    stack[2044] = r5;
    stack[2045] = r6;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0x14) + 0xc;
    r6 = sub_2a0bac0(arg0, arg1);
    r0 = sub_2a1514a();
    r0 = sub_2a0c01c(r0, r6, arg2, arg3, stack[2048]);
    return;
}
*/
