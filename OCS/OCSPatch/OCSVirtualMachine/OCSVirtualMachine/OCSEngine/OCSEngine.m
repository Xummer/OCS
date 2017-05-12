//
//  OCSEngine.m
//  OCS
//
//  Created by Xummer on 2017/3/2.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSEngine.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <objc/objc.h>
#import <pthread.h>

static void *getExcutableDataFunc; // *0x35d3dc0
static NSMutableDictionary *dictClsMethodName; // *0x367d22c
static dispatch_queue_t classMethodNameReadWriteQueue; // *00x367d228
static NSMutableDictionary *dict3; // *0x367d234
static dispatch_queue_t classExecutableRootReadWriteQueue; // *0x367d230

// sub_2a14b60
static void JPForwardInvocation(__unsafe_unretained id assignSlf, SEL selector, NSInvocation *invocation) {
    NSMethodSignature *methodSignature = [invocation methodSignature];
    NSInteger numberOfArguments = [methodSignature numberOfArguments];
    
    NSString *selectorName = NSStringFromSelector(invocation.selector);
    NSString *JPSelectorName = [NSString stringWithFormat:@"_JP%@", selectorName];
    SEL JPSelector = NSSelectorFromString(JPSelectorName);
    
    if (!class_respondsToSelector(object_getClass(assignSlf), JPSelector)) {
        
        // loc_2a14edc
        SEL origForwardSelector = @selector(ORIGforwardInvocation:);
        NSMethodSignature *methodSignature = [assignSlf methodSignatureForSelector:origForwardSelector];
        NSInvocation *forwardInv= [NSInvocation invocationWithMethodSignature:methodSignature];
        [forwardInv setTarget:assignSlf];
        [forwardInv setSelector:origForwardSelector];
        [forwardInv setArgument:&invocation atIndex:2];
        [forwardInv invoke];
        // loc_2a14f6c;
        
        return;
    }
    
    // loc_2a14bf2:
    size_t size = numberOfArguments - 2;
    void *buf = malloc(size);
    memset(buf, 0, size);
    CFMutableArrayRef argList = CFArrayCreateMutable(kCFAllocatorDefault, 0, nil);
    if (numberOfArguments < 3) {
        // loc_2a14dc8
        [methodSignature methodReturnType];
        NSString *clsStr = NSStringFromClass([assignSlf class]);
        
        dispatch_sync(/*<*0x367d228>*/, ^{
            Class cls = NSClassFromString(clsStr);
            if (cls && ![cls isEqual:[NSObject class]]) {
                do {
                    NSString *clsName = NSStringFromClass(cls);
                    cls = class_getSuperclass(cls);
                    const void *value = CFDictionaryGetValue(/*<*0x367d22c>*/, clsName);
                    if (!value) goto ; //??
                    if (!cls) {
                        break;
                    }
                } while (![cls isEqual:[NSObject class]]);
            }
        });
        
        sub_2a13770(clsStr, /*<*(stack[2036] + 0x10)>*/, /*<sp + 0x30>*/, argList);
        
    }
    else {
        // loc_2a14c28
        // loc_2a14c70
        []
        
    }
}

// sub_2a15228
void close_thread (void* thread) {
    /* <0x2a15229> 清理函数 */
    OCSVirtualMachineDestroy(thread);
}

// sub_2a1514a
void*
sub_2a1514a() {
    void* content;
    if (pthread_main_np()) {
        // main thread
        static void* mainThreadContent /* <*0x367d244> */;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            mainThreadContent = sub_2a0bdee();
        });
        
        content = mainThreadContent;
        OCSVirtualMachineAttachThread(content, pthread_self());
    }
    else {
        static pthread_key_t pkey; /* <*0x367d250> */;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            pthread_key_create(&pkey, close_thread);
        });
        
        content = pthread_getspecific(pkey);
        if (!content) {
            content = sub_2a0bdee();
            OCSVirtualMachineAttachThread(content, pthread_self());
            pthread_setspecific(pkey, content);
        }
    }
}

/*
int sub_2a1514a() {
    stack[2044] = r4;
    stack[2045] = r5;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0x10) + 0x8;
    if (pthread_main_np() != 0x0) {
        if (*0x367d248 != 0xffffffff) {
            r0 = dispatch_once(0x367d248, 0x2f01e58);
        }
        r0 = pthread_self();
        r0 = sub_2a0be9c(*0x367d244, r0);
        r4 = *0x367d244;
    }
    else {
        if (*0x367d24c != 0xffffffff) {
            r0 = dispatch_once(0x367d24c, 0x2f01e7c);
        }
        r4 = pthread_getspecific(*0x367d250);
        if (r4 == 0x0) {
            r4 = sub_2a0bdee();
            r0 = pthread_self();
            r0 = sub_2a0be9c(r4, r0);
            r0 = pthread_setspecific(*0x367d250, r4);
        }
    }
    r0 = r4;
    return r0;
}
 */

@implementation OCSEngine

+ (void)setUpEnvironment {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // sub_2a13ed0
        classMethodNameReadWriteQueue = dispatch_queue_create("ocscript.OCSEngine.classMethodNameDic.read-write-qeueu", DISPATCH_QUEUE_CONCURRENT);
        if (!dictClsMethodName) {
            dictClsMethodName = [[NSMutableDictionary alloc] init];
        }
        classExecutableRootReadWriteQueue = dispatch_queue_create("ocscript.OCSEngine.classExecutableRootReadWriteQueueID.read-write-qeueu", DISPATCH_QUEUE_CONCURRENT);
        if (!dict3) {
            dict3 = [[NSMutableDictionary alloc] init];
        }
        if (!getExcutableDataFunc) {
            getExcutableDataFunc = &OCSGetExecutableData;
        }
        
        OCSSetUpCFuncEnvironment();
    });
}

/*
void sub_2a13ed0(void * _block) {
    r0 = _block;
    stack[2044] = r4;
    stack[2045] = r5;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0x10) + 0x8;
    *0x367d228 = dispatch_queue_create("ocscript.OCSEngine.classMethodNameDic.read-write-qeueu", __dispatch_queue_attr_concurrent);
    if (*0x367d22c == 0x0) {
        *0x367d22c = [[NSMutableDictionary alloc] init];
    }
    *0x367d230 = dispatch_queue_create("ocscript.OCSEngine.classExecutableRootReadWriteQueueID.read-write-qeueu", __dispatch_queue_attr_concurrent);
    if (*0x367d234 == 0x0) {
        *0x367d234 = [[NSMutableDictionary alloc] init];
    }
    if (*0x35d3dc0 == 0x0) {
        *0x35d3dc0 = 0x2a13fb5;
    }
    r0 = sub_2a13760();
    return;
}
 */

+ (void)getClassNameWithFileName:(NSString *)fileName errorCode:(NSUInteger *)errorCode {
    OCSGetExecutable(fileName, errorCode);
    if (*errorCode) {
    }
    else {
    }
}

+ (NSArray *)getMethodsNameWithFileName:(NSString *)fileName errorCode:(NSUInteger *)errorCode {
    NSArray *result;
    OCSGetExecutable(fileName, errorCode);
    if (*errorCode) {
        result = nil;
    }
    else {
        CFDictionaryRef theDict = ??;
        CFIndex size = CFDictionaryGetCount(theDict);
        void* keys = malloc(size << 0x2);
        void* values = malloc(size << 0x2);
        CFDictionaryGetKeysAndValues(theDict, keys, values);
        
        NSMutableArray *marr = [NSMutableArray array];
        
        if (size >= 1) {
            void** item = values;
            do {
                id obj = (__bridge id)(*item);
                [marr addObject:obj];
                item = item + 4;
                size --;
            } while (size > 0);
            free(keys);
        }
        else {
            if (keys) {
                free(keys);
            }
        }
        
        if (values) {
            free(values);
        }
        
        result = [NSArray arrayWithArray:marr];
    }
    
    return result;
}


+ (void)overrideMethodWithClass:(Class)cls selectorName:(NSString *)selName isClassMethod:(BOOL)isClsMthd typeDescription:(const char *)typeDes {
    SEL sel = NSSelectorFromString(selName);
    
    NSMethodSignature *methodSign;
    if (typeDes) {
        methodSign = [NSMethodSignature signatureWithObjCTypes:typeDes];
    }
    else {
        methodSign = [cls instanceMethodSignatureForSelector:sel];
        typeDes = method_getTypeEncoding(class_getInstanceMethod(cls, sel));
    }
    
    IMP origImp = NULL;
    if (class_respondsToSelector(cls, sel)) {
        origImp = class_getMethodImplementation(cls, sel);
    }
    
    IMP msgForwardIMP = _objc_msgForward;
    
#if !defined(__arm64__)
    // https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
    if (typeDes[0] == '{') {
        //In some cases that returns struct, we should use the '_stret' API:
        //http://sealiesoftware.com/blog/archive/2008/10/30/objc_explain_objc_msgSend_stret.html
        //NSMethodSignature knows the detail but has no API to return, we can only get the info from debugDescription.
        if ([methodSign.debugDescription rangeOfString:@"is special struct return? YES"].location != NSNotFound) {
            msgForwardIMP = (IMP)_objc_msgForward_stret;
        }
    }
#endif
    
    // Replace the original selector at last, preventing threading issus when
    // the selector get called during the execution of `overrideMethod`
    IMP origMethodImp = class_replaceMethod(cls, sel, msgForwardIMP, typeDes);
    
    if (class_getMethodImplementation(cls, @selector(forwardInvocation:)) != (IMP)JPForwardInvocation) {
        IMP origForwardImp = class_replaceMethod(cls, @selector(forwardInvocation:), (IMP)JPForwardInvocation, "v@:@");
        if (origForwardImp) {
            class_addMethod(cls, @selector(ORIGforwardInvocation:), origForwardImp, "v@:@");
        }
    }
    
    if (class_respondsToSelector(cls, sel)) {
        NSString *originalSelectorName = [NSString stringWithFormat:@"ORIG%@", selName];
        SEL originalSelector = NSSelectorFromString(originalSelectorName);
        if(!class_respondsToSelector(cls, originalSelector)) {
            class_addMethod(cls, originalSelector, origImp, typeDes);
        }
    }
    
    NSString *JPSelName = [NSString stringWithFormat:@"_JP%@", selName];
    class_addMethod(cls, NSSelectorFromString(JPSelName), msgForwardIMP, typeDes);
    
}

+ (void)runWithExecutablesRoot:(id)root fileNames:(NSArray *)fileNames {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] setUpEnvironment];
    });
    
    
}

@end
