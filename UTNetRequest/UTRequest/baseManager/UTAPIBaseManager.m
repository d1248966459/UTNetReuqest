//
//  UTAPIBaseManager.m
//  MobileUU
//
//  Created by dcj on 15/8/11.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTAPIBaseManager.h"
#import "UTCache.h"
#import "UTDataProvider.h"
#import "AFNetworkReachabilityManager.h"
#import "Reachability.h"
#import "UTErrorInterceptorHandler.h"

#import "AFNetworking.h"
 static void *kQueueNameKey = (__bridge void *)@"kQueueNameKey";

dispatch_queue_t dispatch_create_serial_queue_for_name(const char * name)
{
    dispatch_queue_t customQueue = dispatch_queue_create(name, NULL);
    dispatch_queue_set_specific(customQueue, kQueueNameKey, (void *)(name), NULL);
    return customQueue;
}
@interface UTAPIBaseManager ()

@property (nonatomic,strong) UTCache * apiCache;
@property (nonatomic,strong) NSMutableArray * requestList;
@property (nonatomic,strong,readwrite) id rawData;




@end

@implementation UTAPIBaseManager

-(UTCache *)apiCache{
    if (_apiCache == nil) {
        _apiCache = [UTCache sharedInstance];
    }
    return _apiCache;
}
-(NSMutableArray *)requestList{
    if (_requestList == nil) {
        _requestList = [NSMutableArray array];
    }
    return _requestList;
}


-(void)cacleAllRequests{
    [[UTDataProvider sharedInstance] cacleRequestWithRequestIDList:self.requestList];
    [self.requestList removeAllObjects];
}
-(void)cacleRequestWtihRequestID:(NSInteger)requestID{
    [self removeRequestWithRequestID:requestID];
    [[UTDataProvider sharedInstance] cacleRequestWithRequestID:@(requestID)];
}
-(void)removeRequestWithRequestID:(NSInteger)requestID{
    NSNumber * toRemoveRequestID = nil;
    for (NSNumber * tempRequestID in self.requestList) {
        if ([tempRequestID integerValue] == requestID) {
            toRemoveRequestID = tempRequestID;
        }
    }
    if (toRemoveRequestID) {
        [self.requestList removeObject:toRemoveRequestID];
    }
}
-(void)beforePreformSucessWithResponse:(UTResponse *)response{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:berforePreformSucessWithResponse:)]) {
        [self.interceptor manager:self berforePreformSucessWithResponse:response];
    }
}
-(void)afterPreformSucessWithResponse:(UTResponse *)response{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPreformSucessWithResponse:)]) {
        [self.interceptor manager:self afterPreformSucessWithResponse:response];
    }
}
-(void)beforePreformFailedWithResponse:(UTResponse *)response{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePreformFailedWithResponse:)]) {
        [self.interceptor manager:self beforePreformFailedWithResponse:response];
    }
}
-(void)afterPreformFailedWithResponse:(UTResponse *)response{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPreformFailedWithResponse:)]) {
        [self.interceptor manager:self afterPreformFailedWithResponse:response];
    }
}
-(BOOL)shouldCallAPIWithBodyParams:(NSDictionary *)bodyParams headParams:(NSDictionary *)headParams{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithBodyParams:headParams:)]) {
        return [self.interceptor manager:self shouldCallAPIWithBodyParams:bodyParams headParams:headParams];
    }else{
        return YES;
    }
}
-(void)afterCallingAPIWithBodyParams:(NSDictionary *)bodyParams headParams:(NSDictionary *)headParams{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithBodyParams:headParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithBodyParams:bodyParams headParams:headParams];
    }

}


-(void)cleanData{
    IMP childIMP = [self.child methodForSelector:@selector(cleanData)];
    IMP selfIMP = [self methodForSelector:@selector(cleanData)];
    if (childIMP == selfIMP) {
        self.errorMessage = nil;
        self.managerErrorType = UTAPIManagerRequestTypeDelet;
    }else{
        if ([self.child respondsToSelector:@selector(cleanData)]) {
             [self.child cleanData];
        }
    }
}

-(NSInteger)loadData{
    NSDictionary * bodyParams =[self.paramSource bodyparmsForAPIManager:self];
    NSDictionary * headParams = [self.paramSource headParamsForApiManager:self];
    NSInteger requestID = [self loadDataWithBodyParams:bodyParams headParams:headParams];
    return requestID;
}

-(NSInteger)loadDataWithBodyParams:(NSDictionary *)bodyParams headParams:(NSDictionary *)headparams{
    NSInteger requestID = 0;
    NSDictionary * apiparams = [self reformParams:bodyParams];
    if ([self shouldCallAPIWithBodyParams:bodyParams headParams:headparams]) {
        if ([self.validator manager:self isCorrectParams:apiparams]) {
            if ([self shouldCache]&&[self hasCacheWithParams:apiparams]) {
                return 0;
            }
            if ([self isReachable]) {
                
                requestID = [self callApiWithserviceType:self.child.serviceType requestParams:bodyParams headParams:headparams requestType:self.child.requestType];
                
                NSMutableDictionary * mutableApiParams = [apiparams mutableCopy];
                mutableApiParams[@"requestID"] = @(requestID);
                [self afterCallingAPIWithBodyParams:bodyParams headParams:headparams];
                return requestID;
            }else{
                
                [self faileOnCallingApiWithResponse:nil andErrorType:UTAPIManagerErrorTypeNoContent];
                return requestID;
            }
        }else{
            [self faileOnCallingApiWithResponse:nil andErrorType:UTAPIManagerErrorTypeParamsError];
            return requestID;
        }

    }
    return requestID;
}
-(void)faileOnCallingApiWithResponse:(UTResponse *)response andErrorType:(UTAPIManagerErrorType)errorType{
    
    NSError * utError = [[UTErrorInterceptorHandler sharedInstance] findeErrorWithResponse:response manager:self];
    !response.error?response.error = utError:nil;
    self.managerErrorType = errorType;
    [self removeRequestWithRequestID:0];
    [self.didCallBackDelegate managerApiCallBackDidFailed:self response:response];
    [self beforePreformFailedWithResponse:response];

}

-(void)sucessOnCallingApiWithResponse:(UTResponse *)response{

    [self removeRequestWithRequestID:0];
    if ([self.validator manager:self isCorrectData:response]) {
        /**
         *  请求成功之后缓存入 内存 默认 不缓存
         */
        if ([self shouldCache] && !response.isCache) {
            [[UTCache sharedInstance] savedatatoCacheWithData:response.requestData MethodName:[self.child methodName] requestParams:response.requestParams];
        }
        
        [self beforePreformSucessWithResponse:response];
        [self.didCallBackDelegate managerApiCallBackDidSucess:self response:response];
        [self afterPreformSucessWithResponse:response];
    }else{
        [self faileOnCallingApiWithResponse:response andErrorType:UTAPIManagerErrorTypeNoContent];
    }
    
}

-(NSDictionary *)reformParams:(NSDictionary *)params{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    if (childIMP == selfIMP) {
        return params;
    }else{
        NSDictionary * result = [self.child reformParams:params];
        if (result) {
            return result;
        }else{
            return params;
        }
    }
    return nil;
}

-(BOOL)shouldCache{
    return UT_shouldCache;
}
-(BOOL)isReachable{
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    if (status == AFNetworkReachabilityStatusNotReachable) {
        self.managerErrorType = UTAPIManagerErrorTypeNoContent;
        return NO;
    }else{
        return YES;
    }
}
-(BOOL)hasCacheWithParams:(NSDictionary *)params{
    NSData * result = [self.apiCache readDataFromCacheWithMethodName:self.child.methodName requestParams:params];
    if (result == nil) {
        return NO;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UTResponse * response = [[UTResponse alloc] initWithData:result];
        response.requestParams = params;
    });
    
    return YES;
}

-(NSInteger)callApiWithserviceType:(NSString *)serviceType requestParams:(NSDictionary *)requestParams headParams:(NSDictionary *)headParams requestType:(UTAPIManagerRequestType)requestType{
    
    NSInteger requestID = [[UTDataProvider sharedInstance] callApiWithRequestType:requestType serviceType:serviceType requestParams:requestParams methodName:self.child.methodName headParams:headParams sucessCallback:^(UTResponse *response) {
        [self sucessOnCallingApiWithResponse:response];

    } failedCallback:^(UTResponse *response) {
        [self faileOnCallingApiWithResponse:response andErrorType:UTAPIManagerErrorTypeDefault];

    }];
    
    return requestID;
}

-(void)https{
    NSURL * url = [NSURL URLWithString:@"https://www.google.com"];
    AFHTTPRequestOperationManager * requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    dispatch_queue_t requestsQueue = dispatch_create_serial_queue_for_name("kRequestCompletionQueue");
    requestOperationManager.completionQueue = requestsQueue;
    
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = YES;
    
    //validatesCertificateChain 是否验证整个证书链，默认为YES
    //设置为YES，会将服务器返回的Trust Object上的证书链与本地导入的证书进行对比，这就意味着，假如你的证书链是这样的：
    //GeoTrust Global CA
    //    Google Internet Authority G2
    //        *.google.com
    //那么，除了导入*.google.com之外，还需要导入证书链上所有的CA证书（GeoTrust Global CA, Google Internet Authority G2）；
    //如是自建证书的时候，可以设置为YES，增强安全性；假如是信任的CA所签发的证书，则建议关闭该验证，因为整个证书链一一比对是完全没有必要（请查看源代码）；
    securityPolicy.validatesCertificateChain = NO;
    
    requestOperationManager.securityPolicy = securityPolicy;
}


@end
