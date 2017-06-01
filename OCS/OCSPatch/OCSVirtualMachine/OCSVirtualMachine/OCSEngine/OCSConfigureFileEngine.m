//
//  OCSConfigureFileEngine.m
//  OCS
//
//  Created by Xummer on 2017/5/31.
//  Copyright © 2017年 Xummer. All rights reserved.
//

#import "OCSConfigureFileEngine.h"
#import "OCSDynamicClassTool.h"
#import "OCSModules.h"

@interface OCSConfigureFileEngine () {
    dispatch_queue_t _OCSConfigureFileQueue;
}

@end

@implementation OCSConfigureFileEngine

+ (instancetype)sharedInstance {
    static OCSConfigureFileEngine *_sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedEngine = [OCSConfigureFileEngine new];
    });
    
    return _sharedEngine;
}

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self->_OCSConfigureFileQueue = dispatch_queue_create("OCSConfigureFileEngine.queue", DISPATCH_QUEUE_SERIAL);
    
    return self;
}

- (void)recursiveSetupDynamicClass:(OCSClassInfo *)clsInfo {
    if (clsInfo) {
        [self recursiveSetupDynamicClass:[clsInfo supperClassInfo]];
        [OCSDynamicClassTool setupDynamicClass:clsInfo];
    }
}

- (void)runWithConfigure:(NSString *)configure configurefileNames:(NSArray *)fileNames errorCode:(NSUInteger *)errorCode {
    dispatch_sync(self->_OCSConfigureFileQueue, ^{
        
#if __LP64__
        NSMutableDictionary *x20 = [NSMutableDictionary new];
        NSMutableDictionary *x19 = [NSMutableDictionary new];
        
        for (NSString *fileName in fileNames) {
            _OCSGetClassProtocolExtend(configure, fileName, x20, x19);
            
            [x22 enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
            }];
        }
#endif
        
    });
}


@end
