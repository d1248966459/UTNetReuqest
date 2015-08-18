//
//  UTUserInfoApiManager.m
//  MobileUU
//
//  Created by dcj on 15/8/13.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTUserInfoApiManager.h"

@interface UTUserInfoApiManager ()

@property(nonatomic,copy,nonnull) Completion com;

@end

@implementation UTUserInfoApiManager


-(instancetype)init{
    if (self = [super init]) {
        self.paramSource = self;
        self.validator = self;
        self.interceptor = self;
        self.didCallBackDelegate = self;
        self.child = self;
    }
    return self;
}

-(NSString *)methodName{
    return struser_detailinfo;
}
-(NSString *)serviceType{
    return UTServiceTypeUserinfo;
}
-(UTAPIManagerRequestType)requestType{
    return UTAPIManagerRequestTypePost;
}

-(NSDictionary *)bodyparmsForAPIManager:(UTAPIBaseManager *)manager{
    return nil;
}
-(NSDictionary *)headParamsForApiManager:(UTAPIBaseManager *)manager{
    return nil;
}
-(NSDictionary *)reformParams:(NSDictionary *)params{

    return params;
}

-(void)managerApiCallBackDidSucess:(UTAPIBaseManager *)manager response:(UTResponse *)requestResponse{


}
-(void)managerApiCallBackDidFailed:(UTAPIBaseManager *)manager response:(UTResponse *)requestResponse{
    self.com?self.com(nil,requestResponse.error):nil;
}

-(BOOL)manager:(UTAPIBaseManager *)manager isCorrectParams:(NSDictionary *)params{
    return YES;
}
-(BOOL)manager:(UTAPIBaseManager *)manager isCorrectData:(UTResponse *)data{
    NSDictionary * dict = data.contentData;
    if (dict[@"sucess"]) {
        return YES;
    }
    return NO;
}

-(void)LoadDataWithSucess:(Completion)completion{
    [super loadData];
    self.com = completion;
}

@end
