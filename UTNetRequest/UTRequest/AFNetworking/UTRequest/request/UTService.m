//
//  UTService.m
//  MobileUU
//
//  Created by dcj on 15/8/13.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTService.h"

@implementation UTService

-(instancetype)init{
    if (self = [super init]) {
        self.child = (id<UTServiceProtocol>)self;
    }
    return self;
}

-(NSString *)urlString{

    return [self.child apiBaseUrl];
}
-(NSString *)version{
    return [self.child apiVersion];
}

@end
