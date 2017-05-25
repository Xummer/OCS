//
//  OCSVM_code.h
//  OCS
//
//  Created by Xummer on 2017/5/13.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#ifndef OCSVM_code_h
#define OCSVM_code_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <objc/objc.h>

typedef enum {
    OCS_CONSTANT_0 = 1,
    OCS_CONSTANT_1,
    OCS_CONSTANT_2,
    OCS_CONSTANT_3,
    OCS_CONSTANT_4,
    OCS_CONSTANT_CLASS,
    OCS_CONSTANT_SEL,
    OCS_CONSTANT_PROTOCOL,
    OCS_CONSTANT_8,
} OCS_ConstantPoolTag;

typedef struct OCS_String_t {
    CFStringRef value;
    int32_t     offset;
} OCS_String;

typedef struct OCS_Class_t {
    Class       value;
    int32_t     offset;
} OCS_Class;

typedef struct OCS_SEL_t {
    SEL         value;
    int32_t     offset;
} OCS_SEL;

typedef struct OCS_Protocol_t {
    __unsafe_unretained Protocol*   value;
    int32_t     offset;
} OCS_Protocol;

typedef struct OCS_Char_t {
    char*       value;
    int32_t     offset;
} OCS_Char;

typedef struct OCS_Struct_t {
    int8_t _0x4; // +0x4
    void* _0x8; // +0x8
} OCS_Struct;

typedef struct {
    OCS_ConstantPoolTag tag;
    union {
        int             c_int;
        long            c_long;
        float           c_float;
        double          c_double;
        OCS_String*     c_string;
        OCS_Class*      c_class;
        OCS_SEL*        c_sel;
        OCS_Protocol*   c_protocol;
        OCS_Char*       c_cString;
    } u;
} OCS_ConstantPool;

typedef struct OCS_Executable_t {
    int32_t constPoolCount; // +0x0
    OCS_ConstantPool *constPool; // +0x4
    size_t size; // +0x8
    void *methodNames; // +0xc
    CFMutableDictionaryRef dictCodes;// +0x10 // <CFString, OCS_CodeBlock*>
    CFStringRef fileName; // +0x14
    CFStringRef clsName; // +0x18
} OCS_Executable ; // 0x1c

typedef struct {
    size_t codeSize; // +0x0
    const char *buf; // +0x4
    int32_t constPoolCount; // +0x8
    OCS_ConstantPool *constPool; // +0xc
    int32_t localVarCount;  // +0x10     |64 +0x20
    int32_t stackSize; // +0x14     |64 +0x30
    CFStringRef method; // +0x18  -|initWithModel:param:|@@:@@
} OCS_CodeBlock; // 0x1c

typedef struct OCS_StackBlock_t {
    struct OCS_StackBlock_t *prev; // +0x0
    struct OCS_StackBlock_t *next; // +0x4
    int32_t allocSize; // +0x8     |64 +0x10
    void* stack;// +0xc
} OCS_StackBlock;

typedef struct OCS_Frame_t {
    struct OCS_Frame_t *back; // +0x0
    // +0x4
    int32_t pc; // class +0x8   |64 +0x10
    OCS_CodeBlock *codeBlock; // +0xc   |64 +0x18
    OCS_Class *cls; // +0x10    |64 +0x20
    CFArrayRef _0x14; // +0x14;
    CFArrayRef arrCStruct; // +0x18 CStruct
} OCS_Frame; // 0x39c

typedef struct OCS_VirtualMachine_t {
    OCS_Frame* currentFrame; // +0x0
    int32_t stackPointer; // +0x4     |64 +0x8
    OCS_StackBlock* stackBlock; // +0x8     |64 +0x18
    OCS_StackBlock* _0xc; // +0xc     |64
    int32_t stackSize; // +0x10     |64
    int32_t state; // +0x14     |64 +0x28
    pthread_t thread; // +0x18     |64
    CFStringRef exptionCallStackInfo; // +0x1c     |64
} OCS_VirtualMachine; // 0x20


static void *OCSExecutableManagerLoadDataCallback_fun; // *0x35d3dc0
static const struct mach_header* image_header; //*0x35d3dc8;
static NSUInteger int_35d3dcc; //*0x35d3dcc;

static CFMutableDictionaryRef dictExecutables; // *0x367d1f0  <executableName, OCS_Executable*>
static dispatch_queue_t OCSExecutableManagerReadWriteQueue; // *0x367d1f4
static CFMutableDictionaryRef dictClassNameTables; // *0x367d1f8 <className, <CFMutableArrayRef>OCS_Executable*>
static dispatch_queue_t exeClassNameTablesQueue; // *0x367d1fc
static NSCache *codeBlockCache; // *0x367d200 <className, OCS_CodeBlock*>

static CFMutableDictionaryRef dictCFunction; // *0x367d208
static CFMutableDictionaryRef dict_367d20c; // *0x367d20c
static CFMutableDictionaryRef dict_367d210; // *0x367d210
static dispatch_queue_t structTypeDictReadWriteQueue;// *0x367d21c
static CFMutableDictionaryRef dictStructType; // *0x367d220
static dispatch_queue_t cInvokeReadWriteQueue; // *0x367d214

static NSMutableDictionary *OCSOverrideClsMethodNameDic; // *0x367d22c <NSString * className, <NSMutableDictionary *> overrideMethods>
static dispatch_queue_t classMethodNameReadWriteQueue; // *00x367d228
static NSMutableDictionary *classExecutableRoot; // *0x367d234 <NSString * filePath, NSString * rootPath>
static dispatch_queue_t classExecutableRootReadWriteQueue; // *0x367d230

// sub_2a0bac0
OCS_CodeBlock *
OCSGetCodeBlock(NSString *clsName, NSString *arg1);

// sub_2a0bdee
OCS_VirtualMachine*
OCSVirtualMachineCreate();

// sub_2a0be22
void
OCSVirtualMachineDestroy(OCS_VirtualMachine* vm);

// sub_2a0be9c
void
OCSVirtualMachineAttachThread(OCS_VirtualMachine *vm, pthread_t thread);

// sub_2a0b75c
OCS_Executable*
OCSGetExecutable(NSString *executableName, NSUInteger *errorCode);

// sub_2a11118
void
OCSDestroyStruct(OCS_Struct *s, void *context);

// sub_2a137d4
OCS_Executable*
OCSExecutableCreate(NSString *fileName, NSData *data, NSUInteger* errorCode);

// sub_2a13760
void
OCSSetUpCFuncEnvironment();

// sub_2a13790
id
OCSGetCurrentThreadVMExptionCallStackInfo();

// sub_2a13fb4
NSData *
OCSGetExecutableData(NSString *fileName);

// sub_2a1514a
OCS_VirtualMachine*
OCSGetCurrentThreadVirtualMachine();



#endif /* OCSVM_code_h */
