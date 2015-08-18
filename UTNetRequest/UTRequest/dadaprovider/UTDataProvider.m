//
//  UTDataProvider.m
//  MobileUU
//
//  Created by dcj on 15/8/12.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTDataProvider.h"
#import "UTRequestFactory.h"
#import "AFNetworking.h"
#import "UTResponse.h"
#import "UTNetWorkGlobalVariable.h"

@interface UTDataProvider ()

@property (nonatomic,assign) NSNumber * recordedRequestId;
@property (nonatomic,strong) AFHTTPRequestOperationManager * manager;
@property (nonatomic,strong) NSMutableDictionary * dispatchTable;




@end


@implementation UTDataProvider

-(AFHTTPRequestOperationManager *)manager{
    if (_manager == nil) {
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _manager;
}

-(NSMutableDictionary *)dispatchTable{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

+(instancetype)sharedInstance{
    static UTDataProvider *provider;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (provider == nil) {
            provider = [[UTDataProvider alloc] init];
        }
    });
    return provider;
}


-(void)cacleRequestWithRequestIDList:(NSMutableArray *)requestIDList{
    for (NSNumber *requestID in requestIDList) {
        [self cacleRequestWithRequestID:requestID];
    }
}
-(void)cacleRequestWithRequestID:(NSNumber *)requestID{
    NSOperation * operation = self.dispatchTable[requestID];
    [operation cancel];
    [self.dispatchTable removeObjectForKey:requestID];

}

-(NSInteger)callApiWithRequestType:(UTAPIManagerRequestType)requestType serviceType:(NSString *)serviceType requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName headParams:(NSDictionary *)headParams sucessCallback:(UTRequestCallBack)sucess failedCallback:(UTRequestCallBack)failed{
    NSURLRequest * request;
    
    switch (requestType) {
        case UTAPIManagerRequestTypeGet:
             request = [[UTRequestFactory sharedInstnce] generatorGETRequestWithMetohdName:methodName requestParams:requestParams headParams:headParams serviceType:serviceType];
            break;
        case UTAPIManagerRequestTypePost:
            request = [[UTRequestFactory sharedInstnce] generatorPOSTRequestWithMetohdName:methodName requestParams:requestParams headParams:headParams serviceType:serviceType];
        default:
            break;
    }
    
    NSNumber * requestID = [self requestDataWithRequest:request callBackSucess:sucess callBackFailed:failed];
    
    return [requestID integerValue];
}


-(NSNumber *)requestDataWithRequest:(NSURLRequest *)request callBackSucess:(UTRequestCallBack)sucess callBackFailed:(UTRequestCallBack)failed{

    NSNumber * reuqestID = [self generateRequestId];
    AFHTTPRequestOperation * operation = [self.manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        AFHTTPRequestOperation * tempOperation = self.dispatchTable[reuqestID];
        if (tempOperation == nil) {
            return;
        }else{
            [self.dispatchTable removeObjectForKey:reuqestID];
        }
        UTResponse * tempResponse = [[UTResponse alloc] initWithResponseString:operation.responseString requestId:reuqestID request:operation.request responseData:operation.responseData status:UTURLResponseStatusSucess];
        sucess?sucess(tempResponse):nil;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        AFHTTPRequestOperation * tempOperation = self.dispatchTable[reuqestID];
        if (tempOperation == nil) {
            return ;
        }else{
            [self.dispatchTable removeObjectForKey:reuqestID];
        }
        UTResponse *tempResponse = [[UTResponse alloc] initWithResponseString:operation.responseString requestId:reuqestID request:operation.request responseData:operation.responseData error:error];
        failed?failed(tempResponse):nil;
    }];
    self.dispatchTable[reuqestID] = operation;
    [self.manager.operationQueue addOperation:operation];
    return reuqestID;
}


- (NSNumber *)generateRequestId
{
    if (_recordedRequestId == nil) {
        _recordedRequestId = @(1);
    } else {
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        } else {
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}






@end
