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
#import "OCSNativeCStruct.h"
#import "OCSTypeStruct.h"

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

typedef struct OCS_StructType_t {
    int32_t _0x0; 
    __unsafe_unretained OCSTypeStruct *typeStruct; // +0x4 | 64 +0x8
} OCS_StructType;

typedef NS_ENUM(NSUInteger, OCSStrucValueType) {
    OCSStrucValueTypeR = 0, // Deep Copy
    OCSStrucValueTypeL,     // Reffence
};

typedef struct OCS_Struct_t {
    OCS_StructType      *structType; // +0x0
    OCSStrucValueType   type; // +0x4
    void *              value; // +0x8 | 64 +0x10
} OCS_Struct; // +0xc

/*
enum _NSObjCValueType {
    NSObjCNoType = 0,
    NSObjCVoidType = 'v',
    NSObjCCharType = 'c',
    NSObjCShortType = 's',
    NSObjCLongType = 'l',
    NSObjCLonglongType = 'q',
    NSObjCFloatType = 'f',
    NSObjCDoubleType = 'd',
    NSObjCBoolType = 'B',
    NSObjCSelectorType = ':',
    NSObjCObjectType = '@',
    NSObjCStructType = '{',
    NSObjCPointerType = '^',
    NSObjCStringType = '*',
    NSObjCArrayType = '[',
    NSObjCUnionType = '(',
    NSObjCBitfield = 'b'
} API_DEPRECATED("Not supported", macos(10.0,10.5), ios(2.0,2.0), watchos(2.0,2.0), tvos(9.0,9.0));
 */

typedef NS_ENUM(NSUInteger, OCSValueTag) {
    OCSVTagVoid = 0,    // 0x0 'v'
    OCSVTagChar,        // 0x1 'c'
    OCSVTagUChar,       // 0x2 'C' 'B'
    OCSVTagShort,       // 0x3 's'
    OCSVTagUShort,      // 0x4 'S'
    OCSVTagInt,         // 0x5 'i'
    OCSVTagUInt,        // 0x6 'I'
    OCSVTagLong,        // 0x7 'l'
    OCSVTagULong,       // 0x8 'L'
    OCSVTagLongLong,    // 0x9 'q'
    OCSVTagULongLong,   // 0xa 'Q'
    OCSVTagFloat,       // 0xb 'f'
    OCSVTagDouble,      // 0xc 'd'
    OCSVTagClass,       // 0xd '#'
    OCSVTagID,          // 0xe '@'
    OCSVTagSel,         // 0xf ':'
    OCSVTagPointer,     // 0x10 '*' '^'
    OCSVTagStruct,      // 0x11 '{'
};

//typedef struct OCS_Value_t {
//    OCSValueTag vTag; //
//    OCS_Struct* arg; // +0x4 |64 + 0x8
//    // +0x8
//} OCS_Value;

typedef struct {
    OCSValueTag type;
    union {
        char charValue;
        short shortValue;
        long longValue;
        long long longlongValue;
        float floatValue;
        double doubleValue;
        bool boolValue;
        SEL selectorValue;
        id objectValue;
        void *pointerValue;
        void *structLocation;
        char *cStringLocation;
    } value; // +0x4 |64 + 0x8
} OCS_ObjCValue;

typedef struct OCS_ReturnValue_t {
    char typeEncode; // +0x0
    void *value;
} OCS_ReturnValue;

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
} OCS_ConstantPool; // |64 0x18

typedef struct OCS_Executable_t {
    int32_t constPoolCount; // +0x0
    OCS_ConstantPool *constPool; // +0x4    |65 +0x8
    size_t size; // +0x8    |64 +0x10
    void *methodNames; // +0xc  |65 +0x18
    CFMutableDictionaryRef dictCodes;// +0x10 // <CFString, OCS_CodeBlock*>
    CFStringRef fileName; // +0x14  |64 + 0x26
    CFStringRef clsName; // +0x18
} OCS_Executable ; // 0x1c

typedef struct {
    size_t codeSize; // +0x0
    const char *buf; // +0x4    |64 +0x8
    int32_t constPoolCount; // +0x8
    OCS_ConstantPool *constPool; // +0xc |64 +0x18
    int32_t localVarCount;  // +0x10     |64 +0x20
    int32_t stackSize; // +0x14     |64 +0x28
    CFStringRef method; // +0x18  -|initWithModel:param:|@@:@@  |64 +0x30
    CFStringRef clsName; // | +0x1c
} OCS_CodeBlock; // 0x1c |64 +0x40

typedef struct OCS_StackBlock_t {
    struct OCS_StackBlock_t *prev; // +0x0
    struct OCS_StackBlock_t *next; // +0x4
    int32_t allocSize; // +0x8     |64 +0x10
    void* stack;// +0xc
} OCS_StackBlock;

typedef struct OCS_Frame_t {
    struct OCS_Frame_t *back; // +0x0
    void* localVarPointer; // +0x4 | 64 +0x8
    int32_t pc; // class +0x8   |64 +0x10
    OCS_CodeBlock *codeBlock; // +0xc   |64 +0x18
    OCS_Class *cls; // +0x10    |64 +0x20
    OCS_ObjCValue *paramList; // +0x14 |64 +0x28
    CFArrayRef arrCStruct; // +0x18 CStruct
} OCS_Frame; // 0x39c

typedef struct OCS_VirtualMachine_t {
    OCS_Frame* currentFrame; // +0x0
    void* stackPointer; // +0x4     |64 +0x8
    OCS_StackBlock* stackBlock; // +0x8     |64 +0x18
    OCS_StackBlock* _0xc; // +0xc     |64
    int32_t stackSize; // +0x10     |64
    int32_t state; // +0x14     |64 +0x28
    pthread_t thread; // +0x18     |64
    CFStringRef exptionCallStackInfo; // +0x1c     |64
} OCS_VirtualMachine; // 0x20

typedef struct OCS_PropertyAttributes_t {
    BOOL readOnly;
    BOOL nonAtomic; // +0x1
    BOOL weak; // +0x2;
    BOOL dynamic; // +0x3;
    SEL getter; // +0xc
    int memoryPolicy; // +0x8
    SEL setter; // +0x10
    char * ivar; // +0x14
    Class cls;  // +0x18
    char *type;
} OCS_PropertyAttributes;


static void *_OCSExecutableManagerLoadDataCallback_fun; // *0x35d3dc0 | *0x760634
static void *_vmRunBlock;
static const struct mach_header* image_header; //*0x35d3dc8;
static NSUInteger int_35d3dcc; //*0x35d3dcc;

static CFMutableDictionaryRef dictExecutables; // *0x367d1f0  <executableName, OCS_Executable*> | *0x720674
static dispatch_queue_t OCSExecutableManagerReadWriteQueue; // *0x367d1f4 | *0x720670
static CFMutableDictionaryRef dictClassNameTables; // *0x367d1f8 <className, <CFMutableArrayRef>OCS_Executable*> | *0x72067c
static dispatch_queue_t exeClassNameTablesQueue; // *0x367d1fc | *0x720678
static NSMutableDictionary *codeBlockCache; // *0x367d200 <className, OCS_CodeBlock*> | *0x720684
static dispatch_queue_t classMethodBlockQueue; // | *0x720680

static CFMutableDictionaryRef dictCFunction; // *0x367d208 | *0x72068c
static CFMutableDictionaryRef dict_367d20c; // *0x367d20c | *0x720690
static CFMutableDictionaryRef dict_367d210; // *0x367d210 | *0x720694
static dispatch_queue_t structTypeDictReadWriteQueue;// *0x367d21c | *0x7206a0
static CFMutableDictionaryRef dictStructType; // *0x367d220 | *0x7206a4
static dispatch_queue_t cInvokeReadWriteQueue; // *0x367d214 | *0x720698

static NSMutableDictionary *OCSOverrideClsMethodNameDic; // *0x367d22c <NSString * className, <NSMutableDictionary <NSString * methodName (-|init|@:), ??> *> overrideMethods> | *0x7206c4
static dispatch_queue_t classMethodNameReadWriteQueue; // *00x367d228 | *0x7206c0
static NSMutableDictionary *classExecutableRoot; // *0x367d234 <NSString * filePath, NSString * rootPath> | *0x7206cc
static dispatch_queue_t classExecutableRootReadWriteQueue; // *0x367d230 | *0x7206c8

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
OCSDestroyStruct(OCS_Struct *s);

// sub_2a137d4
OCS_Executable*
OCSExecutableCreate(NSString *fileName, NSData *data, NSUInteger* errorCode);

// sub_2a13790
id
CurrentThreadOCSVMExptionCallStackInfo();

// sub_2a13fb4
NSData *
loadData(NSString *fileName);

// sub_2a1514a
OCS_VirtualMachine*
OCSGetCurrentThreadVirtualMachine();


#ifdef DEBUG
#define OCSLog(format, ...) \
NSLog((@"%s (%@:Line %d) " format), \
__PRETTY_FUNCTION__, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,\
## __VA_ARGS__);
#else
#define OCSLog(format, ...)
#endif ///< DEBUG

#endif /* OCSVM_code_h */
