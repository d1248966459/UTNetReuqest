//
//  UTErrorInterceptorHandler.h
//  MobileUU
//
//  Created by dcj on 15/8/17.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTObject.h"
@class UTResponse;
@class UTAPIBaseManager;
@interface UTErrorInterceptorHandler : UTObject

+(instancetype)sharedInstance;

-(NSError *)findeErrorWithResponse:(UTResponse *)response manager:(UTAPIBaseManager *)manager;


@end
