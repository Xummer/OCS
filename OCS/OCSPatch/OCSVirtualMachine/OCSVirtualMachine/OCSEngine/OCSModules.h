//
//  OCSModules.h
//  OCS
//
//  Created by Xummer on 2017/5/31.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OCSProperty, OCSIvar;
@interface OCSClassInfo : NSObject
@property(strong, nonatomic) OCSClassInfo* supperClassInfo;
@property(strong, nonatomic) NSString* supperClass;
@property(strong, nonatomic) NSString* currentClass;
@property(strong, nonatomic) NSArray<OCSProperty *>* OCSPropertyList;
@property(strong, nonatomic) NSArray<OCSIvar *>* OCSIvarList;
@property(strong, nonatomic) NSArray<NSString * /* Protocol Name*/>* OCSRefProtocolList;
@property(assign, nonatomic) BOOL isARCClass;
@end


@class OCSProtocolMethod, OCSProtocolProperty;
@interface OCSProtocolInfo : NSObject
@property(strong, nonatomic) NSString* protocolName;
@property(strong, nonatomic) NSArray<NSString *>* OCSRefProtocolList;
@property(strong, nonatomic) NSArray<OCSProtocolMethod *>* OCSMethodList;
@property(strong, nonatomic) NSArray<OCSProtocolProperty *>* OCSPropertyList;
@end


@interface OCSPropertyInfo : NSObject
@property(assign, nonatomic) BOOL dynamic;
@property(assign, nonatomic) BOOL readonly;
@property(assign, nonatomic) BOOL weak;
@property(assign, nonatomic) SEL getter;
@property(assign, nonatomic) SEL setter;
@property(strong, nonatomic) NSString* ivar;
@property(strong, nonatomic) NSString* name;
@property(strong, nonatomic) NSString* type;
@property(assign, nonatomic) BOOL nonAtomic;
@property(assign, nonatomic) int memoryPolicy;
@end


@interface OCSProperty : NSObject
@property(strong, nonatomic) NSString* propertyName;
@property(strong, nonatomic) NSString* typeEncode;
@property(assign, nonatomic) NSString* geterSeterEncode;
@end


@interface OCSIvar : NSObject
@property(strong, nonatomic) NSString* ivarName;
@property(strong, nonatomic) NSString* typeEncode;
@property(assign, nonatomic) NSInteger lifeTime;
@end


@interface OCSProtocolProperty : NSObject
@property(strong, nonatomic) NSString* propertyName;
@property(strong, nonatomic) NSString* typeEncode;
@property(assign, nonatomic) BOOL isRequiredProperty;
@property(assign, nonatomic) BOOL isInstanceProperty;
@end


@interface OCSProtocolMethod : NSObject
@property(strong, nonatomic) NSString* methodName;
@property(strong, nonatomic) NSString* typeEncode;
@property(assign, nonatomic) BOOL isRequiredMethod;
@property(assign, nonatomic) BOOL isInstanceMethod;
@end


