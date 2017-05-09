//
//  QQLuaPluginManager.m
//  OCS
//
//  Created by Xummer on 2017/3/2.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "QQLuaPluginManager.h"

@implementation QQLuaPluginManager

- (BOOL)patchOcsScripts:(id)ocsriptsId {
    [[NSDate date] timeIntervalSince1970];
    NSString *path = [self getTempLuaPluginRunningDirById:ocsriptsId];
    NSError *error = nil;
    NSArray<NSString *> *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    for (NSString *content in contents) {
        if ([content hasSuffix:@".64.ocs"]) {
            NSString *newContent = [content stringByReplacingOccurrencesOfString:@".64.ocs" withString:@".32.patch"];
            [NSString stringWithFormat:[NSString stringWithUTF8String:"%@/%@"], path, newContent];
            
        }
    }
}

- (id)getTempLuaPluginRunningDirById:(id)tempId {
    
}

@end
