//
//  OCSStructTypeI.h
//  OCS
//
//  Created by Xummer on 2017/3/13.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCSStructTypeI : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *impEncode;

- (id)memberEncodes;

@end
