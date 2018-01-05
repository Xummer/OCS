//
//  OCSEngine.m
//  OCS
//
//  Created by Xummer on 2017/3/2.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSEngine.h"
#import "OCSVM_code.h"
#import "OCSDynamicTool.h"
#import "OCSConfigureFileEngine.h"
#import <pthread.h>

// sub_2a14b60
static void
JPForwardInvocation(__unsafe_unretained id assignSlf, SEL selector, NSInvocation *invocation) {
    NSMethodSignature *methodSignature = [invocation methodSignature];
    NSInteger numberOfArguments = [methodSignature numberOfArguments];
    
    NSString *selectorName = NSStringFromSelector(invocation.selector);
    NSString *className = NSStringFromClass([assignSlf class]);
    NSString *JPSelectorName = [NSString stringWithFormat:@"_JP%@", selectorName];
    SEL JPSelector = NSSelectorFromString(JPSelectorName);
    
    if (!class_respondsToSelector(object_getClass(assignSlf), JPSelector)) {
        
        // loc_35f4a8
        SEL dpSelector = NSSelectorFromString([NSString stringWithFormat:@"_OCSDynamicProperty_%@", selectorName]);
        if (class_respondsToSelector(object_getClass(assignSlf), dpSelector)) {
            // loc_35f4d0
            OCSDynamicClassGetSetInvocation(assignSlf, invocation);
            return;
        }
        
        // loc_35f6d8
        if ([selectorName hasPrefix:@"=OCS_SUPER="]) {
            NSArray <NSString *> *components =
            [[selectorName stringByReplacingOccurrencesOfString:@"=OCS_SUPER=" withString:@""] componentsSeparatedByString:@"="];
            if ([components count] == 2) {
                // loc_35f724
                NSString *clsName = components[0];
                NSString *selName = components[1];
                if (clsName.length > 0 && selName.length > 0) {
                    // loc_35f75c
                    NSString *methodName = getOCSMethodName(clsName, selName);
                    if (methodName) {
                        OCS_CodeBlock *codeBlock = OCSGetCodeBlock(clsName, methodName);
                        if (codeBlock) {
                            // loc_35f486
                        }
                    }
                    
                }
            }
        }
        
        // loc_35f776
        
//        // loc_2a14edc
//        SEL origForwardSelector = @selector(ORIGforwardInvocation:);
//        NSMethodSignature *methodSignature = [assignSlf methodSignatureForSelector:origForwardSelector];
//        NSInvocation *forwardInv= [NSInvocation invocationWithMethodSignature:methodSignature];
//        [forwardInv setTarget:assignSlf];
//        [forwardInv setSelector:origForwardSelector];
//        [forwardInv setArgument:&invocation atIndex:2];
//        [forwardInv invoke];
//        // loc_2a14f6c;
//        
//        return;
    }
    else {
        // loc_35f480
        // loc_35f486
        
        NSUInteger uiArgCount = numberOfArguments - 2;
        OCS_ParaList *paraList = NULL;
        if (numberOfArguments > 3) {
            size_t size = (offsetof(OCS_ParaList, arg) + sizeof(OCS_Struct)) * uiArgCount; //r1 + r1 * (2 << 2);
            paraList = malloc(size);
            memset(paraList, 0, size);
        }
        
//      r11 = r5 + 4;
        
        // loc_35f51c
        for (NSUInteger i = 2; i < numberOfArguments; i++) {
            NSUInteger uiArgIdx = i - 2;
            const char *argumentType = [methodSignature getArgumentTypeAtIndex:i];
            switch(argumentType[0] == 'r' ? argumentType[1] : argumentType[0]) {
                    
#define JP_FWD_ARG_CASE(_typeChar, _type, _tag) \
                case _typeChar: {   \
                    _type arg;  \
                    [invocation getArgument:&arg atIndex:i];    \
                    paraList[uiArgIdx].vTag = _tag;   \
                    paraList[uiArgIdx].arg = arg;\
                    break;  \
                }
                
                JP_FWD_ARG_CASE('c', char, OCSVTagChar)
                JP_FWD_ARG_CASE('C', unsigned char, OCSVTagUChar)
                JP_FWD_ARG_CASE('s', short, OCSVTagShort)
                JP_FWD_ARG_CASE('S', unsigned short, OCSVTagUShort)
                JP_FWD_ARG_CASE('i', int, OCSVTagInt)
                JP_FWD_ARG_CASE('I', unsigned int, OCSVTagUInt)
                JP_FWD_ARG_CASE('l', long, OCSVTagLong)
                JP_FWD_ARG_CASE('L', unsigned long, OCSVTagULong)
                JP_FWD_ARG_CASE('q', long long, OCSVTagLongLong)
                JP_FWD_ARG_CASE('Q', unsigned long long, OCSVTagULongLong)
                JP_FWD_ARG_CASE('f', float, OCSVTagFloat)
                JP_FWD_ARG_CASE('d', double, OCSVTagDouble)
                JP_FWD_ARG_CASE('B', BOOL, OCSVTagUChar)
                JP_FWD_ARG_CASE('#', Class, OCSVTagClass)
                JP_FWD_ARG_CASE('@', id, OCSVTagID)
                JP_FWD_ARG_CASE(':', SEL, OCSVTagSel)
                JP_FWD_ARG_CASE('*', void *, OCSVTagPointer)
                JP_FWD_ARG_CASE('^', void *, OCSVTagPointer)
                    
#undef JP_FWD_ARG_CASE
                    
//                    0x3f
//                    
//                    0x67 'g', 'a', 'b'
//                    
//                    ; 0x35f55c,0x35f582,0x35f59e,0x35f5d0,0x35f5e4,0x35f5e8,0x35f5ec, case 14
//                    ; 0x35f582,0x35f5d0,0x35f5f0,0x35f5f4,0x35f5f8,0x35f5fc,0x35f600,0x35f604, case 17
                    
                    // 0x23 '#' loc_35f608   0xd
                    // 0x2a '*' loc_35f59e   0x10
                    // 0x3a ':' loc_35f592   0xf
                    // 0x51 'Q' loc_35f5a6   0xa
                    // 0x53 'S' loc_35f60c   0x4
                    // 0x5e '^' loc_35f59e   0x10
                    // 0x7b '{'  0x11
                    // loc_35f5d0
                    
                case '{':
                {
                    // loc_35f5ae
                    OCS_Struct *st = OCSCreateRValueStruct([NSString stringWithUTF8String:argumentType]);
                    paraList[uiArgIdx].arg = st;
                    paraList[uiArgIdx].vTag = OCSVTagStruct;
                    [invocation getArgument:&st->value atIndex:i];
                }
                    break;
                default:
                {
                    [NSException raise:@"OCSCommonException" format: @"JPForwardInvocation argumentType not define:%s", argumentType];
                }
                    break;
            }
        }
        
        // loc_35f61c:
        const char *returnType = [methodSignature methodReturnType];
        char rType = returnType[0] == 'r' ? returnType[1] : returnType[0];
        
        OCS_ReturnValue *rv;
        rv->typeEncode = rType;
        rv->value = NULL;
        
        NSString *methodName = getOCSMethodName(className, selectorName);
        OCSRunWithParaList(className, methodName, rv, paraList);
        
        if (rType != 'v') {
            void *ret = rv->value;
            [invocation setReturnValue:ret];
            if (ret) {
                free(ret);
                ret = NULL;
            }
        }
        
        
        if (paraList) {
            // Relase Struct
            for (NSUInteger i = 0; i < uiArgCount; i ++) {
                if (paraList[i].vTag == OCSVTagStruct) {
                    OCSDestroyStruct(paraList[i].arg);
                }
            }
            free(paraList);
        }
    }
    
//    // loc_2a14bf2:
//    size_t size /*r8*/ = numberOfArguments /* r11 */ - 2;
//    void *buf /*r4*/ = malloc(size);
//    memset(buf, 0, size);
//    CFMutableArrayRef argList = CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
//    if (numberOfArguments < 3) {
//        // loc_2a14dc8
//        [methodSignature /*stack[2022]*/ methodReturnType];
//        NSString *clsStr = NSStringFromClass([assignSlf class]);
//        OCS_CodeBlock *codeBlock;
//        
//        dispatch_sync(classMethodNameReadWriteQueue, ^{
//            // sub_2a14f74
//            Class cls = NSClassFromString(clsStr);
//            if (cls) {
//                while (![cls isEqual:[NSObject class]]) {
//                    NSString *clsName = NSStringFromClass(cls);
//                    cls = class_getSuperclass(cls);
//                    NSDictionary *dictOverrideMethod = OCSOverrideClsMethodNameDic[clsName];
//                    if (dictOverrideMethod) {
//                        codeBlock = dictOverrideMethod[ selectorName ];
//                        if (codeBlock) {
//                            break;
//                        }
//                    }
//                    if (!cls) {
//                        break;
//                    }
//                }
//            }
//        });
//        
//        OCSRunWithParaList(clsStr, selectorName, /*<sp + 0x30>*/, argList);
//        
//    }
//    else {
//        // loc_2a14c28
//        r5 = 0;
//        // loc_2a14c70
//        r11 = r5 + 2;
//        [invocation getArgument:&arg atIndex:i]
//    }
}

// sub_2a15228
void
close_thread (void* thread) {
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

NSString *
getOCSMethodName(NSString *clsName, NSString *selectorName) {
    if (clsName.length > 0 && selectorName.length > 0) {
        __block NSString *methodName = nil;
        dispatch_sync(classMethodNameReadWriteQueue, ^{
            Class cls = NSClassFromString(clsName);
            if (cls) {
                // loc_35f862
                // loc_35f87c
                while (![cls isEqual:[NSObject class]]) {
                    // loc_35f894
                    NSString *className = NSStringFromClass(cls);
                    cls = class_getSuperclass(cls);
                    NSMutableDictionary *dict =
                    CFDictionaryGetValue(OCSOverrideClsMethodNameDic, (__bridge CFStringRef)className);
                    if (dict) {
                        // loc_35f8b0
                        methodName = CFDictionaryGetValue(dict, selectorName);
                        break;
                    }
                }
            }
        });
        
        return methodName;
    }
    else {
        return nil;
    }
}

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
        if (!_OCSExecutableManagerLoadDataCallback_fun) {
            _OCSExecutableManagerLoadDataCallback_fun = &loadData; // | 0x35d885
        }
        
        if (!_vmRunBlock) {
            _vmRunBlock = &OCSRunBlockWithLayout; // | 0x35b8b1
        }
        
        OCSSetUpEnvironment();
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
            CFStringRef value = ((CFStringRef)keys[i]);
            [marr addObject:(__bridge NSString *)(value)];
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

+ (id)CurrentThreadOCSVMExptionCallStackInfo {
    return CurrentThreadOCSVMExptionCallStackInfo();
}

+ (id)CurrentThreadOCSVMStackInfo {
    return CurrentThreadOCSVMStackInfo();
}

// <NSString* /*methodName*/, OCS_CodeBlock* /*codeBlock*/>
+ (void)overrideWithFileName:(NSString *)fileName errorCode:(NSUInteger *)errorCode {
    NSString *clsName = [[self class] getClassNameWithFileName:fileName errorCode:errorCode];
    NSDictionary *orClsMethodDic = [OCSOverrideClsMethodNameDic objectForKey:clsName];
    
    OCSLog(@"overrideWithFileName:fileName(%s)", [fileName UTF8String]);
    
    [orClsMethodDic enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSArray *components = [[self class] componentsForMethodName:key];
        Class cls = NSClassFromString(clsName);
        NSString *methodType = [[[self class] methodTypeEncdoeInMethodNameComponents:components] mutableCopy];
        BOOL isMethodName = [[self class] isInstanceInMethodNameComponents:components];
        NSString *selectorName = [[self class] isInstanceInMethodNameComponents:components];
        
        Class realCls;
        if (isMethodName) {
            realCls = cls;
        }
        else {
            realCls = objc_getMetaClass([clsName UTF8String]);
        }
        
        BOOL selectorExistence = class_respondsToSelector(realCls, NSSelectorFromString(selectorName));
        OCSLog(@"overrideWithFileName:class(%s),selectorName(%s),methodName(%s),methodTypeEncdoe(%s),selectorExistence(%s)", clsName, selectorName, isMethodName ? "YES" : "NO", [methodType UTF8String], selectorExistence ? "YES" : "NO");
        
        const char *typeDes;
        if (selectorExistence) {
            typeDes = NULL;
        }
        else {
            typeDes = [methodType UTF8String];
        }
        
        [[self class] overrideMethodWithClass:realCls selectorName:selectorName isClassMethod:NO typeDescription:typeDes];
    }];
}

+ (void)setUpEnvironmentAndAddExecutablesRoot:(NSString *)rootPath fileNames:(NSArray *)fileNames {
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
    }
}

+ (void)runWithExecutablesRoot:(NSString *)rootPath
                     fileNames:(NSArray *)fileNames
{
    if ([fileNames isKindOfClass:[NSArray class]] && [fileNames count] > 0) {
        [[self class] setUpEnvironmentAndAddExecutablesRoot:rootPath fileNames:fileNames];
        
        NSUInteger errorCode = 0;
        if ([fileNames count] > 0) {
            [[OCSConfigureFileEngine sharedInstance] runWithConfigure:rootPath configurefileNames:fileNames errorCode:&errorCode];
        }
        
        for (NSString *fileName in fileNames) {
            dispatch_barrier_async(classMethodNameReadWriteQueue, ^{
                OCSLog(@"runWithExecutablesRoot:fileName(%s)", [fileName UTF8String]);
                [[self class] setupCacheForFileName:fileName errorCode:&errorCode];
                [[self class] overrideWithFileName:fileName errorCode:errorCode];
            });
        }
    }
}

+ (void)setupCacheForFileName:(NSString *)fileName
                    errorCode:(NSUInteger *)errorCode
{
    NSString *clsName = [[self class] getClassNameWithFileName:fileName errorCode:errorCode];
    NSDictionary *relationForMethodAndSel = [[self class] getRelationForMethodNameAndSelectorWithFileName:fileName errorCode:errorCode];
    if (!*errorCode) {
        NSMutableDictionary *dict = [OCSOverrideClsMethodNameDic objectForKey:clsName];
        if (dict) {
            [dict addEntriesFromDictionary:relationForMethodAndSel];
        }
        else {
            dict = [NSMutableDictionary dictionaryWithDictionary:relationForMethodAndSel];
        }
        [OCSOverrideClsMethodNameDic setObject:dict forKey:clsName];
    }
}

+ (NSArray *)componentsForMethodName:(NSString *)methodName {
    if (methodName) {
        return [methodName componentsSeparatedByString:@"|"];
    }
    else {
        @throw [NSException exceptionWithName:@"OCSEngine" reason:@"OCS方法名为空！！！" userInfo:nil];
    }
}

+ (BOOL)isInstanceInMethodNameComponents:(NSArray *)components {
    if (components && [components count] > 0) {
        return [components[0] isEqualToString:@"-"];
    }
    else {
        @throw [NSException exceptionWithName:@"OCSEngine" reason:@"OCS方法名解析结果为空！！！" userInfo:nil];
    }
}

+ (NSString *)selectorNameInMethodNameComponents:(NSArray *)components {
    if (components && [components count] > 0) {
        return components[1];
    }
    else {
        @throw [NSException exceptionWithName:@"OCSEngine" reason:@"OCS方法名解析结果为空！！！" userInfo:nil];
    }
}

+ (NSString *)methodTypeEncdoeInMethodNameComponents:(NSArray *)components {
    if (components && [components count] > 0) {
        return components[2];
    }
    else {
        @throw [NSException exceptionWithName:@"OCSEngine" reason:@"OCS方法名解析结果为空！！！" userInfo:nil];
    }
}

+ (NSDictionary *)getRelationForMethodNameAndSelectorWithFileName:(NSString *)fileName errorCode:(NSUInteger *)errorCode {
    NSArray *arrMethodsName = [[self class] getMethodsNameWithFileName:fileName errorCode:errorCode];
    if (!*errorCode) {
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        
        for (NSString *method in arrMethodsName) {
            NSArray *arrComponents = [[self class] componentsForMethodName:method];
            if ([arrComponents count] >= 3) {
                if (![arrComponents[0] isEqualToString:@"^"]) {
//                    [arrComponents[0] isEqualToString:@"-"]
                    
                    NSString *selector = [[self class] selectorNameInMethodNameComponents:arrComponents];
                    [mDict setObject:selector forKey:method];
                }
            }
        }
        
        return [NSDictionary dictionaryWithDictionary:mDict];
    }
    
    return nil;
}

+ (void)overrideMethodWithClass:(Class)cls selectorName:(NSString *)selName isClassMethod:(BOOL)isClsMthd typeDescription:(const char *)typeDes {
    
    OCSLog(@"overrideMethod:class(%s),selectorName(%s),type(%s),typeDescription(%s)", [NSStringFromClass(cls) UTF8String], [selName UTF8String], isClsMthd, typeDes);
    
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
    
    OCSLog(@"OCS Add class:(%s) selector:(%s) isSucess = %s", [NSStringFromClass(cls) UTF8String], [JPSelName UTF8String], class_respondsToSelector(cls, NSSelectorFromString(JPSelName)) ? "YES" : "NO");
}

+ (void)OCSMessageSendReceiver:(id)receiver returnResult:(void*)result selector:(SEL)selector {
    if (receiver) {
        [OCSDynamicTool sendMessageWithReceiver:receiver result:result selector:selector argptr:nil];
    }
}

+ (void)OCSMessageTry:(void (^)(void))tryBlock
           catchBlock:(void (^)(NSException *exception))catchBlock
         finallyBlock:(void (^)(void))finallyBlock {
    @try {
        if (tryBlock) {
            tryBlock();
        }
    } @catch (NSException *exception) {
        if (catchBlock) {
            catchBlock(exception);
        }
    } @finally {
        if (finallyBlock) {
            finallyBlock();
        }
    }
}

+ (void)OCSMessageSynchronized:(id)synchronized synchronizedBlock:(void (^)(void))block {
    
    @synchronized (synchronized) {
        if (block) {
            block();
        }
    }
}

@end
