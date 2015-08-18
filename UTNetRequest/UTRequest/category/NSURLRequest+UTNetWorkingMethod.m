//
//  NSURLRequest+UTNetWorkingMethod.m
//  MobileUU
//
//  Created by dcj on 15/8/12.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "NSURLRequest+UTNetWorkingMethod.h"
#import <objc/runtime.h>

static char UTRequestParamsKey;

@implementation NSURLRequest (UTNetWorkingMethod)

-(void)setRequestParams:(NSDictionary *)requestParams{
    objc_setAssociatedObject(self, &UTRequestParamsKey, requestParams, OBJC_ASSOCIATION_COPY);
}

-(NSDictionary *)requestParams{

    return objc_getAssociatedObject(self, &UTRequestParamsKey);
}

@end
