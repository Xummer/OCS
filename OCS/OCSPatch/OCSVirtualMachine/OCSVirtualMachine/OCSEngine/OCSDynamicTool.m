//
//  OCSDynamicTool.m
//  Simple
//
//  Created by Xummer on 2017/6/5.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSDynamicTool.h"
#import "OCSVM_code.h"

const static void *OCSSpecialStructPropertyCached = &OCSSpecialStructPropertyCached;

void
OCSDynamicClassGetSetInvocation(id target, NSInvocation* invocation) {
    NSMethodSignature *signature = [invocation methodSignature];
    NSString *selStr = NSStringFromSelector([invocation selector]);
    Class cls = [target class];
    NSDictionary *associated =  objc_getAssociatedObject(cls, OCSSpecialStructPropertyCached);
    
    const char *name = [associated[selStr] UTF8String];
    Ivar ivar = class_getInstanceVariable(cls, name);
    if (!ivar) {
        // loc_35a8ca
        [NSException raise:@"OCSDynamicClassToolException" format:@"OCSDynamicClassGetSetInvocation class:%s ivar:%s not add:%s", [NSStringFromClass(cls) UTF8String], [selStr UTF8String], name];
        return;
    }
    
    NSUInteger count = [signature numberOfArguments];
    NSInteger needNumOfArg = count - 0x2;
    ivar_getOffset(ivar);
    if (count < 0x2 || needNumOfArg >= 0x2) {
        // loc_35a9b8
        NSString *reason = [NSString stringWithFormat:@"OCSDynamicClassGetSetInvocation OCSPropertyInfo gettersetter [propertyName = %@,needNumOfArg = %zd]", selStr, needNumOfArg];
        @throw [NSException exceptionWithName:@"OCSDynamicClassToolException" reason:reason userInfo:nil];
    }
    else if (count < 0x3) {
        // loc_35a90a
        const char *returnType = [signature methodReturnType];
        char rType = returnType[0];
        if (rType == 'r') {
            rType = returnType[1];
        }
        
        if (rType != '{') {
            // loc_35a996
            [NSException raise:@"OCSDynamicClassToolException" format:@"OCSDynamicClassGetSetInvocation returnType not define:%s", returnType];
            return;
        }
        
        OCSCreateRValueStructWithData(rType, );        
    }
    else {
//        malloc(<#size_t __size#>)
        [signature getArgumentTypeAtIndex:0x2];
    }
}

@implementation OCSDynamicTool

+ (void)sendMessageWithReceiver:(id)receiver result:(void*)result selector:(SEL)selector argptr:(void*)argptr {
    NSUInteger argumentsCount = 0;
    NSInvocation *invocation =
    [[self class] invocation:receiver selector:selector numberOfArguments:&argumentsCount];
    
    for (NSUInteger i = 0; i < argumentsCount; i++) {
        [invocation setArgument:&argptr[i] atIndex:i];
    }
    
    [invocation invoke];
    
    if (result) {
        [invocation getReturnValue:result];
    }
}

+ (NSInvocation *)invocation:(id)target selector:(SEL)selector numberOfArguments:(NSUInteger *)argumentsCount {
    NSMethodSignature *methodSignature =
    [target methodSignatureForSelector:selector];
    
    if (methodSignature) {
        *argumentsCount = [methodSignature numberOfArguments];
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        invocation.target = target;
        invocation.selector = selector;
        
        return invocation;
        
    }
    else {
        NSString *reason = [NSString stringWithFormat:@"[%@ %@]: unrecognized selector sent to instance %p", [target class], NSStringFromSelector(selector), target];
        @throw [[NSException alloc] initWithName:@"NSInvalidArgumentException" reason:reason userInfo:nil];
    }
}

@end
