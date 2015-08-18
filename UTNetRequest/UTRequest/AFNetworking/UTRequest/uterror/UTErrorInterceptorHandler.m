//
//  UTErrorInterceptorHandler.m
//  MobileUU
//
//  Created by dcj on 15/8/17.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTErrorInterceptorHandler.h"
#import "UTResponse.h"
#import "UTAPIBaseManager.h"
@implementation UTErrorInterceptorHandler

-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

+(instancetype)sharedInstance{
    static UTErrorInterceptorHandler *errorHandler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (errorHandler == nil) {
            errorHandler = [[UTErrorInterceptorHandler alloc] init];
        }
    });
    return errorHandler;
}

-(NSError *)findeErrorWithResponse:(UTResponse *)response manager:(UTAPIBaseManager *)manager{
    NSString * errroMsg = [NSString stringWithFormat:@"%@.response",[manager class]];;
    NSInteger errorCode;
    NSMutableDictionary * userInfo = [[NSMutableDictionary alloc] init];
    if (response.contentData) {
        errorCode = [response.contentData[@"code"] integerValue];
        [userInfo setValue:response.requestParams forKey:@"requestParams"];
        [userInfo setValue:response.responseRequest.URL forKey:@"requestUrl"];
        [userInfo setValue:response.contentString forKey:@"contentString"];
    }
    return [NSError errorWithDomain:errroMsg code:errorCode userInfo:userInfo];
}

@end
