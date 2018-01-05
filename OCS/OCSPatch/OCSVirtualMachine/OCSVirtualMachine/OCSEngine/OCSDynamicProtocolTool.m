//
//  OCSDynamicProtocolTool.m
//  OCS
//
//  Created by Xummer on 2017/5/31.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSDynamicProtocolTool.h"
#import "OCSVM_code.h"
#import "OCSModules.h"

@implementation OCSDynamicProtocolTool

+ (BOOL)setUpDynamicProtocol:(OCSProtocolInfo *)protocolInfo {
    if ([protocolInfo.protocolName length]) {
        [[self class] dynamicProtocol:protocolInfo.protocolName
                      refProtocolList:protocolInfo.OCSRefProtocolList
                         propertyList:protocolInfo.OCSPropertyList
                           methodList:protocolInfo.OCSMethodList];
        return YES;
    }
    return NO;
}

+ (void)dynamicProtocol:(NSString *)protocolName
        refProtocolList:(NSArray *)refProtocolList
           propertyList:(NSArray *)propertyList
             methodList:(NSArray *)methodList
{
    const char *cProtocolName = [protocolName UTF8String];
    OCSLog(@"startSetupDynamicProtocol:protocolName(%s)", cProtocolName);
    
    Protocol *protocol = objc_getProtocol(cProtocolName);
    if (!protocol) {
        protocol = objc_allocateProtocol(cProtocolName);
        if (protocol) {
            [refProtocolList enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Protocol *refProtocol = objc_getProtocol([obj UTF8String]);
                if (refProtocol) {
                    protocol_addProtocol(protocol, refProtocol);
                }
                else {
                    NSString *reason = [NSString stringWithFormat:@"refProtocol is not exist: %@", obj];
                    @throw [NSException exceptionWithName:@"OCSDynamicProtocolTool" reason:reason userInfo:nil];
                }
            }];
            
            [methodList enumerateObjectsUsingBlock:^(OCSProtocolMethod * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [[self class] addProtocolMethodDescription:protocol
                                              selectorName:obj.methodName
                                              typeEncoding:obj.typeEncode
                                          isRequiredMethod:obj.isRequiredMethod
                                          isInstanceMethod:obj.isInstanceMethod];
            }];
            
            [propertyList enumerateObjectsUsingBlock:^(OCSProtocolProperty *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                OCS_PropertyAttributes *ppAttr = OCSCopyPropertyAttributes([obj.propertyName UTF8String], [obj.typeEncode UTF8String]);
                if (ppAttr) {
                    OCSPropertyInfo *info = [OCSPropertyInfo new];
                    NSString *ivarStr = nil;
                    if (ppAttr->ivar) {
                        ivarStr = [NSString stringWithUTF8String:ppAttr->ivar];
                    }
                    
                    info.ivar = ivarStr;
                    info.name = obj.propertyName ? : @"";
                    info.type = [NSString stringWithUTF8String:ppAttr->type];
                    info.readonly = ppAttr->readOnly;
                    info.dynamic = ppAttr->dynamic;
                    info.weak = ppAttr->weak;
                    info.getter = ppAttr->getter;
                    info.setter = ppAttr->setter;
                    info.nonAtomic = ppAttr->nonAtomic;
                    info.memoryPolicy = ppAttr->memoryPolicy;
                    
                    [[self class] addProperty:protocol property:info isRequiredProperty:obj.isRequiredProperty isInstanceProperty:obj.isInstanceProperty];
                    
                    free(ppAttr);
                }
            }];
            
            objc_registerProtocol(protocol);
        }
    }
    
}

+ (void)addProtocolMethodDescription:(Protocol *)proto selectorName:(NSString *)selName typeEncoding:(NSString *)encoding isRequiredMethod:(BOOL)isRequiredMethod isInstanceMethod:(BOOL)isInstanceMethod
{
    if ([selName length] && [encoding length]) {
        sel_registerName([selName UTF8String]);
        protocol_addMethodDescription(proto, sel_registerName([selName UTF8String]), [encoding UTF8String], isRequiredMethod, isInstanceMethod);
    }
    else {
        @throw [NSException exceptionWithName:@"OCSDynamicProtocolTool" reason:@"method cannot be nil" userInfo:nil];
    }
}

+ (BOOL)addProperty:(Protocol *)protocol property:(OCSPropertyInfo *)propertyInfo isRequiredProperty:(BOOL)isRequiredProperty isInstanceProperty:(BOOL)isInstanceProperty
{
    if (!protocol) {
        @throw [NSException exceptionWithName:@"OCSDynamicProtocolTool" reason:@"protocol cannot be nil" userInfo:nil];
        return NO;
    }
    
    if (!propertyInfo) {
        @throw [NSException exceptionWithName:@"OCSDynamicProtocolTool" reason:@"property cannot be nil" userInfo:nil];
        return NO;
    }
    
    if (propertyInfo.name.length == 0) {
        @throw [NSException exceptionWithName:@"OCSDynamicProtocolTool" reason:@"property name must be of non-zero length" userInfo:nil];
        return NO;
    }
    
    if (!propertyInfo.type) {
        @throw [NSException exceptionWithName:@"OCSDynamicProtocolTool" reason:@"property typeEncoding must be of non-zero length" userInfo:nil];
        return NO;
    }
    
    // TODO
}


@end
