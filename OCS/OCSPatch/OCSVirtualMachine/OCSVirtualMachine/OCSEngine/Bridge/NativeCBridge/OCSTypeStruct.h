//
//  OCSTypeStruct.h
//  OCS
//
//  Created by Xummer on 2017/5/27.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSTypyCommon.h"

@interface OCSTypeStruct : OCSTypyCommon

@property(strong, nonatomic) NSArray *memberStructSizeValues;
@property(strong, nonatomic) NSString *name;

- (void)makeFfi_type;
- (void)countValue;

@end
