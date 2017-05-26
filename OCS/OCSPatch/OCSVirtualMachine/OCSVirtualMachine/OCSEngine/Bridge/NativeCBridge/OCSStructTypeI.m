//
//  OCSStructTypeI.m
//  OCS
//
//  Created by Xummer on 2017/3/13.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSStructTypeI.h"
#import "OCSStructTypeParser.h"

@implementation OCSStructTypeI

- (id)memberEncodes {
    return [OCSStructTypeParser componentsOfMembersEncode:self.impEncode];
}

@end
