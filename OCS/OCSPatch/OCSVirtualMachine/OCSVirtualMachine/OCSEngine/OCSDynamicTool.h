//
//  OCSDynamicTool.h
//  Simple
//
//  Created by Xummer on 2017/6/5.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCSDynamicTool : NSObject

+ (void)sendMessageWithReceiver:(id)receiver result:(void*)result selector:(SEL)selector argptr:(void*)argptr;

@end
