//
//  UTServiceFactory.h
//  MobileUU
//
//  Created by dcj on 15/8/13.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTObject.h"

@class UTService;

@interface UTServiceFactory : UTObject
+(instancetype)sharedInstance;

-(UTService *)serviceWithIdenfity:(NSString *)idenfity;


@end
