//
//  UTResponse.m
//  MobileUU
//
//  Created by dcj on 15/8/12.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTResponse.h"
#import "NSURLRequest+UTNetWorkingMethod.h"
#import "UTObject+UTNetWorkingMethod.h"
@implementation UTResponse

-(instancetype)initWithData:(NSData *)data{
    if (self = [super init]) {
        self.isCache = YES;
        self.requestID = 0;
        self.contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.responseRequest = nil;
        self.responseStatus = [self responseStatusWithError:nil];
        self.requestData = data;
        self.contentData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    }
    return self;
}

-(instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error{
    if (self = [super init]) {
        self.contentString = [responseString UTDefaultValueWithValue:@""];
        if (responseData) {
            self.contentData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        }else{
            self.contentData = nil;
        }
        self.responseRequest = request;
        self.requestID = [requestId integerValue];
        self.requestParams = request.requestParams;
        self.isCache = NO;
        self.requestData = responseData;
        self.responseStatus = [self responseStatusWithError:error];
        self.error = error;
        
    }
    return self;
}
-(instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData status:(UTURLResponseStatus)status{
    if (self = [super init]) {
        self.contentString = responseString;
        if (responseData) {
            self.contentData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        }
        self.responseRequest = request;
        self.requestID = [requestId integerValue];
        self.requestParams = _requestParams;
        self.isCache = NO;
        self.requestData = responseData;
        self.responseStatus = [self responseStatusWithError:nil];
    }
    return self;
}

-(UTURLResponseStatus)responseStatusWithError:(NSError *)error{
    if (error) {
        if (error.code == NSURLErrorTimedOut) {
            return UTURLResponseStatusTimeOut;
        }else{
            return UTURLResponseStatusSucess;
        }
    }else{
        return UTURLResponseStatusSucess;
    }
}


@end
