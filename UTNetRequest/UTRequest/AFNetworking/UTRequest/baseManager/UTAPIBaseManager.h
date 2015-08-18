//
//  UTAPIBaseManager.h
//  MobileUU
//
//  Created by dcj on 15/8/11.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTObject.h"
#import "UTResponse.h"
#import "UTNetWorkGlobalVariable.h"

@class UTAPIBaseManager;



@protocol UTAPIManagerApiDidCallBackDelegate <NSObject>
@required
/**
 *  请求回调
 *
 *  @param manager         manager
 *  @param requestResponse 请求信息
 */
-(void)managerApiCallBackDidSucess:(UTAPIBaseManager *)manager response:(UTResponse *)requestResponse;
/**
 *  回调
 *
 *  @param manager         manager
 *  @param requestResponse 失败信息在response的error 属性
 */
-(void)managerApiCallBackDidFailed:(UTAPIBaseManager *)manager response:(UTResponse *)requestResponse;

@end

@protocol UTAPIManagerParmSourceDelegate <NSObject>

-(NSDictionary *)bodyparmsForAPIManager:(UTAPIBaseManager *)manager;
-(NSDictionary *)headParamsForApiManager:(UTAPIBaseManager *)manager;

@end


@protocol UTAPIManager<NSObject>
-(NSString *)methodName;
-(NSString *)serviceType;
-(UTAPIManagerRequestType)requestType;

-(void)cleanData;
-(BOOL)shouldCache;
-(NSDictionary *)reformParams:(NSDictionary *)params;
@end

@protocol UTAPIManagerInterceptorDelegate <NSObject>
@optional
-(void)manager:(UTAPIBaseManager *)manager berforePreformSucessWithResponse:(UTResponse *)response;
-(void)manager:(UTAPIBaseManager *)manager afterPreformSucessWithResponse:(UTResponse *)response;

-(void)manager:(UTAPIBaseManager *)manager beforePreformFailedWithResponse:(UTResponse *)response;

-(void)manager:(UTAPIBaseManager *)manager afterPreformFailedWithResponse:(UTResponse *)response;

-(BOOL)manager:(UTAPIBaseManager *)manager shouldCallAPIWithBodyParams:(NSDictionary *)bodyParams headParams:(NSDictionary *)headParams;

-(void)manager:(UTAPIBaseManager *)manager afterCallingAPIWithBodyParams:(NSDictionary *)bodyParams headParams:(NSDictionary *)headParams;

@end
@protocol UTAPIDataValidator <NSObject>
@optional
-(BOOL)manager:(UTAPIBaseManager *)manager isCorrectData:(UTResponse *)data;
-(BOOL)manager:(UTAPIBaseManager *)manager isCorrectParams:(NSDictionary *)params;

@end

@interface UTAPIBaseManager : UTObject

@property (nonatomic,weak) id<UTAPIManagerApiDidCallBackDelegate> didCallBackDelegate;
@property (nonatomic,weak) id<UTAPIManagerParmSourceDelegate>paramSource;
@property (nonatomic,weak) UTObject <UTAPIManager> *child;
@property (nonatomic,weak) id<UTAPIManagerInterceptorDelegate> interceptor;
@property (nonatomic,weak) id<UTAPIDataValidator> validator;

@property (nonatomic,assign) UTAPIManagerErrorType managerErrorType;

@property (nonatomic,copy) NSString * errorMessage;


-(NSInteger)loadData;
-(void)cacleAllRequests;
-(void)cacleRequestWtihRequestID:(NSInteger)requestID;
-(void)beforePreformSucessWithResponse:(UTResponse *)response;
-(void)afterPreformSucessWithResponse:(UTResponse *)response;
-(void)beforePreformFailedWithResponse:(UTResponse *)response;
-(void)afterPreformFailedWithResponse:(UTResponse *)response;
-(BOOL)shouldCallAPIWithBodyParams:(NSDictionary *)bodyParams headParams:(NSDictionary *)headParams;
-(void)afterCallingAPIWithBodyParams:(NSDictionary *)bodyParams headParams:(NSDictionary *)headParams;
-(void)cleanData;
-(BOOL)shouldCache;

@end
