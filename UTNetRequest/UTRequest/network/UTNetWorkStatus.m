//
//  UTNetWorkStatus.m
//  MobileUU
//
//  Created by dcj on 15/8/17.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTNetWorkStatus.h"

@implementation UTNetWorkStatus

+(instancetype)sharedInstance{
    static UTNetWorkStatus * netWorkStatus;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (netWorkStatus == nil) {
            netWorkStatus = [[UTNetWorkStatus alloc] init];
        }
    });
    return netWorkStatus;
}



@end
