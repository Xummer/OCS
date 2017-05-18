//
//  OCSEngine.m
//  OCS
//
//  Created by Xummer on 2017/3/2.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSEngine.h"
#import "OCSVM_code.h"
#import <pthread.h>

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
    void *buf /*r4*/ = malloc(size);
    memset(buf, 0, size);
    CFMutableArrayRef argList = CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
    if (numberOfArguments < 3) {
        // loc_2a14dc8
        [methodSignature /*stack[2022]*/ methodReturnType];
        NSString *clsStr = NSStringFromClass([assignSlf class]);
        OCS_CodeBlock *codeBlock;
        
        dispatch_sync(classMethodNameReadWriteQueue, ^{
            // sub_2a14f74
            Class cls = NSClassFromString(clsStr);
            if (cls) {
                while (![cls isEqual:[NSObject class]]) {
                    NSString *clsName = NSStringFromClass(cls);
                    cls = class_getSuperclass(cls);
                    NSDictionary *dictOverrideMethod = OCSOverrideClsMethodNameDic[clsName];
                    if (dictOverrideMethod) {
                        codeBlock = dictOverrideMethod[ selectorName ];
                        if (codeBlock) {
                            break;
                        }
                    }
                    if (!cls) {
                        break;
                    }
                }
            }
        });
        
        sub_2a13770(clsStr, selectorName, /*<sp + 0x30>*/, argList);
        
    }
    else {
        // loc_2a14c28
        // loc_2a14c70
        
    }
}

// sub_2a15228
void close_thread (void* thread) {
    /* <0x2a15229> 清理函数 */
    OCSVirtualMachineDestroy(thread);
}

// sub_2a1514a
OCS_VirtualMachine*
OCSGetCurrentThreadVirtualMachine() {
    OCS_VirtualMachine* vm;
    if (pthread_main_np()) {
        // main thread
        static OCS_VirtualMachine* mainThreadVM /* <*0x367d244> */;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            mainThreadVM = OCSVirtualMachineCreate();
        });
        
        vm = mainThreadVM;
        OCSVirtualMachineAttachThread(vm, pthread_self());
    }
    else {
        static pthread_key_t pkey; /* <*0x367d250> */;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            pthread_key_create(&pkey, close_thread);
        });
        
        vm = pthread_getspecific(pkey);
        if (!vm) {
            vm = OCSVirtualMachineCreate();
            OCSVirtualMachineAttachThread(vm, pthread_self());
            pthread_setspecific(pkey, vm);
        }
    }
    return vm;
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
        if (!OCSOverrideClsMethodNameDic) {
            OCSOverrideClsMethodNameDic = [[NSMutableDictionary alloc] init];
        }
        classExecutableRootReadWriteQueue = dispatch_queue_create("ocscript.OCSEngine.classExecutableRootReadWriteQueueID.read-write-qeueu", DISPATCH_QUEUE_CONCURRENT);
        if (!classExecutableRoot) {
            classExecutableRoot = [[NSMutableDictionary alloc] init];
        }
        if (!OCSExecutableManagerLoadDataCallback_fun) {
            OCSExecutableManagerLoadDataCallback_fun = &OCSGetExecutableData;
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

+ (NSString *)getClassNameWithFileName:(NSString *)fileName errorCode:(NSUInteger *)errorCode {
    OCS_Executable* exec = OCSGetExecutable(fileName, errorCode);
    if (*errorCode) {
        return nil;
    }
    else {
        return (__bridge NSString *)exec->clsName;
    }
}

+ (id)CurrentThreadOCSVMExptionCallStackInfo {
    return OCSGetCurrentThreadVMExptionCallStackInfo();
}

+ (id)CurrentThreadOCSVMStackInfo {
    return OCSGetCurrentThreadStackInfo();
}

// <OCS_CodeBlock *>
+ (NSArray *)getMethodsNameWithFileName:(NSString *)fileName errorCode:(NSUInteger *)errorCode {
    NSArray *result;
    OCS_Executable* exec = OCSGetExecutable(fileName, errorCode);
    if (*errorCode) {
        result = nil;
    }
    else {
        CFDictionaryRef theDict = exec->dictCodes;
        CFIndex count = CFDictionaryGetCount(theDict);
        const void ** keys = malloc(count * sizeof(CFStringRef *));
        const void ** values = malloc(count * sizeof(OCS_CodeBlock *));
        CFDictionaryGetKeysAndValues(theDict, keys, values);
        
        NSMutableArray *marr = [NSMutableArray array];
        
        for (uint32_t i = 0; i < count; i ++) {
//            CFStringRef key = keys[i];
            OCS_CodeBlock *value = ((OCS_CodeBlock *)values[i]);
            [marr addObject:(__bridge id _Nonnull)(value)];
        }
        
        if (keys) {
            free(keys);
        }
        
        if (values) {
            free(values);
        }
        
        result = [NSArray arrayWithArray:marr];
    }
    
    return result;
}

+ (void)runWithExecutablesRoot:(NSString *)rootPath
                     fileNames:(NSArray *)fileNames
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] setUpEnvironment];
    });
    
    for (NSString *fileName in fileNames) {
        dispatch_barrier_async(classExecutableRootReadWriteQueue, ^{
            // sub_2a144c6
            NSString *p = [classExecutableRoot objectForKey:fileName];
            if (!p) {
                [classExecutableRoot setObject:rootPath forKey:fileNames];
            }
        });
        
        NSUInteger errorCode = 0;
        [[self class] runWithFileName:fileName errorCode:&errorCode];
    }
    
}

+ (void)runWithFileName:(NSString *)fileName errorCode:(NSUInteger *)errorCode {
    dispatch_barrier_sync(classMethodNameReadWriteQueue, ^{
       // sub_2a145a0
        NSString *clsName =
        [[self class] getClassNameWithFileName:fileName errorCode:errorCode];
        NSDictionary *overrideMethods =
        [[self class] overrideMethodsWithFileName:fileName errorCode:errorCode];
        if (*errorCode) {
            
        }
        else {
            NSMutableDictionary *dict = [OCSOverrideClsMethodNameDic objectForKey:clsName];
            if (dict) {
                [dict addEntriesFromDictionary:overrideMethods];
            }
            else {
                dict = [NSMutableDictionary dictionaryWithDictionary:overrideMethods];
            }
            [OCSOverrideClsMethodNameDic setObject:dict forKey:clsName];
        }
    });
}

// <NSString* /*methodName*/, OCS_CodeBlock* /*codeBlock*/>
+ (NSDictionary *)overrideMethodsWithFileName:(NSString *)fileName errorCode:(NSUInteger *)errorCode {
    NSArray *arrMethods = [[self class] getMethodsNameWithFileName:fileName errorCode:errorCode];
    
    if (*errorCode) {
        return nil;
    }
    else {
        NSString *clsName = [[self class] getClassNameWithFileName:fileName errorCode:errorCode];
        if (*errorCode) {
            return nil;
        }
        else {
            Class cls = NSClassFromString(clsName);
            NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
            
            for (NSUInteger i = 0; i < [arrMethods count]; i ++) {
                OCS_CodeBlock *codeBlock = (__bridge OCS_CodeBlock *)(arrMethods[ i ]);
                NSString *method = (__bridge NSString *)codeBlock->method;
                NSArray *arrComponents = [method componentsSeparatedByString:@"|"];
                NSString *methodStr = arrComponents[ 1 ];
                mDict[ methodStr ] = (__bridge id _Nullable)(codeBlock);
                Class realCls;
                if (![arrComponents[0] isEqualToString:@"-"]) {
                    realCls = objc_getMetaClass([clsName UTF8String]);
                }
                else {
                    realCls = cls;
                }
                
                const char *typeDes;
                if (class_respondsToSelector(realCls, NSSelectorFromString(methodStr))) {
                    typeDes = NULL;
                }
                else {
                    typeDes = [arrComponents[3] UTF8String];
                }
                
                [[self class] overrideMethodWithClass:realCls selectorName:methodStr isClassMethod:NO typeDescription:typeDes];
            }
            
            return  [NSDictionary dictionaryWithDictionary:mDict];
        }
    }
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

@end
