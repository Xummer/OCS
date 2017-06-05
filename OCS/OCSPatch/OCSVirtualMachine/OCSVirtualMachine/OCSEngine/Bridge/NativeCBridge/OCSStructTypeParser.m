//
//  OCSStructTypeParser.m
//  OCS
//
//  Created by Xummer on 2017/3/13.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSStructTypeParser.h"
#import "OCSStructTypeI.h"
#import "OCSTypeStruct.h"
#import "OCSTypyBase.h"

@interface NSString (OCSStruct)

- (BOOL)isStruct;

@end

@implementation NSString (OCSStruct)

- (BOOL)isStruct {
    return [self hasPrefix:@"{"] && [self hasSuffix:@"}"];
}

@end

@implementation OCSStructTypeParser

// https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
// {example=@*i}

+ (NSString *)findStructS:(NSString *)structType {
    const char *sType = [structType UTF8String];
    
    NSUInteger left = 0, right = 0, leftIndex = 0;
    for (NSUInteger i = 0; sType[i] != 0; i++) {
        switch (sType[i]) {
            case '{':
            {
                // loc_2a160a4
                if (left == 0) {
                    leftIndex = i + 1;
                }
                left ++;
            }
                break;
            case '}':
            {
                // loc_2a160ae
                right ++;
            }
                break;
            default:
            {
                // loc_2a160b0
            }
                break;
        }
        
        // loc_2a160b0
        if (left == 0 || left != right) {
            // loc_2a16096
            continue;
        }
        else {
            // loc_2a160ba
            return [structType substringWithRange:NSMakeRange(leftIndex, i - leftIndex)];
        }
    }
    
    return nil;
}

+ (OCSStructTypeI *)makeStructType:(NSString *)structType {
    NSString *structS = [[self class] findStructS:structType];
    return [[self class] getStructType:structS];
}

+ (OCSTypeStruct *)parseStructEncode:(NSString *)structEncode {
    OCSStructTypeI *structTypeI =
    [OCSStructTypeParser makeStructType:structEncode];
    
    [structTypeI memberEncodes];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    OCSTypeStruct *typeStruct = [[OCSTypeStruct alloc] initWithEncode:structEncode];
    
    typeStruct.name = structTypeI.name;
    
    NSArray *mEncodes = [structTypeI memberEncodes];
    
    for (NSString *mEncode in mEncodes) {
        OCSTypyCommon *typy = nil;
        if ([mEncode isStruct]) {
            typy = [[self class] parseStructEncode:mEncode];
        }
        else {
            typy = [[OCSTypyBase alloc] initWithEncode:mEncode];
            [typy countValueAndMakeFfi_type];
        }
        [arr addObject:typy];
    }
    
    typeStruct.memberStructSizeValues = [NSArray arrayWithArray:arr];
    [typeStruct countValueAndMakeFfi_type];
    
    return typeStruct;
    
}

+ (OCSStructTypeI *)getStructType:(NSString *)structS {
    const char *sType = [structS UTF8String];
    BOOL bFound = NO;
    
    // loc_2a15c72
    NSUInteger i = 0;
    for (; sType[i] != 0; i++) {
        if (sType[i] == '=') {
            bFound = YES;
            break;
        }
    }
    
    if (bFound) {
        OCSStructTypeI *structTypeI = [OCSStructTypeI new];
        
        structTypeI.name = [structS substringWithRange:NSMakeRange(0, i)];
        structTypeI.impEncode = [structS substringWithRange:NSMakeRange(i + 1, [structS length] - i - 1)];
        return structTypeI;
    }
    else {
        return nil;
    }
}

+ (NSArray *)componentsOfMembersEncode:(NSString *)mEncode {
    const char *memE = [mEncode UTF8String];
    
    NSMutableArray *arrComponents = [NSMutableArray array];
    
    NSString *tmpE;
    NSUInteger i = 0;
    NSString *structS;
    
    for (;;) {
        if (memE[i] == '{') {
            structS = [[self class] findStructS:[mEncode substringFromIndex:i]];
            [arrComponents addObject:structS];
        }
        else {
            tmpE = [mEncode substringFromIndex:i];
            if (tmpE) {
                NSUInteger location = [tmpE rangeOfString:@"{"].location;
                if (location != NSNotFound) {
                    // ??
                    structS = [tmpE substringToIndex:location];
                }
                else {
                    structS = tmpE;
                }
            }
            else {
                // ??
                structS = [tmpE substringToIndex:0];
            }
            
            for (NSUInteger j = 0; j < structS.length; j ++) {
                tmpE = [structS substringWithRange:NSMakeRange(j, 1)];
                [arrComponents addObject:tmpE];
            }
        }
        
        if (structS.length + i >= mEncode.length) {
            break;
        }
        
        i += structS.length;
    }
    
    return [NSArray arrayWithArray:arrComponents];;
}

@end
