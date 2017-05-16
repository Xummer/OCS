//
//  OCSInnerException.m
//  OCS
//
//  Created by Xummer on 2017/5/16.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSInnerException.h"

@implementation OCSInnerException

+ (id)exceptionWithActualException:(NSException *)exception
             currentOCSVMStackInfo:(id)stackInfo
{
    NSMutableString *infos = [NSMutableString new];
    NSArray<NSString *> *callStackInfo = [exception callStackSymbols];
    if (exception.reason) {
        [infos appendString:exception.reason];
    }
    if (stackInfo) {
        [infos appendFormat:@"\n currentOCSVMStackInfo:***%@", stackInfo];
    }
    
    if (callStackInfo) {
        [infos appendString:[stackInfo description]];
    }
    
    return
    [[OCSInnerException alloc] initWithName:@"OCSInnerException" reason:infos userInfo:@{@"OCSInnerExceptionActualExceptionKey": exception }];
}

//- (instancetype)actualException {
//    [[self userInfo] objectForKeyedSubscript:@"OCSInnerExceptionActualExceptionKey"];
//}

@end
