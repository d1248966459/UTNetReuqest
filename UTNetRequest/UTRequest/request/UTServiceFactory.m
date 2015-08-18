//
//  UTServiceFactory.m
//  MobileUU
//
//  Created by dcj on 15/8/13.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTServiceFactory.h"
#import "UTNetWorkGlobalVariable.h"
#import "UTService.h"
#import "UTUserInfoService.h"

@interface UTServiceFactory ()

@property (nonatomic,strong) NSMutableDictionary * serviceStore;


@end

@implementation UTServiceFactory

+(instancetype)sharedInstance{
    static UTServiceFactory * serviceFactory;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (serviceFactory == nil) {
            serviceFactory = [[UTServiceFactory alloc] init];
        }
    });
    return serviceFactory;
}
-(NSMutableDictionary *)serviceStore{
    if (_serviceStore == nil) {
        _serviceStore = [[NSMutableDictionary alloc] init];
    }
    return _serviceStore;
}

-(UTService *)serviceWithIdenfity:(NSString *)idenfity{
    UTService * service = self.serviceStore[idenfity];
    if (service) {
    }else{
        service = [self newServieWithIdenfity:idenfity];
        self.serviceStore[idenfity] = service;
    }
    return service;
}
-(UTService *)newServieWithIdenfity:(NSString *)idenfity{
    if ([idenfity isEqualToString:UTServiceTypeUserinfo]) {
        return [[UTUserInfoService alloc] init];
    }
    return nil;
}

@end
