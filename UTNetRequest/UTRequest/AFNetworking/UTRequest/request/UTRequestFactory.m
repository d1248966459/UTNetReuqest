//
//  UTRequestFactory.m
//  MobileUU
//
//  Created by dcj on 15/8/13.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTRequestFactory.h"
#import "AFNetworking.h"
#import "NSURLRequest+UTNetWorkingMethod.h"
#import "UTServiceFactory.h"
#import "UTNetWorkGlobalVariable.h"
#import "UTService.h"

@interface UTRequestFactory ()

@property (nonatomic,strong) AFHTTPRequestSerializer * requestSerializer;

@end

@implementation UTRequestFactory


-(AFHTTPRequestSerializer *)requestSerializer{
    if (_requestSerializer == nil) {
        _requestSerializer = [AFHTTPRequestSerializer serializer];
        _requestSerializer.timeoutInterval = 20;
        _requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _requestSerializer;
}

+(instancetype)sharedInstnce{
    static UTRequestFactory *requestFacetory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestFacetory == nil) {
            requestFacetory = [[UTRequestFactory alloc] init];
        }
    });
    return requestFacetory;
}

-(NSURLRequest *)generatorGETRequestWithMetohdName:(NSString *)methodName requestParams:(NSDictionary *)requestParams headParams:(NSDictionary *)headParams serviceType:(NSString *)serviceType{
    NSMutableDictionary *head_dicUB = [AppControlManager getSTHeadDictionary:headParams];
    UTService * service = [[UTServiceFactory sharedInstance] serviceWithIdenfity:serviceType];
   
    NSString * urlString;

    if (service.version) {
        urlString = [NSString stringWithFormat:@"%@%@%@",service.urlString,service.version,methodName];
    }else{
        urlString = [NSString stringWithFormat:@"%@%@",service.urlString,methodName];
    }
    
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    request.HTTPMethod = @"GET";
    [head_dicUB enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:NSJSONWritingPrettyPrinted error:NULL];
    request.requestParams = requestParams;
    
    return request;
}

-(NSURLRequest *)generatorPOSTRequestWithMetohdName:(NSString *)methodName requestParams:(NSDictionary *)requestParams headParams:(NSDictionary *)headParams serviceType:(NSString *)serviceType{
    NSMutableDictionary *head_dicUB = [AppControlManager getSTHeadDictionary:headParams];
    
    UTService * service = [[UTServiceFactory sharedInstance] serviceWithIdenfity:serviceType];
    NSString * urlString;
    if (service.version) {
        urlString = [NSString stringWithFormat:@"%@%@%@",service.urlString,service.version,methodName];
    }else{
        urlString = [NSString stringWithFormat:@"%@%@",service.urlString,methodName];
    }
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    request.HTTPMethod = @"POST";
    [head_dicUB enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    if (requestParams) {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:NSJSONWritingPrettyPrinted error:NULL];
    }
    request.requestParams = requestParams;

    return request;
}

@end
