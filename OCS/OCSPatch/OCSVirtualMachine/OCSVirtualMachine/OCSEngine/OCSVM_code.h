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
    CFMutableDictionaryRef dictCodes;// +0x10
    void *methodNames; // +0xc
    CFStringRef fileName; // +0x14
    CFStringRef clsName; // +0x18
} OCS_Executable ; // 0x1c

typedef struct {
    size_t codeSize; // +0x0
    void *buf; // +0x4
    int32_t constPoolCount; // +0x8
    OCS_ConstantPool *constPool; // +0xc
    int32_t localVarCount;  // +0x10
    int32_t stackSize; // +0x14
    CFStringRef methodSignature; // +0x18
} OCS_CodeBlock; // 0x1c

typedef struct OCS_VirtualMachine_t {
    void* currentFrame; // +0x0
    // +0xc
    CFTypeRef name;// +0x1c
} OCS_VirtualMachine;


static void *OCSExecutableManagerLoadDataCallback_fun; // *0x35d3dc0
static const struct mach_header* image_header; //*0x35d3dc8;
static NSUInteger int_35d3dcc; //*0x35d3dcc;

static CFMutableDictionaryRef dictExecutables; // *0x367d1f0  <executableName, OCS_Executable*>
static dispatch_queue_t OCSExecutableManagerReadWriteQueue; // *0x367d1f4
static CFMutableDictionaryRef dictClassNameTables; // *0x367d1f8 <className, OCS_Executable*>
static dispatch_queue_t exeClassNameTablesQueue; // *0x367d1fc
static NSCache *cache; // *0x367d200

static CFMutableDictionaryRef dictCFunction; // *0x367d208
static CFMutableDictionaryRef dict_367d20c; // *0x367d20c
static CFMutableDictionaryRef dict_367d210; // *0x367d210
static dispatch_queue_t structTypeDictReadWriteQueue;// *0x367d21c
static CFMutableDictionaryRef dictStructType; // *0x367d220
static dispatch_queue_t cInvokeReadWriteQueue; // *0x367d214

static NSMutableDictionary *dictClsMethodName; // *0x367d22c
static dispatch_queue_t classMethodNameReadWriteQueue; // *00x367d228
static NSMutableDictionary *dict3; // *0x367d234
static dispatch_queue_t classExecutableRootReadWriteQueue; // *0x367d230

// sub_2a137d4
OCS_Executable*
OCSExecutableCreate(NSString *fileName, NSData *data, NSUInteger* errorCode);

#endif /* OCSVM_code_h */
