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
OCSVirtualMachineExecuteWithArr(OCS_VirtualMachine* vm, OCS_CodeBlock* codeBlock, OCS_ReturnValue *returnVal, OCS_Param* argList) {
    NSCAssert(vm, @"vm && \"Execute on NULL OCSVirtualMachine\"");
    NSCAssert(codeBlock, @"codeBlock && \"Execute NULL OCSCodeBlock\"");

    // loc_3515c2 
    // r0: vm
    
    if (vm->state != 0x1 /* vm + 0x14 */) {
        // loc_3515dc
        //        stack[2023] = *(stack[2021] + 0x8);
        //        stack[2024] = *(stack[2021] + 0x4);
        //        r2 = stack[2024];
        //        r3 = (SAR(0xc + stack[2023] + (*(stack[2023] + 0x8) + *(stack[2023] + 0x8) * 0x2) * 0x4 - r2, 0x2)) * 0xaaaaaaab;
        //        r0 = stack[2023];
        //        r1 = *(r4 + 0x10) + *(r4 + 0x14);
        //        if (r3 >= r1) goto loc_2a0c126;

        // r0: stackBlock
        // r1: codeBlock->localVarCount + codeBlock->stackSize
        // r2: vm->stackPointer
        // r3: ((stackBlock->allocSize + stackBlock->allocSize * 2) * 4 + stackBlock + 0xc - vm->stackPointer) / 12
        // r4: codeBlock
        // r6: codeBlock->stackSize
        // fp: ret_addr

        
        OCS_StackBlock *stackBlock = vm->stackBlock;/* vm + 0x8 */ // ??
        void *sp = vm->stackPointer; /* vm + 0x4 */
        
        int32_t needSize = codeBlock->localVarCount + codeBlock->stackSize;
        
        int32_t rest = (stackBlock->allocSize * STACK_CELL_SIZE - ((int32_t)vm->stackPointer - (int32_t)&stackBlock->stack)) / STACK_CELL_SIZE;
        
        if (rest < needSize) {

            // r0: tmpStackBlock->next

            OCS_StackBlock *tmpStackBlock = stackBlock;
            
            // loc_351614
            do {
                tmpStackBlock = tmpStackBlock->next;
                if (!tmpStackBlock) {
                    // loc_351620

                    // r0: tmpStackBlock
                    // r1: vm
                    // r2: vm->stackSize + size
                    // r5: MAX(vm->stackSize, needSize)
                    // r6: pos
                    
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
            
            // loc_35164e
            // r1: vm
            // r2: &tmpStackBlock->stack

            vm->stackBlock = tmpStackBlock;
            vm->stackPointer = &tmpStackBlock->stack;
        }
        
        // loc_35165a

        OCS_Frame f;
        
        f.back = vm->currentFrame;
        f.pc = 0;
        f.codeBlock = codeBlock;
        f._0x14 = argList;

        // OCS_Frame *f_2014 = vm->currentFrame;
        CFMutableArrayRef arrCStructs = CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
        
        f.arrCStruct = arrCStructs;
        
        int32_t state_2025 = vm->state;
        vm->state = 1;
        vm->stackPointer +=  codeBlock->localVarCount * STACK_CELL_SIZE;
        vm->currentFrame = &f;
        _virtualMachineEval(vm);
        void* stackP = vm->stackPointer;

        // r0: returnVal->typeEncode
        // r1: vm->state
        // r2: vm
        // r3: vm->stackPointer
        // r4: vm->stackPointer
        // r5: vm
        
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
                
            OCS_RET_CASE_RET('@', id)   // loc_351776
            OCS_RET_CASE_RET('^', void*)    // loc_351776
            OCS_RET_CASE_RET('*', void*)    // loc_351776
            OCS_RET_CASE_RET('#', Class)    // loc_351776
            OCS_RET_CASE_RET(':', SEL)  // loc_351776
                
            OCS_RET_CASE_RET('c', char) // loc_351700
            OCS_RET_CASE_RET('C', unsigned char)    // loc_351700
            OCS_RET_CASE_RET('s', short)    // loc_351790
            OCS_RET_CASE_RET('S', unsigned short)   // loc_351790
            OCS_RET_CASE_RET('i', int)  // loc_351776
            OCS_RET_CASE_RET('I', unsigned int) // loc_351776
            OCS_RET_CASE_RET('l', long) // loc_351776
            OCS_RET_CASE_RET('L', unsigned long)    // loc_351776
            OCS_RET_CASE_RET('q', long long)    // loc_3517a2
            OCS_RET_CASE_RET('Q', unsigned long long)   // loc_3517a2
            OCS_RET_CASE_RET('f', float)    // loc_351776
            OCS_RET_CASE_RET('d', double)   // loc_3517a2
            OCS_RET_CASE_RET('B', BOOL) // loc_351700
                
            case 'v':   // loc_3517da
                break;
            case '{':   // loc_351728
            {
                // r1: st->value
                // r0: returnVal
                // r2: size
                // r4: buf

                OCS_Struct* st = stackP - 0x8;
                size_t size = [st->structType->typeStruct totalSize];
                void *buf = malloc(size);
                memcpy(buf, st->value, size);
                returnVal->value = buf;
            }
                break;
            default:    // loc_3517ba
            {
                [NSException raise:@"OCSCommonException" format:@"vm returnValue type not define:%c", returnVal->typeEncode];
            }
                break;
        }
        
    /*    
       int32_t r_r6 = stack[2022];
       if (r_r6 > ']') { // 0x5d
           // loc_3516e0
           if (r_r6 > 'v') { // 0x76 r0 = r6 - 0x63
               // loc_351720
               if (r_r6 != '^') { // 0x5e
                   if (r_r6 == '{') { // 0x7b
                       OCS_Struct* st = stackP - 0x8;
                       size_t size = [st->structType->typeStruct totalSize];
                       void *buf = malloc(size);
                       memcpy(buf, st->value, size);
                       rv->value = buf;
                   }
                   else {
                       [NSException raise:@"OCSCommonException" format:@"vm returnValue type not define:%c", r_r6];
                   }
               }
               else {
                   void *v = malloc(0x4);
                   rv->value = v;
                   *v = *(stackP - 0x8);
               }
               // loc_2a0c2ce
           }
           else {
               // loc_3516e8 ; ; 0x351700,0x351776,0x351790,0x3517a2,0x3517ba,0x3517d
               goto *0x2a0c1bc[r0];
           }
       }
       else if (r_r6 > 'H') { // 0x48
           // loc_351712
           if (r_r6 <= 'P') {
               
           }
           else {
               if (r_r6 != 'Q') {
                   if (r_r6 == 'S') {
                       malloc(sizeof(unsigned short));
                   }
                   else {
                       [NSException raise:@"OCSCommonException" format:@"vm returnValue type not define:%c", r_r6];
                   }
               }
               else {
                   malloc(sizeof(unsigned long long));
               }
           }
           
           // loc_2a0c2ce
       }
       else if (r_r6 - 0x3a > 0x9) {
           // loc_35176e
           if (r_r6 != '$') { // 0x24
               if (r_r6 == '*') {
                   malloc(0x4);
               }
               else {
                   [NSException raise:@"OCSCommonException" format:@"vm returnValue type not define:%c", r_r6];
               }
           }
           
           // loc_2a0c2ce
       }
       else {
           // loc_3516d2 ; 0x351700,0x351776,0x3517ba, case 10
           goto *0x2a0c1a6[r0];
           
       }
    */
        
        // loc_3517e0

        // r0: vm
        // r1: vm
        // r2: state_2025
        // r3: CFArrayApplyFunction


        CFArrayApplyFunction(arrCStructs, CFRangeMake(0, CFArrayGetCount(arrCStructs)), _cleanLocalStructs, NULL);
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

    // r0: 0x0
    // r1: codes->buf[pc]
    // r2: &@selector(methodReturnType)
    // r3: &@selector(methodSignatureForSelector:)
    // r4: pc
    // r5: &@selector(release)
    // r6: codes->buf
    // r8: codes
    // sl: fp
    // fp: vm

    NSCAssert(vm, @"vm && \"Eval on NULL OCSVirtualMachine\"");
    /* vm r5*/
    OCS_Frame *fp = vm->currentFrame;
    OCS_CodeBlock *codes = fp->codeBlock; /*sl*/
    // loc_351b3e
    int32_t pc = fp->pc; /*r6*/
    /*r3 codes->buf*/
    int8_t opCode = ((int8_t)(codes->buf[pc]));
    if (opCode > 0xef) {
        // loc_352478
        [NSException raise:@"OCSCommonException" format:@"Invalid Opcode %d", opCode];
    }
    else {
        
        r0: pc + 0x78 + codes->buf[fp->pc] * 4
        r1: codes->buf[fp->pc]
        r2: &@selector(methodReturnType)
        r3: &@selector(methodSignatureForSelector:)
        r4: pc
        r5: &@selector(release)
        r6: codes->buf
        r8: codes
        sl: fp
        fp: vm

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
void
_getObjectIvar(id obj, const char *name, void *stackPointer) {
    
    // r0: ivar
    // r1: name
    // r4: ivar
    // r5: @selector(class)
    // r6: obj
    // r8: arg2
    // sl: name

    Ivar ivar = class_getInstanceVariable([obj class], name);
    if (ivar) {
        // 0035531e

        // r0: ivar
        // r5: offset

        ptrdiff_t offset = ivar_getOffset(ivar);
        const char *type = ivar_getTypeEncoding(ivar);

        switch(type) {
            case '#': // Class
            case '*': // char *
            case ':': // SEL
            case '@': // id
            case '^': // pointer
            {
                // loc_3553aa
                // r0: obj
                // r1: ivar

                id ivarObj = object_getIvar(obj, ivar);
                *(stackPointer + 0x4) = ivarObj;

                // loc_3553ea

            }
                break;
            case 'B': // bool
            case 'C': // usigned char
            {
                // loc_35536c
                // r0: obj + offset
                // int *ivarPtr1 = (int *)((uint8_t *)obj + ivar_getOffset(ivar1));
                // void *pointer = (__bridge void *)object + offset;
                *(stackPointer + 0x4) = (__bridge void *)obj + offset;
                // loc_3553ea
            }
                break;
            case 'I': // unsigned int
            case 'L': // unsigned long
            case 'f': // float
            case 'i': // int
            case 'l': // long
            {
                // loc_355390
                *(stackPointer + 0x4) = (__bridge void *)obj + offset;
                // loc_3553ea
            }
                break;
            case 'Q': // unsigned long long
            case 'q': // long long
            {
                // loc_355380
                // r0: obj + offset
                // r1: obj + offset + 0x4

                *(stackPointer + 0x4) = (__bridge void *)obj + offset;
                *(stackPointer + 0x8) = (__bridge void *)obj + offset + 0x4;

                // loc_3553ea
            }
                break;
            case 'S': // unsigned short
            case 's': // short
            {
                // loc_3553b8
                // r0: obj + offset

                *(stackPointer + 0x4) = (__bridge void *)obj + offset;

                // loc_3553ea

            }
                break;
            case 'c': // char
            {   
                // loc_35536c

                *(stackPointer + 0x4) = (__bridge void *)obj + offset;

                // loc_3553ea

            }
                break;
            case 'd': // double
            {
                // loc_3553e0

                *(stackPointer + 0x4) = (__bridge void *)obj + offset;

                // loc_3553ea
            }
                break;     
            // case 'v': // void
            // {
                
            // }
            //     break;
            // case '{': // struct
            // {
                
            // }
            //     break;
            default:
            {
                // loc_3553c0
                // r0: NSException
                // r1: @selector(raise:format:)
                // r2: @"OCSCommonException"
                // r3: @"unsupported ivar type %s (ivar %s)"
                // r6: NSException
                // var_1C = ivar

                [NSException raise:@"OCSCommonException" format:@"unsupported ivar type %s (ivar %s)", type, ivar]
                
            }
                break;

        }

        /*
            //  0x52
            if (aType > '[') {
                // loc_35534e
                // aType - 0x63
                // v 0x63 + 0x10
                if (aType > 'v') {
                    // loc_355398
                    
                    // S 0x53
                    if (aType == 'S') {
                        // loc_3553b8
                    }
                    // ^ 0x5e
                    if (aType == '^') {
                        // loc_3553aa
                    }
                    // { 0x7b
                    //else if (aType == '{') {
                    //    // loc_355914
                    //}
                    else {
                        // loc_3553c0
                    }
                }
                else {
                    // loc_355356 
                    // aType - 0x63
                    switch (aType) {
                        // tb 0x09
                        case 'c': // 0x63 0
                        {
                            // loc_35536c
                        }
                            break;
                        // tb 0x43
                        case 'd': // 0x64 1
                        {
                            // loc_3553e0
                        }
                            break;
                       // // tb 0x33
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
                       //     // loc_355b90
                       // }
                       //     break;
                        // tb 0x1b
                        case 'f': // 0x66 3
                        {
                            // loc_355390
                        }
                            break;
                        // tb 0x1b
                        case 'i': // 0x69 6
                        {
                            // loc_355390
                        }
                            break;
                        // tb 0x1b
                        case 'l': // 0x6c 9
                        {
                            // loc_355390
                        }
                            break;
                        // tb 0x13
                        case 'q': // 0x71 14
                        {
                            // loc_355380
                        }
                            break;
                        // tb 0x2f
                        case 's': // 0x73 16
                        {
                            // loc_3553b8
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
                // loc_355374
                // 0x50
                if (aType > 0x50) {
                    // loc_35592a
                    // 0x51 Q
                    if (aType == 'Q') {
                        // loc_355380
                    }
                    else {
                        // loc_35597a
                    }
                }
                else {
                    // loc_3558ee
                    // 0x49 I
                    if (aType == 'I') {
                        // loc_355390
                    }
                    // 0x4c L
                    else if (aType == 'L') {
                        // loc_355390
                    }
                    else {
                        // loc_35597a
                    }
                    
                }
            }
            // C 0x43
            else if (aType > 'C') {
                // loc_3553a2
                if (aType == '#') {
                    // loc_3553aa
                }
                else if (aType == '*') {
                    // loc_3553aa
                }
                else {
                    // loc_35597a
                }
            }
            else {
                // loc_355340
                // rType - 0x3a
                switch (aType) {
                    // tb 0x33
                    case ':': // 0x3a 0
                    {
                        // loc_3553aa
                    }
                        break;
                   // // tb 5 dup (0x3e)
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
                   //     // loc_3553c0
                   // }
                        break
                    // tb 0x33
                    case '@': // 0x40
                    {
                        // loc_3553aa
                    }
                        break;
                    // tb 0x14
                    case 'B': // 0x42
                    {
                        // loc_35536c
                    }
                        break;
                    // tb 0x14
                    case 'C': // 0x43
                    {
                        // loc_35536c
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

    }
    else {
        // loc_3553f0
        NSString *reason =
        [NSString stringWithFormat:@"class:%@ cannot find ivar:%s,please check", [cls class], name];
        @throw [[NSException alloc] initWithName:@"OCSCommonException"
                                          reason:reason
                                        userInfo:nil];
    }
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
_setObjectIvar(id obj, const char *name, void *stackPointer, NSString *typeString) {
    // r0: ivar
    // r1: name
    // r4: obj
    // r5: @selector(class)
    // r6: ivar
    // r8: stackPointer
    // sl: name
    // fp: arg3

    Ivar ivar = class_getInstanceVariable([obj class], name);

    if (ivar) {
        // r0: type
        // r5: offset

        ptrdiff_t offset = ivar_getOffset(ivar);
        const char *type = ivar_getTypeEncoding(ivar);

        switch(type) {
            case '#': // Class
            case '*': // char *
            case ':': // SEL
            case '@': // id
            case '^': // pointer
            {
                // loc_355542

                // r0: obj
                // r1: ivar
                // r2: *(stackPointer + 0x4)

                id value = *(stackPointer + 0x4);

                object_setIvar(obj, ivar, value);

            }
                break;
            case 'B': // bool
            case 'C': // usigned char
            case 'c': // char
            {
                // loc_3554ea

                // r0: *(stackPointer + 0x4)
                (__bridge void *)obj + offset = *(stackPointer + 0x4);
                // loc_355596

            }
                break;
            case 'I': // unsigned int
            case 'L': // unsigned long
            case 'f': // float
            case 'i': // int
            case 'l': // long
            {
                // loc_3554fe
                (__bridge void *)obj + offset = *(stackPointer + 0x4);
                // loc_355596
            }
                break;
            case 'Q': // unsigned long long
            case 'd': // double
            case 'q': // long long
            {
                // loc_355568
                // r0: (__bridge void *)obj + offset
                // d16: *(stackPointer + 0x4)

                (__bridge void *)obj + offset = *(stackPointer + 0x4);

                // loc_355596

            }
                break;
            case 'S': // unsigned short
            case 's': // short
            {
                // loc_355560
                (__bridge void *)obj + offset = *(stackPointer + 0x4);

                // loc_355596
            }
                break;
            // case 'v': // void
            // {
                
            // }
            //     break;
            case '{': // struct
            {
                // loc_35550e
                // r0: (__bridge void *)obj + offset
                // r1: *(*(stackPointer + 0x4) + 0x8)
                // r2: [ts totalSize]
                // r5: offset
                // r6: *(*(stackPointer + 0x4) + 0x8)

                ptrdiff_t offset = ivar_getOffset(ivar);
                OCS_StructType *st = OCSGetStructType(typeString);

                size_t size = [st->typeStruct totalSize];
                void *dst = (__bridge void *)obj + offset;
                const void *src = *(*(stackPointer + 0x4) + 0x8);

                memcpy(dst, src, size);

                // loc_355596

            }
                break;
            default:
            {
                // loc_355578
                // r1: @selector(raise:format:)
                // r2: @"OCSCommonException"
                // r3: objc_cls_ref_NSException
                // r6: NSException

                [NSException raise:@"OCSCommonException" format:@"unsupported ivar type %s (self %s)", type, name];
            }
                break;

        }

        /*
            // [ 0x5d
            if (aType > '[') {
                // loc_3554cc
                // aType - 0x63
                // v 0x63 + 0x10
                // 0x73
                if (aType > 0x73) {
                    // loc_355506
                    
                    // ^ 0x5e
                    if (aType == '^') {
                        // loc_355542
                    }
                    // { 0x7b
                    else if (aType == '{') {
                        // loc_35550e
                    }
                    else {
                        // loc_355578
                    }
                }
                else {
                    // loc_3554d4

                    // aType - 0x63
                    switch (aType) {
                        // tb 0x09
                        case 'c': // 0x63 0
                        {
                            // loc_3554ea
                        }
                            break;
                        // tb 0x48
                        case 'd': // 0x64 1
                        {
                            // loc_355568
                        }
                            break;
                       // // tb 0x50
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
                       //     // loc_355578
                       // }
                       //     break;
                        // tb 0x13
                        case 'f': // 0x66 3
                        {
                            // loc_3554fe
                        }
                            break;
                        // tb 0x13
                        case 'i': // 0x69 6
                        {
                            // loc_3554fe
                        }
                            break;
                        // tb 0x13
                        case 'l': // 0x6c 9
                        {
                            // loc_3554fe
                        }
                            break;
                        // tb 0x48
                        case 'q': // 0x71 14
                        {
                            // loc_355568
                        }
                            break;
                        // tb 0x44
                        case 's': // 0x73 16
                        {
                            // loc_355560
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
                // loc_3554f2
                // 0x50
                if (aType > 0x50) {
                    // loc_355558
                    // 0x51 Q
                    if (aType == 'Q') {
                        // loc_355568
                    }
                    // 0x53 S
                    else if (aType == 'S') {
                        // loc_355560
                    }
                    else {
                        // loc_35597a
                    }
                }
                else {
                    // loc_3558ee
                    // 0x49 I
                    if (aType == 'I') {
                        // loc_3554fe
                    }
                    // 0x4c L
                    else if (aType == 'L') {
                        // loc_3554fe
                    }
                    else {
                        // loc_355578
                    }
                    
                }
            }
            // C 0x43
            else if (aType > 'C') {
                // loc_35553a
                if (aType == '#') {
                    // loc_355542
                }
                else if (aType == '*') {
                    // loc_355542
                }
                else {
                    // loc_35597a
                }
            }
            else {
                // loc_3554be
                // rType - 0x3a
                switch (aType) {
                    // tb 0x40
                    case ':': // 0x3a 0
                    {
                        // loc_355542
                    }
                        break;
                   // // tb 5 dup (0x3b)
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
                   //     // loc_355578
                   // }
                   //     break
                    // tb 0x40
                    case '@': // 0x40
                    {
                        // loc_355542
                    }
                        break;
                    // tb 0x14
                    case 'B': // 0x42
                    {
                        // loc_3554ea
                    }
                        break;
                    // tb 0x14
                    case 'C': // 0x43
                    {
                        // loc_3554ea
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
    }
    else {
        // loc_35559c

        // r0: [NSException alloc]
        // r1: @selector(initWithName:reason:userInfo:)
        // r2: @"OCSCommonException"
        // r3: reason
        // r4: reason
        // r6: NSString
        // 0x0

        NSString *reason = [NSString stringWithFormat:@"class:%@ cannot find ivar:%s,please check", [obj class], name];
        @throw [[NSException alloc] initWithName:@"OCSCommonException" reason:reason userInfo:nil];
    }

}

void
_getObjectStructIvar(OCS_VirtualMachine *vm, id obj, const char *name, NSString *structTypeStr, OCSStrucValueType eValueType, void *stackPointer) {

    // r0: [obj class]
    // r1: name
    // r5: @selector(class)
    // r6: obj
    // r8: vm
    // sl: arg3
    // fp: name

    Ivar ivar = class_getInstanceVariable([obj class], name);

    if (ivar) {
        // r0: type

        const char *type = ivar_getTypeEncoding(ivar);

        NSCAssert(type == '{', @"NO && \"IVar must be Struct Type, for scalar type, use _getObjectIvar instead.\"");

        // r0: arg3
        // r1: dst
        // r4: ivar
        // r5: eValueType
        // fp: arg5

        ptrdiff_t offset = ivar_getOffset(ivar);

        const void *data = (__bridge void *)obj + offset;

        OCS_Struct *st;
        if (eValueType == OCSStrucValueTypeL) {
            st = OCSCreateLValueStruct(structTypeStr, data);
        }
        else {
            st = OCSCreateRValueStructWithData(structTypeStr, data);
        }

        // r0: vm
        // r1: st
        // r4: st

        _virtualMachineRegisterCStruct(vm, st);
        
        *(stackPointer) = 0x11;
        *(stackPointer + 0x4) = st;

    }
    else {
        // loc_35568e
        NSString *reason = [NSString stringWithFormat:@"class:%@ cannot find ivar:%s,please check", [obj class], name];
        @throw [[NSException alloc] initWithName:@"OCSCommonException" reason:reason userInfo:nil];
    }
}

// sub_2a11474
// in JSPatch
// static id callSelector(NSString *className, NSString *selectorName, JSValue *arguments, JSValue *instance, BOOL isSuper)
void
_messageSendN(int arg0, OCS_VirtualMachine *vm, id target, SEL selector, BOOL isSuper, OCS_Param *paraList, NSString *arg6) {
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
        
        NSUInteger numberOfArguments = signature.numberOfArguments;

        // loc_355868
        for (NSUInteger index = 2; index < numberOfArguments; index++) {
            const char *argType = [signature getArgumentTypeAtIndex:index];
            char aType = argType[0] == 'r' ? argType[1] : argType[0];
            int argIdx = index - 2;

            OCSValueTag eValueTag = paraList[argIdx].vTag;

            switch(aType) {
                case '#': // Class
                case '*': // char *
                case ':': // SEL
                case '@': // id
                case '^': // pointer

                {
                    // loc_355956

                    // r0: arg5->0x4

                    // loc_35595a
                    // var_28: arg5->0x4
                    var_28 = paraList[argIdx].arg;

                    // loc_355aa0

                }
                    break;
                case 'B': // bool
                {
                    // loc_35589a
                    // r0: 0x0
                    // var_28: 0x0
                    if (eValueTag == OCSVTagChar) {
                        // r0: arg5[argIdx]->0x4
                        // if (paraList[argIdx].arg) {
                        //     r0: 1
                        // }
                        // else {
                        //     r0: 0
                        // }
                        // loc_3559fe
                        var_28 = paraList[argIdx].arg;
                    }
                    else {
                        // loc_3559f8
                        // loc_3559fe
                        var_28 = _dynamicCastToBool(paraList[argIdx]);
                    }
                    // loc_355aa0

                }
                    break;
                case 'C': // usigned char
                case 'c': // char
                {
                    // loc_3558d4
                    // r0: 0x0
                    // var_28: 0x0

                    if (eValueTag == OCSVTagUChar || eValueTag == eValueTag) {
                        var_28 = paraList[argIdx].arg;
                    }
                    else {
                        var_28 = _dynamicCastToChar(paraList[argIdx]);
                    }
                    // loc_3559fe
                    // loc_355aa0
                }
                    break;
                case 'I': // unsigned int
                case 'i': // int
                {
                    // loc_355948
                    if (eValueTag == OCSVTagUInt || eValueTag == OCSVTagInt) {
                        var_28 = paraList[argIdx].arg;
                    }
                    else {
                        var_28 = _dynamicCastToInt(paraList[argIdx].arg);
                    }
                }
                    break;
                case 'L': // unsigned long
                case 'l': // long
                {
                    // loc_3558f6
                    if (eValueTag == OCSVTagULong || eValueTag == OCSVTagLong) {
                        var_28 = paraList[argIdx].arg;
                    }
                    else {
                        var_28 = _dynamicCastToLong(paraList[argIdx].arg)
                    }
                }
                    break;
                case 'Q': // unsigned long long
                case 'q': // long long
                {
                    // loc_35595e
                    // r0: paraList[argIdx].vTag
                    // var_28 = 0x0 0x0
                    // r1: paraList[argIdx].vTag  - 0x9
                    if (eValueTag == OCSVTagULongLong || eValueTag == OCSVTagLongLong) {
                        // r0: paraList[argIdx].arg
                        // r1: paraList[argIdx].arg
                        // loc_355a9c
                    }
                    else {
                        // loc_3559d2
                        // r0: 0x0
                        // r2: paraList[argIdx].vTag - 0x1
                        // r3: (paraList[argIdx].vTag  - 0x1) * 0x5
                        // r1: 0x0

                        switch(paraList[argIdx].vTag) {
                            // tb 2 dup (0x22)
                            case OCSVTagChar: // 0x1
                            case OCSVTagUChar: // 0x2
                            {
                                // loc_355a28
                                r1 = paraList[argIdx].arg >> 0x1f
                                // loc_355a9c
                            }
                                break;
                            // tb 2 dup (0x26)
                            case OCSVTagShort: // 0x3
                            case OCSVTagUShort: // 0x4
                            {
                                // loc_355a30
                                r1 = paraList[argIdx].arg >> 0x1f
                                // loc_355a9c
                            }
                                break;
                            // tb 4 dup (0x06)
                            case OCSVTagInt: // 0x5
                            case OCSVTagUInt: // 0x6
                            case OCSVTagLong: // 0x7
                            case OCSVTagULong: // 0x8
                            {
                                // loc_3559f0
                                r1 = paraList[argIdx].arg >> 0x1f
                                // loc_355a9c
                            }
                                break;
                            // tb 2 dup (0x5c)
                            case OCSVTagLongLong: // 0x9
                            case OCSVTagULongLong: // 0xa
                            {
                                // loc_355a9c
                            }
                                break;
                            // tb 0x2a
                            case OCSVTagFloat: // 0xb
                            {
                                // loc_355a38
                                _fixsfdi(paraList[argIdx].arg);
                                // loc_355a9c
                            }
                                break;
                            // tb 0x54
                            case OCSVTagDouble: // 0xc
                            {
                                // loc_355a8c
                                r0: paraList[argIdx].arg & 0xffff
                                r1: paraList[argIdx].arg >> 0x10
                                _fixdfdi(paraList[argIdx].arg & 0xffff);
                                // loc_355a9c
                            }
                                break;
                            default:
                            {
                                // loc_355a9a
                                r1: 0x0
                                // loc_355a9c
                            }
                                break;
                            
                        }

                    }

                    // strd       r0, r1, [sp, #0x48 + var_28]  
                    var_28 = ??;
                    // loc_355aa0
                }
                    break;
                case 'S': // unsigned short
                case 's': // short
                {
                    // loc_355932
                    if (eValueTag == OCSVTagUShort || eValueTag == OCSVTagShort) {
                        var_28 = paraList[argIdx].arg;
                        // loc_3559be
                        // loc_355aa0

                    }
                    else {
                        // loc_3559c4
                        var_28 = _dynamicCastToShort(paraList[argIdx].arg)
                        // loc_3559c4
                    }
                }
                    break;
                case 'd': // double
                {
                    // loc_355998
                    if (paraList[argIdx].vTag == OCSVTagDouble) {
                        var_28 = paraList[argIdx].arg;
                    }
                    else {
                        var_28 = _dynamicCastToDouble(paraList[argIdx].arg);
                    }
                }
                    break;
                case 'f': // float
                {
                    // loc_3559ac
                    if (paraList[argIdx].vTag == OCSVTagFloat) {
                        var_28 = paraList[argIdx].arg;
                        // loc_355a1e
                    }
                    else {
                        // loc_355a18
                        var_28 = _dynamicCastToFloat(paraList[argIdx].arg);
                        // loc_355a1e
                    }
                }
                    break;
                // case 'v': // void
                // {
                // }
                //     break;
                case '{': // struct
                {
                    // loc_355914
                    // r0: invocation
                    // r1: @selector(setArgument:atIndex:)
                    // r2: st.value

                    OCS_Struct* st = paraList[argIdx].arg;
                    // st.value
                    var_28 = st.value;
                }
                    break;
                default:
                {
                    // loc_35597a
                    [NSException raise:@"OCSCommonException" format:@"Unsupported argument type: %s", argType];
                    // loc_355850

                    // r0: @class(NSException)        
                    // r1: @selector(raise:format:)
                    // r2: @"OCSCommonException"
                    // r3: @"Unsupported argument type: %s"
                    // var_48: argType

                }
                    break;

            }

            // loc_355aa0
            // r0: invocation
            // r1: @selector(setArgument:atIndex:)
            // r2: var_28

            // loc_355aa6
            // r3: index
            // loc_355850
            [invocation setArgument:var_28 atIndex:index];

            // loc_35585a

        /*
            // [ 0x5d
            if (aType > '[') {
                // loc_3558b6
                // aType - 0x63
                // v 0x63 + 0x13
                if (aType > 'v') {
                    // loc_35590c
                    
                    // ^ 0x5e
                    if (aType == '^') {
                        // loc_355956
                    }
                    // { 0x7b
                    else if (aType == '{') {
                        // loc_355914
                    }
                    else {
                        // loc_35597a
                    }
                }
                else {
                    // loc_3558be 
                    // aType - 0x63
                    switch (aType) {
                        // tb 0x09
                        case 'c': // 0x63 0
                        {
                            // loc_3558d4
                        }
                            break;
                        // tb 0x6b
                        case 'd': // 0x64 1
                        {
                            // loc_355998
                        }
                            break;
                       // // tb 0x5c
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
                       //     // loc_355b90
                       // }
                       //     break;
                        // tb 0x75
                        case 'f': // 0x66 3
                        {
                            // loc_3559ac
                        }
                            break;
                        // tb 0x43
                        case 'i': // 0x69 6
                        {
                            // loc_355948
                        }
                            break;
                        // tb 0x1a
                        case 'l': // 0x6c 9
                        {
                            // loc_3558f6
                        }
                            break;
                        // tb 0x4e
                        case 'q': // 0x71 14
                        {
                            // loc_35595e
                        }
                            break;
                        // tb 0x38
                        case 's': // 0x73 16
                        {
                            // loc_355932
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
                // loc_3558ea
                // 0x50
                if (aType > 0x50) {
                    // loc_35592a
                    // 0x51 Q
                    if (aType == 'Q') {
                        // loc_35595e
                    }
                    // 0x53 S
                    else if (aType == 'S') {
                        // loc_355932
                    }
                    else {
                        // loc_35597a
                    }
                }
                else {
                    // loc_3558ee
                    // 0x49 I
                    if (aType == 'I') {
                        // loc_355948
                    }
                    // 0x4c L
                    else if (aType == 'L') {
                        // loc_3558f6
                    }
                    else {
                        // loc_35597a
                    }
                    
                }
            }
            // C 0x43
            else if (aType > 'C') {
                // loc_355920
                if (aType == '#') {
                    // loc_355956
                }
                else if (aType == '*') {
                    // loc_355956
                }
                else {
                    // loc_35597a
                }
            }
            else {
                // loc_35588c
                // rType - 0x3a
                switch (aType) {
                    // tb 0x63
                    case ':': // 0x3a 0
                    {
                        // loc_355956
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
                   //     // loc_355b90
                   // }
                   //     break
                    // tb 0x63
                    case '@': // 0x40
                    {
                        // loc_355956
                    }
                        break;
                    // tb 0x05
                    case 'B': // 0x42
                    {
                        // loc_35589a
                    }
                        break;
                    // tb 0x22
                    case 'C': // 0x43
                    {
                        // loc_3558d4
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

        }

        // loc_355aaa
        [invocation invoke];
        const char *returnType = [methodSignature methodReturnType];
        // r 0x72
        char rType = returnType[0] == 'r' ? returnType[1] : returnType[0];

        int eType = 0;

        switch(rType) {
            case '#': // Class
            {
                // loc_355c24
                eType = 0xd;
                // loc_355c32

                // r2: (sp+0x20)OR 0x4
                [invocation getReturnValue:];
                // loc_355c42

            }
                break;
            case '*': // char *
            {
                // loc_355b78
                // r4: (sp+0x20)OR 0x4
                // loc_355bd2
                eType = 0x10;
                // r2: (sp+0x20)OR 0x4
                [invocation getReturnValue:];
                // loc_355c42
            }
                break;
            case ':': // SEL
            {
                // loc_355afe
                eType = 0xf;
                // loc_355c32
                // r2: (sp+0x20)OR 0x4
                [invocation getReturnValue:];
                // loc_355c42
            }
                break;
            case '@': // id
            {
                // loc_355baa
                eType = 0xe;
                // loc_355c32
                // r2: (sp+0x20)OR 0x4
                [invocation getReturnValue:];
                // loc_355c42
            }
                break;
            case 'B': // bool
            {
                // loc_355b26
                eType = 0x1;
                // loc_355c32
                // r2: (sp+0x20)OR 0x4
                [invocation getReturnValue:];
                // loc_355c42
            }
                break;
            case 'C': // usigned char
            {
                // loc_355bb2
                eType = 0x2;
                // loc_355c32
                // r2: (sp+0x20)OR 0x4
                [invocation getReturnValue:];
                // loc_355c42
            }
                break;
            case 'I': // unsigned int
            {
                // loc_355c14
                eType = 0x6;
                // loc_355c32
                // r2: (sp+0x20)OR 0x4
                [invocation getReturnValue:];
                // loc_355c42
            }
                break;
            case 'L': // unsigned long
            {
                // loc_355b3a
                eType = 0x8;
                // loc_355c32
                // r2: (sp+0x20)OR 0x4
                [invocation getReturnValue:];
                // loc_355c42
            }
                break;
            case 'Q': // unsigned long long
            {
                // loc_355c1c
                eType = 0xa;
                // r2: (sp+0x20)OR 0x4
                [invocation getReturnValue:];
            }
                break;
            case 'S': // unsigned short
            {
                // loc_355b88
                eType = 0x4;
                // loc_355c32
                // r2: (sp+0x20)OR 0x4
                [invocation getReturnValue:];
                // loc_355c42
            }
                break;

            case '^': // pointer
            {
                // loc_355c2c
                eType = 0x10;
                // loc_355c32
                // r2: (sp+0x20)OR 0x4
                [invocation getReturnValue:];
                // loc_355c42
            }
                break;
            case 'c': // char
            {
                // loc_355b26
                eType = 0x1;
                // r2: (sp+0x20)OR 0x4
                [invocation getReturnValue:];
                // loc_355c42

            }
                break;
            case 'd': // double
            {
                // loc_355bba
                eType = 0xc;
                // r2: (sp+0x20)OR 0x4
                [invocation getReturnValue:];
            }
                break;
            case 'f': // float
            {
                // loc_355be6
                eType = 0xb;
                // loc_355c32
                // r2: (sp+0x20)OR 0x4
                [invocation getReturnValue:];
                // loc_355c42
            }
                break;
            case 'i': // int
            {
                // loc_355bee
                eType = 0x5;
                // loc_355c32
                // r2: (sp+0x20)OR 0x4
                [invocation getReturnValue:];
                // loc_355c42
            }
                break;
            case 'l': // long
            {
                // loc_355bf6
                eType = 0x7;
                // loc_355c32
                // r2: (sp+0x20)OR 0x4
                [invocation getReturnValue:];
                // loc_355c42
            }
                break;
            case 'q': // long long
            {
                // loc_355bfe
                eType = 0x9;
                // loc_355c32
                // r2: (sp+0x20)OR 0x4
                [invocation getReturnValue:];
                // loc_355c42
            }
                break;
            case 's': // short
            {
                // loc_355c06
                eType = 0x3;
                // loc_355c32
                // r2: (sp+0x20)OR 0x4
                [invocation getReturnValue:];
                // loc_355c42
            }
                break;
            case 'v': // void
            {
                // loc_355c0e
                eType = 0;
                // loc_355c42
            }
                break;
            case '{': // struct
            {
                // loc_355b46
                eType = 0x11;
                OCS_Struct *st = OCSCreateRValueStruct(arg6);
                [invocation getReturnValue:st->value];
                _virtualMachineRegisterCStruct(vm, st);
            }
                break;
            default:
            {
                // loc_355b90
                [NSException raise:@"OCSCommonException" format:@"Unsupported return type: %s", rType];
            }
                break;

        }

    /*
        // [ 0x5d
        if (rType > '[') {
            // loc_355b06
            // rType - 0x63
            // v 0x63 + 0x13
            if (rType > 'v') {
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
                    // loc_355b90
                    [NSException raise:@"OCSCommonException" format:@"Unsupported return type: %s", rType];
                }
            }
            else {
                // loc_355b0e
                // rType - 0x63
                switch (rType) {
                    // tb 0x0a
                    case 'c': // 0x63 0
                    {
                        // loc_355b26
                    }
                        break;
                    // tb 0x54
                    case 'd': // 0x64 1
                    {
                        // loc_355bba
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
                   //     // loc_355b90
                   // }
                   //     break;
                    // tb 0x6a
                    case 'f': // 0x66 3
                    {
                        // loc_355be6
                    }
                        break;
                    // tb 0x6e
                    case 'i': // 0x69 6
                    {
                        // loc_355bee
                    }
                        break;
                    // tb 0x72
                    case 'l': // 0x6c 9
                    {
                        // loc_355bf6
                    }
                        break;
                    // tb 0x76
                    case 'q': // 0x71 14
                    {
                        // loc_355bfe
                    }
                        break;
                    // tb 0x7a
                    case 's': // 0x73 16
                    {
                        // loc_355c06
                    }
                        break;
                    // tb 0x7e
                    case 'v': // 0x76 19
                    {
                        // loc_355c0e
                    }
                        break;
                    default:
                    {
                        // loc_355b90
                    }
                        break;
                }
            }
        }
        // H 0x48
        else if (rType > 'H') {
            // loc_355b2e
            // 0x50
            if (rType > 0x50) {
                // loc_355b80
                // 0x51 Q
                if (rType == 'Q') {
                    // loc_355c1c
                }
                // 0x53 S
                else if (rType == 'S') {
                    // loc_355b88
                }
                else {
                    // loc_355b90
                }
            }
            else {
                // loc_355b32
                // 0x49 I
                if (rType == 'I') {
                    // loc_355c14
                }
                // 0x4c L
                else if (rType == 'L') {
                    // loc_355b3a
                }
                else {
                    // loc_355b90
                }
                
            }
        }
        // C 0x43
        else if (rType > 'C') {
            // loc_355b70
            if (rType == '#') {
                // loc_355c24
            }
            else if (rType == '*') {
                // loc_355b78
            }
            else {
                // loc_355b90
            }
        }
        else {
            // loc_355af0
            // rType - 0x3a
            switch (rType) {
                // tb 0x05
                case ':': // 0x3a 0
                {
                    // loc_355afe
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
               //     // loc_355b90
               // }
               //     break
                // tb 0x5b
                case '@': // 0x40
                {
                    // loc_355baa
                }
                    break;
                // tb 0x19
                case 'B': // 0x42
                {
                    // loc_355b26
                }
                    break;
                // tb 0x5f
                case 'C': // 0x43
                {
                    // loc_355bb2
                }
                    break;
                default:
                {
                    // loc_355b90
                }
                    break;
            }
        }
    */

        // loc_355c42
        return ??;

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
OCSRunWithParaList(NSString *className, NSString *methodName, OCS_ReturnValue * returnVal, OCS_Param* argList) {
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
