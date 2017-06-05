//
//  OCSDynamicClassTool.m
//  OCS
//
//  Created by Xummer on 2017/5/31.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSDynamicClassTool.h"
#import "OCSVM_code.h"
#import "OCSModules.h"

OCS_PropertyAttributes *
_OCSCopyPropertyAttributes(const char *name, const char *encode) {
    if (encode) {
        // loc_356c5a
        if (encode[0] != 'T') {
            // loc_356d2e
            fprintf(stderr, "ERROR: Expected attribute string \"%s\" for property %s to start with 'T'\n", encode, name);
            return NULL;
        }
        
        NSUInteger uiSize = 0;
        NSUInteger uiAlignment = 0;
        NSInteger offset = 0;
        
        // loc_356c62
        const char * s = &encode[offset];
        const char * r = NSGetSizeAndAlignment(s, &uiSize, &uiAlignment);
        if (r == 0) {
            // loc_356d3a
            fprintf(stderr, "ERROR: Could not read past type in attribute string \"%s\" for property %s\n", encode, name);
            return NULL;
        }
        
        if (r == s) {
            // loc_356d46
            fprintf(stderr, "ERROR: Invalid type in attribute string \"%s\" for property %s\n", encode, name);
            return NULL;
        }
        
        NSInteger len = r - s;
        OCS_PropertyAttributes *propertyAttr = calloc(1, len + 0x1d); // ??
        if (propertyAttr == NULL) {
            // loc_356d7a
            fprintf(stderr, "ERROR: Could not allocate OCSPropertyAttributes structure for attribute string \"%s\" for property %s\n", encode, name);
            return NULL;
        }
        
        strncpy(propertyAttr->type, s, len);
        propertyAttr->type[len] = '\0';
        
        if (s[0] == '@' && s[1] == '"') {
            // loc_356cca
            r = strchr(&s[2], '"');
            if (NULL == r) {
                // loc_356f8c
                fprintf(stderr, "ERROR: Could not read class name in attribute string \"%s\" for property %s\n", encode, name);
                return NULL;
            }
            else {
                // loc_356cde:
                if (r != &s[2]) {
                    size_t clsLen = &s[2] - r;
                    char clsName[0xFF] = "";
                    strncpy(clsName, &s[2], clsLen);
                    clsName[clsLen] = '\0';
                    propertyAttr->cls = objc_getClass(clsName);
                }
                else {
                    r = &s[2];
                }
            }
        }
        
        // loc_356d8e
        if (r[0] != 0x0) {
            r = strchr(r, ',');
        }
        
        // loc_356df8
        if (r == NULL) {
            // loc_356f2c
            if (propertyAttr->getter == NULL) {
                propertyAttr->getter = sel_registerName(name);
            }
            
            if (propertyAttr->setter == NULL) {
                size_t nameLen = strlen(name);
                char setterName[0xFF] = "";
                strncpy(setterName, "set", 0x3);
                strncpy(setterName+3, name, nameLen);
                setterName[3] = _toupper(setterName[3]);
                setterName[3+nameLen] = '\0';
                propertyAttr->setter = sel_registerName(setterName);
            }
        }
        else if (r[0] != ',') {
            // loc_356f12
            if (r[0] != 0x0) {
                fprintf(stderr, "Warning: Unparsed data \"%s\" in attribute string \"%s\" for property %s\n", r, encode, name);
            }
            // loc_356f2c
        }
        else {
            char r5 = r[1];
            r = r + 0x2;
            if (r5 > '%') {
                // loc_356e16
            }
            else {
                // loc_356e10
                if (r5 != 0x0) {
                    fprintf(stderr, "ERROR: Unrecognized attribute string flag '%c' in attribute string \"%s\" for property %s\n", r5, encode, name);
                    // loc_356df8
                }
                else {
                    // loc_356e16
                    if (r5 > 'W') {
                        // loc_356e82
                        if (r5 == '&') {
                            propertyAttr->memoryPolicy = 1;
                        }
                        else {
                            if (r5 == 't') {
                                fprintf(stderr, "ERROR: Old-style type encoding is unsupported in attribute string \"%s\" for property %s\n",encode, name);
                                while (r[0] != 0x0 && r[0] != ',') {
                                    r = r + 0x1;
                                }
                            }
                            else {
                                fprintf(stderr, "ERROR: Unrecognized attribute string flag '%c' in attribute string \"%s\" for property %s\n", r5, encode, name);
                            }
                        }
                        // loc_356df8
                    }
                    else {
                        // loc_356e1e
                        switch (r5) {
                            case 0:
                            {
                                // 0x356e38
                                char * r11 = strchr(r, ',');
                                if (r11 == 0) {
                                    // loc_356f06
                                }
                                else if (r11 == r) {
                                    // loc_356fa2
                                }
                                else {
                                    // loc_356e52
                                }
                                
                            }
                                break;
                            case 1:
                            {
                                // 0x356eae
                            }
                                break;
                            case 2:
                            {
                                // 0x356ec8
                            }
                                break;
                            case 3:
                            {
                                // 0x356ece
                            }
                                break;
                            case 4:
                            {
                                // 0x356ed4
                            }
                                break;
                            case 5:
                            {
                                // 0x356eda
                            }
                                break;
                            case 6:
                            {
                                // 0x356ee0
                            }
                                break;
                            case 7:
                            {
                                // 0x356ee6
                            }
                                break;
                            case 8:
                            {
                                // 0x356efa
                            }
                                break;
                            default:
                                break;
                        }
                    }
                }
                
            }
        }
    }
}

@implementation OCSDynamicClassTool

+ (BOOL)setupDynamicClass:(OCSClassInfo *)clsInfo {
    NSString *currentCls = [clsInfo currentClass];
    NSString *superCls = [clsInfo supperClass];
    if (!NSClassFromString(currentCls)) {
        OCSLog(@"startSetupDynamicClass:className(%s)", [currentCls UTF8String]);
        Class superClass = NSClassFromString(superCls);
        if (NSClassFromString(superCls)) {
            Class dynamicCls =
            [[self class] generateDynamicClass:currentCls
                                    isARCClass:[clsInfo isARCClass]
                                    superClass:superClass
                                      IvarList:[clsInfo OCSIvarList]
                                  propertyList:[clsInfo OCSPropertyList]
                                  refProtocols:[clsInfo OCSRefProtocolList]];
            if (dynamicCls) {
                OCSLog(@"ADDDynamicClass :className(%s), isSucess(%s)", [currentCls UTF8String], "YES");
                return YES;
            }
            else {
                @throw [NSException exceptionWithName:@"OCSDynamicClassToolException" reason:[NSString stringWithFormat:@"setup class failed for: %@", currentCls] userInfo:nil];
            }
        }
        else {
            @throw [NSException exceptionWithName:@"OCSDynamicClassToolException" reason:[NSString stringWithFormat:@"superClass:%@ is not exist for class: %@", superCls, currentCls] userInfo:nil];
        }
    }
    return NO;
}

+ (Class)generateDynamicClass:(NSString *)currentCls
                   isARCClass:(BOOL)isARC
                   superClass:(Class)superCls
                     IvarList:(NSArray *)ivarList
                 propertyList:(NSArray *)propertyList
                 refProtocols:(NSArray *)protocols
{
    const char *clsName = [[NSString stringWithFormat:@"%@", currentCls] UTF8String];
    Class cls = objc_getClass(clsName);
    if (!cls) {
        cls = objc_allocateClassPair(superCls, clsName, 0);
        if (!cls) {
            cls = objc_getClass(clsName);
        }
        
        if (cls) {
            
            [protocols enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Protocol *protocol = objc_getProtocol([obj UTF8String]);
                if (protocol) {
                    class_addProtocol(cls, protocol);
                }
            }];
            
            NSMutableArray *arr = [NSMutableArray array];
            
            [ivarList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
            }];
            
            [NSMutableArray array];
            [NSMutableDictionary dictionary];
            
            [[self class] dynamicClassPropertyInfos:propertyList];
            
        }
    }
    
    return cls;
}

/*
int +[OCSDynamicClassTool generateDynamicClass:isARCClass:superClass:IvarList:propertyList:refProtocols:](int arg0) {
    stack[2043] = r4;
    stack[2044] = r5;
    stack[2045] = r6;
    stack[2046] = r7;
    stack[2047] = lr;
    r7 = (sp - 0x14) + 0xc;
    stack[4611686018427389944] = r8;
    stack[4611686018427389945] = r10;
    stack[4611686018427389946] = r11;
    sp = sp - 0xc8;
    r10 = arg0;
    r8 = r3;
    r3 = r2;
    r0 = [NSString stringWithFormat:@"%@", r3];
    r0 = [r0 UTF8String];
    r5 = r0;
    r11 = objc_getClass(r0);
    if (r11 == 0x0) {
        r0 = ret_addr;
        r1 = r5;
        r2 = 0x0;
        asm { strd       r4, sl, [sp, #0xc0 + var_B0] };
        asm { strd       r6, r8, [sp, #0xc0 + var_A4] };
        r6 = 0x0;
        r11 = objc_allocateClassPair(r0, r1, r2);
        if (r11 == 0x0) {
            r11 = objc_getClass(r5);
            if (r11 != 0x0) {
                r2 = 0x3582ad;
                r4 = __NSConcreteStackBlock;
                r1 = 0xc2000000;
                r0 = arg_C;
                r10 = @selector(enumerateObjectsUsingBlock:);
                r5 = 0x6c59b0;
                stack[1999] = r4;
                stack[2034] = r4;
                asm { strd       r1, r6, [sp, #0xc0 + var_2C] };
                r1 = sp + 0x9c;
                asm { stm.w      r1, {r2, r5, fp} };
                r0 = objc_msgSend(r0, r10, sp + 0x90, r3, stack[1998], stack[1999], stack[2000], stack[2001], stack[2002], stack[2003], stack[2004], stack[2005], stack[2006], stack[2007], stack[2008], stack[2009], stack[2010], stack[2011], stack[2012], stack[2013], stack[2014], stack[2015], stack[2016], stack[2017], stack[2018], stack[2019], stack[2020], stack[2021], stack[2022], stack[2023]);
                r8 = 0x0;
                r6 = 0x7092d0;
                r5 = @selector(array);
                r0 = objc_msgSend(*r6, r5);
                stack[2001] = r0;
                r2 = 0xc2000000;
                r1 = 0x22d;
                stack[2025] = r4;
                asm { strd       r2, r8, [sp, #0xc0 + var_50] };
                stack[2028] = r1 + 0x3580c0;
                r2 = sp + 0x6c;
                r1 = 0x6c59d0;
                asm { strd       r1, fp, [sp, #0xc0 + var_44] };
                r8 = stack[2006];
                stack[2033] = r8;
                stack[2031] = r0;
                stack[2032] = stack[2005];
                r0 = objc_msgSend(arg_4, r10, r2, r3, stack[1998], stack[1999], stack[2000], stack[2001], stack[2002], stack[2003], stack[2004], stack[2005], stack[2006], stack[2007], stack[2008], stack[2009], stack[2010], stack[2011], stack[2012], stack[2013], stack[2014], stack[2015], stack[2016], stack[2017], stack[2018], stack[2019], stack[2020], stack[2021], stack[2022], stack[2023]);
                stack[2000] = objc_msgSend(*r6, r5);
                r5 = [NSMutableDictionary dictionary];
                stack[2004] = r5;
                stack[1998] = @selector(class);
                r0 = [stack[2003] class];
                r0 = [r0 dynamicClassPropertyInfos:arg_8];
                stack[2014] = r4;
                stack[2015] = 0xc2000000;
                stack[2016] = 0x0;
                r2 = sp + 0x54;
                stack[2017] = 0x358541;
                stack[2018] = 0x6c5cf0;
                r1 = stack[2005];
                asm { stm.w      r2, {r1, r6, fp} };
                r1 = r5;
                r2 = sp + 0x40;
                stack[2024] = r8;
                r8 = stack[2000];
                asm { strd       r8, r1, [sp, #0xc0 + var_60] };
                r4 = stack[2001];
                r0 = objc_msgSend(r0, r10, r2, r3, stack[1998], stack[1999], stack[2000], stack[2001], stack[2002], stack[2003], stack[2004]);
                if (([r4 count] == 0x0) && ([r8 count] == 0x0)) {
                    r5 = 0x0;
                }
                else {
                    r1 = 0x36dbc6;
                    r0 = 0x359e21;
                    stack[2007] = stack[1999];
                    stack[2008] = 0xc2000000;
                    r2 = 0x0;
                    asm { strd       r2, r0, [sp, #0xc0 + var_94] };
                    r1 = r1 + 0x35818a;
                    r0 = sp + 0x34;
                    asm { stm.w      r0, {r1, r4, r8} };
                    r5 = imp_implementationWithBlock(sp + 0x24);
                    r6 = sel_registerName(".cxx_destruct");
                    r0 = objc_msgSend(@"v@:", stack[2002]);
                    r0 = class_addMethod(r11, r6, r5, r0);
                    r5 = 0x1;
                }
                if ((stack[2006] & 0xff) != 0x0) {
                    r0 = _OCSBuildClassIvarLayout(r11, r4, r8);
                    r0 = objc_registerClassPair(r11);
                    r0 = _OCSSetupDynamicClassARC(r11);
                }
                else {
                    r0 = objc_registerClassPair(r11);
                }
                if (r5 == 0x1) {
                    asm { moveq      r0, fp };
                }
                if (CPU_FLAGS & E) {
                    r0 = _OCSSetupDynamicClassCXX(r0);
                }
                if ([stack[2004] count] != 0x0) {
                    r5 = objc_getAssociatedObject(r11, _OCSSpecialStructPropertyCached);
                    if ((r5 == 0x0) || (([r5 isKindOfClass:[NSDictionary class]] & 0xff) == 0x0)) {
                        r0 = objc_setAssociatedObject(r11, _OCSSpecialStructPropertyCached, stack[2004], 0x303);
                    }
                }
            }
            else {
                r11 = 0x0;
            }
        }
        else {
            r2 = 0x3582ad;
            r4 = __NSConcreteStackBlock;
            r1 = 0xc2000000;
            r0 = arg_C;
            r10 = @selector(enumerateObjectsUsingBlock:);
            r5 = 0x6c59b0;
            stack[1999] = r4;
            stack[2034] = r4;
            asm { strd       r1, r6, [sp, #0xc0 + var_2C] };
            r1 = sp + 0x9c;
            asm { stm.w      r1, {r2, r5, fp} };
            r0 = objc_msgSend(r0, r10, sp + 0x90, r3, stack[1998], stack[1999], stack[2000], stack[2001], stack[2002], stack[2003], stack[2004], stack[2005], stack[2006], stack[2007], stack[2008], stack[2009], stack[2010], stack[2011], stack[2012], stack[2013], stack[2014], stack[2015], stack[2016], stack[2017], stack[2018], stack[2019], stack[2020], stack[2021], stack[2022], stack[2023]);
            r8 = 0x0;
            r6 = 0x7092d0;
            r5 = @selector(array);
            r0 = objc_msgSend(*r6, r5);
            stack[2001] = r0;
            r2 = 0xc2000000;
            r1 = 0x22d;
            stack[2025] = r4;
            asm { strd       r2, r8, [sp, #0xc0 + var_50] };
            stack[2028] = r1 + 0x3580c0;
            r2 = sp + 0x6c;
            r1 = 0x6c59d0;
            asm { strd       r1, fp, [sp, #0xc0 + var_44] };
            r8 = stack[2006];
            stack[2033] = r8;
            stack[2031] = r0;
            stack[2032] = stack[2005];
            r0 = objc_msgSend(arg_4, r10, r2, r3, stack[1998], stack[1999], stack[2000], stack[2001], stack[2002], stack[2003], stack[2004], stack[2005], stack[2006], stack[2007], stack[2008], stack[2009], stack[2010], stack[2011], stack[2012], stack[2013], stack[2014], stack[2015], stack[2016], stack[2017], stack[2018], stack[2019], stack[2020], stack[2021], stack[2022], stack[2023]);
            stack[2000] = objc_msgSend(*r6, r5);
            r5 = [NSMutableDictionary dictionary];
            stack[2004] = r5;
            stack[1998] = @selector(class);
            r0 = [stack[2003] class];
            r0 = [r0 dynamicClassPropertyInfos:arg_8];
            stack[2014] = r4;
            stack[2015] = 0xc2000000;
            stack[2016] = 0x0;
            r2 = sp + 0x54;
            stack[2017] = 0x358541;
            stack[2018] = 0x6c5cf0;
            r1 = stack[2005];
            asm { stm.w      r2, {r1, r6, fp} };
            r1 = r5;
            r2 = sp + 0x40;
            stack[2024] = r8;
            r8 = stack[2000];
            asm { strd       r8, r1, [sp, #0xc0 + var_60] };
            r4 = stack[2001];
            r0 = objc_msgSend(r0, r10, r2, r3, stack[1998], stack[1999], stack[2000], stack[2001], stack[2002], stack[2003], stack[2004]);
            if (([r4 count] == 0x0) && ([r8 count] == 0x0)) {
                r5 = 0x0;
            }
            else {
                r1 = 0x36dbc6;
                r0 = 0x359e21;
                stack[2007] = stack[1999];
                stack[2008] = 0xc2000000;
                r2 = 0x0;
                asm { strd       r2, r0, [sp, #0xc0 + var_94] };
                r1 = r1 + 0x35818a;
                r0 = sp + 0x34;
                asm { stm.w      r0, {r1, r4, r8} };
                r5 = imp_implementationWithBlock(sp + 0x24);
                r6 = sel_registerName(".cxx_destruct");
                r0 = objc_msgSend(@"v@:", stack[2002]);
                r0 = class_addMethod(r11, r6, r5, r0);
                r5 = 0x1;
            }
            if ((stack[2006] & 0xff) != 0x0) {
                r0 = _OCSBuildClassIvarLayout(r11, r4, r8);
                r0 = objc_registerClassPair(r11);
                r0 = _OCSSetupDynamicClassARC(r11);
            }
            else {
                r0 = objc_registerClassPair(r11);
            }
            if (r5 == 0x1) {
                asm { moveq      r0, fp };
            }
            if (CPU_FLAGS & E) {
                r0 = _OCSSetupDynamicClassCXX(r0);
            }
            if ([stack[2004] count] != 0x0) {
                r5 = objc_getAssociatedObject(r11, _OCSSpecialStructPropertyCached);
                if ((r5 == 0x0) || (([r5 isKindOfClass:[NSDictionary class]] & 0xff) == 0x0)) {
                    r0 = objc_setAssociatedObject(r11, _OCSSpecialStructPropertyCached, stack[2004], 0x303);
                }
            }
        }
    }
    r0 = r11;
    sp = sp + 0xa8;
    return r0;
}
 */
 
+ (BOOL)dynamicClassAddProperty:(Class)cls property:(id)property {
    
}

+ (id)dynamicClassPropertyInfos:(NSArray *)propertyInfos {
    NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSet];
    [propertyInfos enumerateObjectsUsingBlock:^(OCSProperty * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        _OCSCopyPropertyAttributes([obj.propertyName UTF8String], [obj.typeEncode UTF8String]);
    }];
}

@end
