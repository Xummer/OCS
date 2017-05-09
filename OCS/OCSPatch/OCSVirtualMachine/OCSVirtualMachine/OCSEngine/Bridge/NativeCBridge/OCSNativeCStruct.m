//
//  OCSNativeCStruct.m
//  OCS
//
//  Created by Xummer on 2017/5/8.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import <Foundation/Foundation.h>

// sub_2a12b8e
void OCSGetStructType() {}

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

