//
//  OCSStructTypeParser.m
//  OCS
//
//  Created by Xummer on 2017/3/13.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSStructTypeParser.h"
#import "OCSStructTypeI.h"

@implementation OCSStructTypeParser

// https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
// {example=@*i}

+ (NSString *)findStructS:(NSString *)structType {
    const char *sType = [structType UTF8String];
    
    NSUInteger left, right;
    for (NSUInteger i = 0; sType[i] != 0; i++) {
        switch (sType[i]) {
            case '{':
            {
                // loc_2a160a4
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
            return [structType substringWithRange:NSMakeRange(<#NSUInteger loc#>, <#NSUInteger len#>)];
        }
    }
    
    return nil;
}

+ (id)makeStructType:(NSString *)structType {
    NSString *structS = [[self class] findStructS:structType];
    return [[self class] getStructType:structS];
}

+ (id)parseStructEncode:(NSString *)structEncode {
    [OCSStructTypeParser makeStructType:structEncode];
    // TODO
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
        structTypeI.impEncode = [structS substringWithRange:NSMakeRange(i + 1, [structS length] - 1)];
        return structTypeI;
    }
    else {
        return nil;
    }
}

+ (id)componentsOfMembersEncode:(NSString *)mEcode {
    
}

@end
