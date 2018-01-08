//
//  OCSVirtualMachine.m
//  OCS
//
//  Created by Xummer on 2017/5/8.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSVM_code.h"
#import "OCSStructTypeParser.h"
#import "ffi.h"

#define STACK_CELL_SIZE     12 // 64 bit 2^4 = 16

// sub_2a0bda8
OCS_StackBlock *
OCSStackBlockCreate(OCS_StackBlock* prev, OCS_StackBlock* next, int32_t size) {
    NSCAssert(size >= 1, @"size >= 1");
    
    OCS_StackBlock *stackBlock = malloc(offsetof(OCS_StackBlock, stack) + size * STACK_CELL_SIZE);
    stackBlock->prev = prev;
    stackBlock->next = next;
    stackBlock->allocSize = size;
    
    return stackBlock;
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
OCS_VirtualMachine *
OCSVirtualMachineCreate() {
    OCS_VirtualMachine *vm = malloc(sizeof(OCS_VirtualMachine));
    vm->state = 0;
    
    OCS_StackBlock *stack = malloc(sizeof(OCS_StackBlock));
    stack->next = NULL;
    stack->prev = NULL;
    vm->stackBlock = stack;
    vm->_0xc = stack;
    stack->allocSize = 0x4c;
    vm->stackSize = 0x4c;
    vm->stackPointer = &stack->stack;
    
    vm->currentFrame = NULL;
    vm->thread = NULL;
    vm->exptionCallStackInfo = NULL;
    return vm;
}

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
void
OCSVirtualMachineDestroy(OCS_VirtualMachine* vm) {
    NSCAssert(vm, @"vm && \"Destroy NULL OCSVirtualMachine\"");
    NSCAssert(vm->currentFrame == NULL, @"vm->currentFrame == NULL && \"Destroy a VirtualMachine with Frame Still Active.\"");
    if (vm->exptionCallStackInfo) {
        CFRelease(vm->exptionCallStackInfo);
        vm->exptionCallStackInfo = NULL;
    }
    
    OCS_StackBlock *pos;
    for (pos = vm->_0xc; pos->next != NULL;) {
        OCS_StackBlock *sb = pos;
        pos = pos->next;
        free(sb);
    }
    
    free(vm);
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

// sub_2a0be9c
void
OCSVirtualMachineAttachThread(OCS_VirtualMachine *vm, pthread_t thread) {
    NSCAssert(vm, @"vm && \"Attach thread on NULL OCSVirtualMachine.\"");
    NSCAssert(thread, @"thread && \"Attach NULL thread on OCSVirtualMachine\"");
    if (vm && thread) {
        vm->thread = thread;
    }
}

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

// sub_2a0bef0
void
StackInfoAppend(NSMutableString *infos, OCS_Frame *frame) {
    if (infos && frame) {
        [infos appendFormat:@"[class:%@] ", [frame->cls->value class]];
        [infos appendFormat:@"[methodName:%@] ", frame->codeBlock->method];
        [infos appendFormat:@"[pc:%d]", frame->pc];
        [infos appendString:@"\n"];
    }
}

/*
void sub_2a0bef0(int arg0, int arg1) {
    stack[2043] = r4;
    stack[2044] = r5;
    stack[2045] = r6;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0x14) + 0xc;
    r4 = arg0;
    r5 = arg1;
    if ((r4 != 0x0) && (r5 != 0x0)) {
        r3 = [**(r5 + 0x10) class];
        r0 = [r4 appendFormat:@"[class:%@] "];
        r3 = *(*(r5 + 0xc) + 0x18);
        r0 = [r4 appendFormat:@"[methodName:%@] "];
        r3 = *(r5 + 0x8);
        r0 = [r4 appendFormat:@"[pc:%d]"];
        r2 = @"\n";
        r1 = @selector(appendString:);
        r0 = r4;
        r0 = loc_2dee71c();
    }
    return;
}
 */

// sub_2a0bf7e
NSString *
OCSVMStackInfo(OCS_VirtualMachine *vm) {
    if (vm) {
        NSMutableString *infos =
        [NSMutableString stringWithFormat:@"[VMState:%zd]\n ", vm->state];
        if (vm->currentFrame) {
            
            int32_t i = 0;
            OCS_Frame *frame = vm->currentFrame;
            while (frame) {
                [infos appendFormat:@"%zd ", i];
                StackInfoAppend(infos, vm->currentFrame);
                frame = frame->back;
                i ++;
            }
            
            return infos;
        }
    }
    
    return nil;
}

/*
int sub_2a0bf7e(int arg0) {
    stack[2043] = r4;
    stack[2044] = r5;
    stack[2045] = r6;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0x14) + 0xc;
    stack[4611686018427389945] = r8;
    stack[4611686018427389946] = r10;
    sp = sp - 0x1c;
    r5 = arg0;
    if (r5 != 0x0) {
        r0 = [NSMutableString stringWithFormat:@"[VMState:%zd]\n ", *(r5 + 0x14)];
        r5 = *r5;
        r4 = r0;
        if (r5 != 0x0) {
            r2 = @"%zd ";
            r3 = 0x0;
            r0 = objc_msgSend(r4, *@selector(appendFormat:));
            r0 = sub_2a0bef0(r4, r5);
            r5 = *r5;
            if (r5 != 0x0) {
                r8 = *@selector(appendFormat:);
                r6 = 0x1;
                r10 = @"%zd ";
                do {
                    r2 = @"%zd ";
                    r3 = r6;
                    r0 = objc_msgSend(r4, r8);
                    r0 = sub_2a0bef0(r4, r5);
                    r5 = *r5;
                    r6 = r6 + 0x1;
                } while (r5 != 0x0);
            }
        }
        else {
            r4 = 0x0;
        }
    }
    else {
        r4 = 0x0;
    }
    r0 = r4;
    return r0;
}
 */

// sub_2a0c01c
void
OCSVirtualMachineExecuteWithArr(OCS_VirtualMachine* vm, OCS_CodeBlock* codeBlock, OCS_ReturnValue *returnVal, OCS_ParaList* argList) {
    NSCAssert(vm, @"vm && \"Execute on NULL OCSVirtualMachine\"");
    NSCAssert(codeBlock, @"codeBlock && \"Execute NULL OCSCodeBlock\"");
    // loc_2a0c080
    // if (*(stack[2021] + 0x14) != 0x1)
    
    if (vm->state != 0x1 /* vm + 0x14 */) {
        // loc_2a0c0a6
        //        stack[2023] = *(stack[2021] + 0x8);
        //        stack[2024] = *(stack[2021] + 0x4);
        //        r2 = stack[2024];
        //        r3 = (SAR(0xc + stack[2023] + (*(stack[2023] + 0x8) + *(stack[2023] + 0x8) * 0x2) * 0x4 - r2, 0x2)) * 0xaaaaaaab;
        //        r0 = stack[2023];
        //        r1 = *(r4 + 0x10) + *(r4 + 0x14);
        //        if (r3 >= r1) goto loc_2a0c126;
        
        OCS_StackBlock *stackBlock = vm->stackBlock;/* vm + 0x8 */ // ??
        void *sp = vm->stackPointer; /* vm + 0x4 */
        
        int32_t needSize = codeBlock->localVarCount + codeBlock->stackSize;
        
        int32_t rest = (stackBlock->allocSize * STACK_CELL_SIZE - ((int32_t)vm->stackPointer - (int32_t)&stackBlock->stack)) / STACK_CELL_SIZE;
        
        if (rest < needSize) {
            OCS_StackBlock *tmpStackBlock = stackBlock;
            
            // loc_2a0c0e0
            do {
                tmpStackBlock = tmpStackBlock->next;
                if (!tmpStackBlock) {
                    // loc_2a0c0ec
                    
                    OCS_StackBlock *pos;
                    for (pos = stackBlock; pos->next != NULL; pos = pos->next)
                        ;
                    int32_t size = MAX(vm->stackSize, needSize); // ??
                    tmpStackBlock = OCSStackBlockCreate(pos, NULL, size);
                    pos->next = tmpStackBlock;
                    vm->stackSize += size;
                    break;
                }
            } while (tmpStackBlock->allocSize < needSize);
            
            // loc_2a0c11a
            vm->stackBlock = tmpStackBlock;
            vm->stackPointer = &tmpStackBlock->stack;
        }
        
        // loc_2a0c126
        
        OCS_Frame f;
        
        f.back = vm->currentFrame;
        f.pc = 0;
        f.codeBlock = codeBlock;
        f._0x14 = argList;
        
//        OCS_Frame *f_2014 = vm->currentFrame;
        CFMutableArrayRef arrCStructs = CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
        
        f.arrCStruct = arrCStructs;
        
        int32_t state_2025 = vm->state;
        vm->state = 1;
        vm->stackPointer +=  codeBlock->localVarCount * STACK_CELL_SIZE;
        vm->currentFrame = &f;
        _virtualMachineEval(vm);
        void* stackP = vm->stackPointer;
        
        // 0x5e '^' malloc(0x4)
        // 0x7b '{'
        // 0x51 Q
        // 0x53 S
        // 0x49 I
        // 0x4C L
        
        switch (returnVal->typeEncode) {

#define OCS_RET_CASE_RET(_typeChar, _type)  \
    case _typeChar : {  \
        void *v = malloc(sizeof(_type));    \
        rv->value = v;  \
        *v = *(stackP - 0x8);   \
        break;  \
    }
                
            OCS_RET_CASE_RET('@', id)
            OCS_RET_CASE_RET('^', void*)
            OCS_RET_CASE_RET('*', void*)
            OCS_RET_CASE_RET('#', Class)
            OCS_RET_CASE_RET(':', SEL)
                
            OCS_RET_CASE_RET('c', char)
            OCS_RET_CASE_RET('C', unsigned char)
            OCS_RET_CASE_RET('s', short)
            OCS_RET_CASE_RET('S', unsigned short)
            OCS_RET_CASE_RET('i', int)
            OCS_RET_CASE_RET('I', unsigned int)
            OCS_RET_CASE_RET('l', long)
            OCS_RET_CASE_RET('L', unsigned long)
            OCS_RET_CASE_RET('q', long long)
            OCS_RET_CASE_RET('Q', unsigned long long)
            OCS_RET_CASE_RET('f', float)
            OCS_RET_CASE_RET('d', double)
            OCS_RET_CASE_RET('B', BOOL)
                
            case 'v':
                break;
            case '{':
            {
                OCS_Struct* st = stackP - 0x8;
                size_t size = [st->structType->typeStruct totalSize];
                void *buf = malloc(size);
                memcpy(buf, st->value, size);
                returnVal->value = buf;
            }
                break;
            default:
                break;
        }
        
        
//        int32_t r_r6 = stack[2022];
//        if (r_r6 > ']') { // 0x5d
//            // loc_3516e0
//            if (r_r6 > 'v') { // 0x76 r0 = r6 - 0x63
//                // loc_351720
//                if (r_r6 != '^') { // 0x5e
//                    if (r_r6 == '{') { // 0x7b
//                        OCS_Struct* st = stackP - 0x8;
//                        size_t size = [st->structType->typeStruct totalSize];
//                        void *buf = malloc(size);
//                        memcpy(buf, st->value, size);
//                        rv->value = buf;
//                    }
//                    else {
//                        [NSException raise:@"OCSCommonException" format:@"vm returnValue type not define:%c", r_r6];
//                    }
//                }
//                else {
//                    void *v = malloc(0x4);
//                    rv->value = v;
//                    *v = *(stackP - 0x8);
//                }
//                // loc_2a0c2ce
//            }
//            else {
//                // loc_3516e8 ; ; 0x351700,0x351776,0x351790,0x3517a2,0x3517ba,0x3517d
//                goto *0x2a0c1bc[r0];
//            }
//        }
//        else if (r_r6 > 'H') { // 0x48
//            // loc_351712
//            if (r_r6 <= 'P') {
//                
//            }
//            else {
//                if (r_r6 != 'Q') {
//                    if (r_r6 == 'S') {
//                        malloc(sizeof(unsigned short));
//                    }
//                    else {
//                        [NSException raise:@"OCSCommonException" format:@"vm returnValue type not define:%c", r_r6];
//                    }
//                }
//                else {
//                    malloc(sizeof(unsigned long long));
//                }
//            }
//            
//            // loc_2a0c2ce
//        }
//        else if (r_r6 - 0x3a > 0x9) {
//            // loc_35176e
//            if (r_r6 != '$') { // 0x24
//                if (r_r6 == '*') {
//                    malloc(0x4);
//                }
//                else {
//                    [NSException raise:@"OCSCommonException" format:@"vm returnValue type not define:%c", r_r6];
//                }
//            }
//            
//            // loc_2a0c2ce
//        }
//        else {
//            // loc_3516d2 ; 0x351700,0x351776,0x3517ba, case 10
//            goto *0x2a0c1a6[r0];
//            
//        }
        
        // loc_2a0c2ce
        CFArrayApplyFunction(arrCStructs, CFRangeMake(0, CFArrayGetCount(arrCStructs)), OCSDestroyStruct, NULL);
        CFRelease(arrCStructs);
        
        vm->state = state_2025;
        vm->stackPointer = sp;
        vm->stackBlock = stackBlock;
        vm->currentFrame = vm->currentFrame->back;
    }
    else {
        printf("[OCS ERROR]");
        printf("OCSVirtualMachine is already running.");
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
 
// sub_2a0e360
void
_virtualMachineEval(OCS_VirtualMachine *vm) {
    NSCAssert(vm, @"vm && \"Eval on NULL OCSVirtualMachine\"");
    /* vm r5*/
    OCS_Frame *fp = vm->currentFrame;
    OCS_CodeBlock *codes = fp->codeBlock; /*sl*/
    //  loc_2a0e50a
    int32_t pc = fp->pc; /*r6*/
    /*r3 codes->buf*/
    int8_t opCode = ((int8_t)(codes->buf[pc]));
    if (opCode > 0xef) {
        // loc_2a0ed28
        [NSException raise:@"OCSCommonException" format:@"Invalid Opcode %d", opCode];
    }
    else {
        
        // 1
        // sub_2a0e360+4038
        fp->pc = fp->pc + 1;
        // sub_2a0e360+426
        
        
        // ??
        [vm->stackPointer + 0x4, #0x4] = CFArrayGetValueAtIndex(fp->_0x14, codes->buf[pc+1]);
        r1 = vm->stackPointer;
        //  sub_2a0e360+3406
        r0 = vm->stackPointer + 0xc;
        // sub_2a0e360+3540
        vm->stackPointer = r0;
        // sub_2a0e360+416
        fp->pc += 0x2;
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

void
_cleanLocalStruct(OCS_Struct *s, void *context) {
    OCSDestroyStruct(s, context);
}

int
OCSVirtualMachineDirCallWithArr() {
    // TODO
}



// sub_2a1111e
void
_virtualMachineRegisterCStruct(OCS_VirtualMachine *vm, OCS_Struct *st) {
    NSCAssert(vm, @"vm && \"Register CStruct on NULL OCSVirtualMachine\"");
    NSCAssert(vm->currentFrame, @"vm->currentFrame && \"OCSVirtualMachine Frame is NULL\"");
    CFArrayAppendValue(vm->currentFrame->arrCStruct, st);
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

// sub_2a113de
void _getObjectIvar() {

}

/*
int sub_2a113de(int arg0, int arg1, int arg2, int arg3, int arg4, int arg5) {
    stack[2049] = arg5;
    stack[2048] = arg4;
    stack[2045] = r6;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0x14) + 0xc;
    stack[4611686018427389944] = r8;
    stack[4611686018427389945] = r10;
    stack[4611686018427389946] = r11;
    sp = sp - 0x20;
    r8 = arg0;
    r6 = arg1;
    r11 = arg3;
    r0 = [r6 class];
    r0 = class_getInstanceVariable(r0, arg2);
    r4 = r0;
    if (*(int8_t *)ivar_getTypeEncoding(r0) == 0x7b) {
        r10 = arg5;
        r1 = r6 + ivar_getOffset(r4);
        r0 = r11;
        if ((arg4 & 0xff) != 0x0) {
            r0 = sub_2a12e02(r0, r1);
        }
        else {
            r0 = sub_2a12da8(r0, r1);
        }
        r5 = r0;
        r1 = r5;
        r0 = sub_2a1111e(r8);
        r0 = 0x11;
        *r10 = r0;
        *(r10 + 0x4) = r5;
    }
    else {
        r2 = 0xaf7;
        r0 = "_getObjectStructIvar";
        r1 = "/Users/liujizhou/workspace/OCSPatch/OCSVirtualMachine/OCSVirtualMachine/OCSEngine/VirtualMachine/OCSVirtualMachine.m";
        r3 = "NO && \"IVar must be Struct Type, for scalar type, use _getObjectIvar instead.\"";
        r0 = __assert_rtn();
    }
    return r0;
}
 */

void
_setObjectIvar() {}

void
_getObjectStructIvar() {}

// sub_2a11474
// in JSPatch
// static id callSelector(NSString *className, NSString *selectorName, JSValue *arguments, JSValue *instance, BOOL isSuper)
void
_messageSendN(int arg0, OCS_VirtualMachine *vm, id target, SEL selector, BOOL isSuper, int arg5, NSString *arg6) {
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    if (signature) {
        // loc_35574e
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.target = target;
        
        SEL sel = selector;
        if (isSuper) {
            // ??
            Class superCls = class_getSuperclass(NSClassFromString((vm->currentFrame)->codeBlock->clsName));
            if (!superCls) {
                superCls = [target superclass];
            }
            
            SEL superSelector =
            NSSelectorFromString([NSString stringWithFormat:@"=OCS_SUPER=%@=%@",
                                  NSStringFromClass(superCls),
                                  NSStringFromSelector(selector)]);
            Method superMethod = class_getInstanceMethod(superCls, selector);
            IMP superIMP = method_getImplementation(superMethod);
            
            class_addMethod([target class], superSelector, superIMP, method_getTypeEncoding(superMethod));
            
            sel = superSelector;
        }
        
        invocation.selector = sel;
        
        // loc_35585a
        if (2 >= signature.numberOfArguments) {
            // loc_355aaa
            [invocation invoke];
            const char *returnType = [methodSignature methodReturnType];
            // r 0x72
            char rType = returnType[0] == 'r' ? returnType[1] : returnType[0];
            
            // [ 0x5d
            if (rType > '[') {
                // loc_355b06
                // v 0x63
                if (rType > 'c') {
                    // loc_355b42
                    
                    // ^ 0x5e
                    if (rType == '^') {
                        // loc_355c2c
                        // loc_355c32
                        [invocation getReturnValue:]
                    }
                    // { 0x7b
                    else if (rType == '{') {
                        // loc_355b46
                        OCS_Struct *st = OCSCreateRValueStruct(arg6);
                        [invocation getReturnValue:st->value];
                        _virtualMachineRegisterCStruct(vm, st);
                    }
                    else {
                        [NSException raise:@"OCSCommonException" format:@"Unsupported return type: %s", rType];
                    }
                }
                else {
                    // loc_355b0e
                    
                    goto *0x355b12[r1];
                }
            }
            // H 0x48
            else if (rType > 'H') {
                // loc_355b2e
            }
            // C 0x43
            else if (rType > 'C') {
                // loc_355b70
            }
            else {
                // loc_355af0
                
                goto *0x355af4[r1];
            }
        }
        else {
            // loc_355868
        }
    }
    else {
        // loc_355c5a
        NSString *reason = [NSString stringWithFormat:@"[%@ %@]: unrecognized selector sent to instance %p", [target class], NSStringFromSelector(selector), &target];
        @throw [NSException exceptionWithName:@"NSInvalidArgumentException" reason:reason userInfo:nil];
    }
    
    
}

/*
int sub_2a11474(int arg0, int arg1, int arg2, int arg3, int arg4, int arg5, int arg6) {
    stack[2050] = arg6;
    stack[2049] = arg5;
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
    r4 = sp - 0x50;
    asm { bfc        r4, #0x0, #0x3 };
    sp = r4;
    stack[2032] = r1;
    r4 = r0;
    r10 = r3;
    r5 = r2;
    r6 = [r5 methodSignatureForSelector:r10, r3, stack[2028], stack[2029], stack[2030], stack[2031], stack[2032], stack[2033], stack[2034], stack[2035], stack[2036], stack[2037], stack[2038], r5, stack[2040], stack[2041], stack[2042]];
    if (r6 == 0x0) goto loc_2a11a44;
    
loc_2a114ac:
    r11 = [NSInvocation invocationWithMethodSignature:r6];
    r0 = [r11 setTarget:r5];
    if ((arg4 & 0xff) != 0x0) {
        stack[2034] = r4;
        r8 = NSSelectorFromString([NSString stringWithFormat:@"__OCS_SUPER_%@", NSStringFromSelector(r10)]);
        r0 = [r5 superclass];
        r0 = class_getInstanceMethod(r0, r10);
        r10 = method_getImplementation(r0);
        r5 = [r5 class];
        r0 = method_getTypeEncoding(r0);
        r0 = class_addMethod(r5, r8, r10, r0);
        r5 = r11;
        r2 = r8;
        r1 = @selector(setSelector:);
        r0 = r11;
    }
    else {
        stack[2034] = r4;
        r5 = r11;
        r2 = r10;
        r1 = @selector(setSelector:);
        r0 = r11;
    }
    r0 = [r0 setSelector:r2];
    r0 = objc_msgSend(r6, *@selector(numberOfArguments));
    if (objc_msgSend(r6, *@selector(numberOfArguments)) < 0x3) goto loc_2a117ea;
    
loc_2a115b8:
    r4 = arg5;
    r8 = *@selector(numberOfArguments);
    r11 = 0x2;
    r10 = @selector(getArgumentTypeAtIndex:);
    stack[2035] = @selector(setArgument:atIndex:);
    stack[2033] = @selector(raise:format:);
    goto loc_2a115ec;
    
loc_2a115ec:
    r0 = [r6 getArgumentTypeAtIndex:r11];
    r1 = *(int8_t *)r0;
    if (r1 == 0x72) {
        asm { ldrbeq     r1, [r0, #0x1] };
    }
    r1 = sign_extend_32(r1);
    if (r1 > 0x5d) goto loc_2a11636;
    
loc_2a11604:
    if (r1 > 0x48) goto loc_2a11666;
    
loc_2a11608:
    if (r1 > 0x43) goto loc_2a11698;
    
loc_2a11610:
    goto *0x2a11614[r0];
    
loc_2a116c8:
    r0 = *(r4 + 0x4);
    goto loc_2a116ca;
    
loc_2a116ca:
    stack[2036] = r0;
    goto loc_2a117ca;
    
loc_2a117ca:
    r1 = @selector(setArgument:atIndex:);
    r2 = sp + 0x20;
    r0 = r5;
    goto loc_2a117d0;
    
loc_2a117d0:
    r3 = r11;
    goto loc_2a117d2;
    
loc_2a117d2:
    r0 = objc_msgSend(r0, r1);
    r11 = r11 + 0x1;
    r4 = r4 + 0xc;
    if (r11 < objc_msgSend(r6, r8)) goto loc_2a115ec;
    
loc_2a117ea:
    r4 = r5;
    r0 = [r4 invoke];
    stack[2038] = *0x3f647e8;
    stack[2036] = *(int64_t *)0x3f647e0;
    r0 = [r6 methodReturnType];
    r1 = *(int8_t *)r0;
    if (r1 == 0x72) {
        asm { ldrbeq     r1, [r0, #0x1] };
    }
    r6 = stack[2034];
    r1 = sign_extend_32(r1);
    if (r1 > 0x5d) goto loc_2a11860;
    
loc_2a11836:
    if (r1 > 0x48) goto loc_2a1188e;
    
loc_2a1183a:
    if (r1 > 0x43) goto loc_2a118e0;
    
loc_2a11844:
    goto *0x2a11848[r0];
    
loc_2a11852:
    r1 = 0xf;
    r0 = @selector(getReturnValue:);
    goto loc_2a11a1c;
    
loc_2a11a1c:
    stack[2036] = r1;
    r2 = sp + 0x20 | 0x4;
    r0 = objc_msgSend(r4, *@selector(getReturnValue:));
    goto loc_2a11a2c;
    
loc_2a11a2c:
    r0 = *0x3f647e8;
    *(r6 + 0x8) = r0;
    *(int64_t *)r6 = stack[2036];
    sp = r7 - 0x18;
    return r0;
    
loc_2a11916:
    stack[2028] = r0;
    r0 = [NSException raise:@"OCSCommonException" format:@"Unsupported return type: %s"];
    goto loc_2a11a2c;
    
loc_2a1194c:
    r1 = 0xe;
    r0 = @selector(getReturnValue:);
    goto loc_2a11a1c;
    
loc_2a11880:
    r1 = 0x1;
    r0 = @selector(getReturnValue:);
    goto loc_2a11a1c;
    
loc_2a1195a:
    r1 = 0x2;
    r0 = @selector(getReturnValue:);
    goto loc_2a11a1c;
    
loc_2a118e0:
    if (r1 == 0x23) goto loc_2a11a02;
    
loc_2a118e6:
    if (r1 != 0x2a) goto loc_2a11916;
    
loc_2a118ea:
    r5 = sp + 0x20 | 0x4;
    r8 = @selector(getReturnValue:);
    goto loc_2a1198a;
    
loc_2a1198a:
    stack[2036] = 0x10;
    r0 = [r4 getReturnValue:r5];
    goto loc_2a11a2c;
    
loc_2a11a02:
    r1 = 0xd;
    r0 = @selector(getReturnValue:);
    goto loc_2a11a1c;
    
loc_2a1188e:
    if (r1 > 0x50) goto loc_2a11900;
    
loc_2a11892:
    if (r1 == 0x49) goto loc_2a119e6;
    
loc_2a11898:
    if (r1 != 0x4c) goto loc_2a11916;
    
loc_2a1189c:
    r1 = 0x8;
    r0 = @selector(getReturnValue:);
    goto loc_2a11a1c;
    
loc_2a119e6:
    r1 = 0x6;
    r0 = @selector(getReturnValue:);
    goto loc_2a11a1c;
    
loc_2a11900:
    if (r1 == 0x51) goto loc_2a119f4;
    
loc_2a11904:
    if (r1 != 0x53) goto loc_2a11916;
    
loc_2a11908:
    r1 = 0x4;
    r0 = @selector(getReturnValue:);
    goto loc_2a11a1c;
    
loc_2a119f4:
    r1 = 0xa;
    r0 = @selector(getReturnValue:);
    goto loc_2a11a1c;
    
loc_2a11860:
    if (r1 > 0x76) goto loc_2a118aa;
    
loc_2a11868:
    goto *0x2a1186c[r0];
    
loc_2a11968:
    stack[2036] = 0xc;
    r5 = sp + 0x20 | 0x4;
    r0 = [r4 getReturnValue:r5];
    goto loc_2a1198a;
    
loc_2a1199a:
    r1 = 0xb;
    r0 = @selector(getReturnValue:);
    goto loc_2a11a1c;
    
loc_2a119a8:
    r1 = 0x5;
    r0 = @selector(getReturnValue:);
    goto loc_2a11a1c;
    
loc_2a119b6:
    r1 = 0x7;
    r0 = @selector(getReturnValue:);
    goto loc_2a11a1c;
    
loc_2a119c4:
    r1 = 0x9;
    r0 = @selector(getReturnValue:);
    goto loc_2a11a1c;
    
loc_2a119d2:
    r1 = 0x3;
    r0 = @selector(getReturnValue:);
    goto loc_2a11a1c;
    
loc_2a119e0:
    stack[2036] = 0x0;
    goto loc_2a11a2c;
    
loc_2a118aa:
    if (r1 == 0x5e) goto loc_2a11a10;
    
loc_2a118b0:
    if (r1 == 0x7b) {
        stack[2036] = 0x11;
        r5 = sub_2a12d70(arg6);
        r0 = [r4 getReturnValue:*(r5 + 0x8)];
        r1 = r5;
        stack[2037] = r5;
        r0 = sub_2a1111e(stack[2032]);
    }
    else {
        stack[2028] = r0;
        r0 = [NSException raise:@"OCSCommonException" format:@"Unsupported return type: %s"];
    }
    goto loc_2a11a2c;
    
loc_2a11a10:
    r1 = 0x10;
    r0 = @selector(getReturnValue:);
    goto loc_2a11a1c;
    
loc_2a116e4:
    stack[2028] = r0;
    r0 = @class(NSException);
    r1 = @selector(raise:format:);
    r2 = @"OCSCommonException";
    r3 = @"Unsupported argument type: %s";
    goto loc_2a117d2;
    
loc_2a1161e:
    stack[2036] = 0x0;
    if (*r4 == 0x1) {
        r0 = *(int8_t *)(r4 + 0x4);
        if (r0 != 0x0) {
            asm { movsne     r0, #0x1 };
        }
    }
    else {
        r0 = sub_2a11ca8(r4);
    }
    goto loc_2a11774;
    
loc_2a11774:
    stack[2036] = r0;
    goto loc_2a117ca;
    
loc_2a11654:
    stack[2036] = 0x0;
    if (*r4 <= 0x2) {
        r0 = *(int8_t *)(r4 + 0x4);
    }
    else {
        r0 = sub_2a11d08(r4);
    }
    goto loc_2a11774;
    
loc_2a11698:
    if ((r1 == 0x23) || (r1 == 0x2a)) goto loc_2a116c8;
    goto loc_2a116e4;
    
loc_2a11666:
    if (r1 > 0x50) goto loc_2a116a2;
    
loc_2a1166a:
    if (r1 == 0x49) goto loc_2a116bc;
    
loc_2a1166e:
    if (r1 != 0x4c) goto loc_2a116e4;
    
loc_2a11672:
    stack[2036] = 0x0;
    if (*r4 >= 0x8) {
        r0 = sub_2a11dd4(r4);
    }
    else {
        r0 = *(r4 + 0x4);
    }
    goto loc_2a116ca;
    
loc_2a116bc:
    stack[2036] = 0x0;
    if (*r4 <= 0x6) {
        r0 = *(r4 + 0x4);
    }
    else {
        r0 = sub_2a11d8c(r4);
    }
    goto loc_2a116ca;
    
loc_2a116a2:
    if (r1 == 0x51) goto loc_2a116ce;
    
loc_2a116a6:
    if (r1 != 0x53) goto loc_2a116e4;
    
loc_2a116aa:
    stack[2036] = 0x0;
    if (*r4 <= 0x4) {
        r0 = *(int16_t *)(r4 + 0x4);
    }
    else {
        r0 = sub_2a11d48(r4);
    }
    stack[2036] = r0;
    goto loc_2a117ca;
    
loc_2a116ce:
    r0 = 0x0;
    asm { strd       r0, r0, [sp, #0x48 + var_28] };
    r0 = *r4;
    r1 = r0 - 0x9;
    if (r1 <= 0x1) {
        r0 = *(r4 + 0x4);
        r1 = *(r4 + 0x8);
    }
    else {
        r2 = r0 - 0x1;
        r0 = 0x0;
        if (r2 <= 0xb) {
            r3 = r1 + r2 * 0x4;
            r1 = 0x0;
            switch (0x0) {
                case 0:
                    r1 = SAR(sign_extend_32(*(int8_t *)(r4 + 0x4)), 0x1f);
                    break;
                case 1:
                    r1 = SAR(sign_extend_32(*(int16_t *)(r4 + 0x4)), 0x1f);
                    break;
                case 2:
                    r1 = SAR(*(r4 + 0x4), 0x1f);
                    break;
                case 3:
                    break;
                case 4:
                    r0 = *(r4 + 0x4);
                    r0 = __fixsfdi();
                    break;
                case 5:
                    d16 = *(int64_t *)(r4 + 0x4);
                    r0 = d16 & 0xffff;
                    r1 = d16 >> 0x10;
                    r0 = __fixdfdi();
                    break;
            }
        }
        else {
            r1 = 0x0;
        }
    }
    asm { strd       r0, r1, [sp, #0x48 + var_28] };
    goto loc_2a117ca;
    
loc_2a11636:
    if (r1 > 0x73) goto loc_2a11686;
    
loc_2a1163e:
    goto *0x2a11642[r0];
    
loc_2a11714:
    r0 = 0x0;
    asm { strd       r0, r0, [sp, #0x48 + var_28] };
    if (*r4 == 0xc) {
        d16 = *(int64_t *)(r4 + 0x4);
    }
    else {
        s0 = sub_2a11e78(r4);
        asm { vcvt.f64.s32 d16, s0 };
    }
    stack[2036] = d16;
    goto loc_2a117ca;
    
loc_2a11726:
    stack[2036] = 0x0;
    if (*r4 == 0xb) {
        s0 = *(r4 + 0x4);
    }
    else {
        r0 = sub_2a11e1c(r4);
    }
    stack[2036] = s0;
    d0 = d0 | d0;
    goto loc_2a117ca;
    
loc_2a11686:
    if (r1 == 0x5e) goto loc_2a116c8;
    
loc_2a1168a:
    if (r1 != 0x7b) goto loc_2a116e4;
    
loc_2a1168e:
    r1 = @selector(setArgument:atIndex:);
    r2 = *(*(r4 + 0x4) + 0x8);
    r0 = r5;
    goto loc_2a117d0;
    
loc_2a11a44:
    r6 = @class(NSString);
    r5 = [r5 class];
    r0 = NSStringFromSelector(r10);
    r3 = sp + 0x2c;
    r1 = @selector(stringWithFormat:);
    r2 = @"[%@ %@]: unrecognized selector sent to instance %p";
    asm { strd       r0, r3, [sp, #0x48 + var_48] };
    r3 = r5;
    r4 = objc_msgSend(r6, *r1);
    r0 = [NSException alloc];
    r0 = [r0 initWithName:@"NSInvalidArgumentException" reason:r4 userInfo:0x0];
    r0 = objc_exception_throw(r0);
    return r0;
}
 */

// sub_2a11ad0
void
_messageSend_var(int arg0, OCS_VirtualMachine *vm, id target, SEL selector, BOOL isSuper, int arg5) {
    _init_OCS_FFiBuff(vm);
    
    if (isSuper) {
        // ??
        Class superCls = class_getSuperclass(NSClassFromString((vm->currentFrame)->codeBlock->clsName));
        if (!superCls) {
            superCls = [target superclass];
        }
        
        SEL superSelector =
        NSSelectorFromString([NSString stringWithFormat:@"=OCS_SUPER=%@=%@",
                              NSStringFromClass(superCls),
                              NSStringFromSelector(selector)]);
        Method superMethod = class_getInstanceMethod(superCls, selector);
        IMP superIMP = method_getImplementation(superMethod);
        
        class_addMethod([target class], superSelector, superIMP, method_getTypeEncoding(superMethod));
    }
    ffi_cif cif;
    ffi_status ffiPrepStatus = ffi_prep_cif_var(&cif, FFI_DEFAULT_ABI, (unsigned int)0, (unsigned int)argCount, returnFfiType, ffiArgTypes);
    if (ffiPrepStatus == FFI_OK) {
        IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
        
#endif
        ffi_call(&cif, functionPtr, returnPtr, ffiArgs);

    }
    
    _clearFFiBuff()
    
}

/*
int sub_2a11ad0(int arg0, int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, int arg7, int arg8) {
    stack[2052] = arg8;
    stack[2051] = arg7;
    stack[2050] = arg6;
    stack[2049] = arg5;
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
    r4 = sp - 0x90;
    asm { bfc        r4, #0x0, #0x3 };
    sp = r4;
    r8 = r0;
    r11 = arg6;
    d16 = *(int64_t *)0x3f647e0;
    r5 = sp + 0x18;
    r0 = *0x3f647e8;
    stack[2039] = *___stack_chk_guard;
    asm { strd       r3, r2, [sp, #0x88 + var_54] };
    stack[2016] = r0;
    stack[2018] = r11;
    stack[2019] = 0x2;
    stack[2014] = d16;
    r0 = sub_2a11ee4(r1, r5, sp + 0x8, arg5, arg7, 0x0);
    r3 = arg8;
    *stack[2020] = 0x3f64864;
    *stack[2021] = sp + 0x38;
    *(stack[2020] + 0x4) = 0x3f64864;
    if ((arg4 & 0xff) != 0x0) {
        r10 = NSSelectorFromString([NSString stringWithFormat:@"__OCS_SUPER_%@", NSStringFromSelector(stack[2025])]);
        r0 = [stack[2026] superclass];
        r0 = class_getInstanceMethod(r0, stack[2025]);
        r4 = method_getImplementation(r0);
        r5 = [stack[2026] class];
        r0 = method_getTypeEncoding(r0);
        r0 = class_addMethod(r5, r10, r4, r0);
        r3 = arg8;
        r1 = sp + 0x3c;
        r0 = stack[2021];
    }
    else {
        r0 = stack[2021];
        r1 = sp + 0x34;
    }
    *(r0 + 0x4) = r1;
    r2 = r3 + 0x2;
    r0 = stack[2020];
    r3 = r11 + 0x2;
    r1 = stack[2024];
    asm { strd       r1, r0, [sp, #0x88 + var_88] };
    r0 = sp + 0x3c;
    r1 = 0x1;
    if (sub_2a1824e() == 0x0) {
        r3 = stack[2021];
        r2 = stack[2023];
        if (stack[2014] == 0x11) {
            r1 = 0x2e604f4;
        }
        else {
            r1 = 0x2e5c1b8;
        }
        r0 = sub_2a163c4(sp + 0x3c, *r1, r2, r3);
    }
    r0 = sub_2a1236a(sp + 0x18);
    *(r8 + 0x8) = stack[2016];
    *(int64_t *)r8 = stack[2014];
    r0 = *___stack_chk_guard - *___stack_chk_guard;
    if (r0 == 0x0) {
        asm { sub.weq    r4, r7, #0x18 };
    }
    if (CPU_FLAGS & E) {
        asm { moveq      sp, r4 };
    }
    if (CPU_FLAGS & E) {
        asm { pop.weq    {r8, sl, fp} };
    }
    if (CPU_FLAGS & E) {
        return r0;
    }
    r0 = __stack_chk_fail();
    return r0;
}
 */

// sub_2a11c56
void
_messageSendStructToNilReceiver(int arg0, OCS_VirtualMachine *vm, NSString *arg2) {
    OCS_Struct *s = OCSCreateRValueStruct(arg2);
    OCS_StructType *st = s->structType;
    memset(value, 0, [s->typeStruct totalSize]);
    _virtualMachineRegisterCStruct(vm, s);
    
    
    // TODO
    /*
     *arg0 = 0x11;
     *(arg0 + 0x4) = r6;
     *(arg0 + 0x8) = 0x0;
     */
}

/*
int sub_2a11c56(int arg0, int arg1, int arg2) {
    stack[2043] = r4;
    stack[2044] = r5;
    stack[2045] = r6;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0x14) + 0xc;
    stack[4611686018427389945] = r8;
    stack[4611686018427389946] = r10;
    sp = sp - 0x1c;
    r6 = sub_2a12d70(arg2);
    r0 = [*(*r6 + 0x4) totalSize];
    r0 = memset(*(r6 + 0x8), 0x0, r0);
    r1 = r6;
    r0 = sub_2a1111e(arg1);
    *arg0 = 0x11;
    *(arg0 + 0x4) = r6;
    *(arg0 + 0x8) = 0x0;
    return 0x11;
}
 */

void
_dynamicCastToBool() {}

void
_dynamicCastToChar() {}

void
_dynamicCastToShort() {}

void
_dynamicCastToInt() {}

void
_dynamicCastToLong() {}

void
_dynamicCastToFloat() {}

void
_dynamicCastToDouble() {}

void
_init_OCS_FFiBuff(OCS_VirtualMachine *vm, int arg1, int arg2, int arg3, const char * memEncode, int arg5) {
    
    // TODO
    
    NSArray *arrComponents = [OCSStructTypeParser componentsOfMembersEncode:[NSString stringWithUTF8String:memEncode]];
    
    for (int i = 0; i < arg1->0x0 ; ++i) {
        const char *cstr = [[arrComponents objectAtIndexedSubscript:i] UTF8String];
        
        if (cstr == '{') {
            [?? my_ffi_type];
        }
        else {
            getFfi_typeForCharType(cstr);
        }
    }
    
    
    
}

void
_clearFFiBuff() {}



// sub_2a13770
void
OCSRunWithParaList(NSString *className, NSString *methodName, OCS_ReturnValue * returnVal, OCS_ParaList* argList) {
    OCS_CodeBlock *codeBlock = OCSGetCodeBlock(className, methodName);
    OCS_VirtualMachine *vm = OCSGetCurrentThreadVirtualMachine();
    OCSVirtualMachineExecuteWithArr(vm, codeBlock, returnVal, argList);
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

// sub_2a13790
NSString *
CurrentThreadOCSVMExptionCallStackInfo() {
    OCS_VirtualMachine *vm = OCSGetCurrentThreadVirtualMachine();
    if (vm && vm->exptionCallStackInfo) {
        return [(__bridge NSString *)vm->exptionCallStackInfo copy];
    }
    
    return nil;
}

// sub_2a137c4
NSString *
CurrentThreadOCSVMStackInfo() {
    OCS_VirtualMachine *vm = OCSGetCurrentThreadVirtualMachine();
    return OCSVMStackInfo(vm);
}

/*
void sub_2a137c4() {
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = sp - 0x8;
    r0 = sub_2a1514a();
    r0 = sub_2a0bf7e(r0);
    return;
}
 */

void
OCSRunBlockWithLayout() {}

/*
void _OCSRunBlockWithLayout(int arg0, int arg1, int arg2) {
    r2 = arg2;
    stack[2043] = r4;
    stack[2044] = r5;
    stack[2045] = r6;
    stack[2046] = r7;
    stack[2047] = lr;
    stack[4611686018427389942] = r5;
    stack[4611686018427389943] = r6;
    stack[4611686018427389944] = (sp - 0x14) + 0xc;
    stack[4611686018427389945] = r8;
    stack[4611686018427389946] = r10;
    sp = sp - 0x28;
    r6 = arg0;
    r5 = r2;
    r8 = arg1;
    if (r6 != 0x0) {
        r0 = _getBlockArgVarInfo(r6);
        r1 = *(r0 + 0x8);
        r4 = _OCSGetCodeBlock(*(r0 + 0xc), r1);
        if (r4 != 0x0) {
            r10 = _OCSGetCurrentThreadVirtualMachine();
            r0 = _getSelfCaptureVar(r6, r1, r2, r3);
            r2 = sp + 0x8;
            stack[2040] = r0;
            asm { strd       r6, r5, [sp, #0x20 + var_20] };
            if (r0 == 0x0) {
                asm { moveq      r2, r0 };
            }
            r0 = OCSVirtualMachineExecuteWithArr(r10, r4, r2, r8, stack[2038], stack[2039]);
        }
        else {
            r0 = NSLog(@"OCSRunBlockWithLayout, get codeBlock nil ");
        }
    }
    return;
}
 */
