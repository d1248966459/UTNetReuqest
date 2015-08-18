//
//  UTDataProvider.h
//  MobileUU
//
//  Created by dcj on 15/8/12.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTObject.h"
#import "UTNetWorkGlobalVariable.h"
@class UTResponse;
typedef void(^UTRequestCallBack)(UTResponse * response);




@interface UTDataProvider : UTObject

+(instancetype)sharedInstance;

-(NSInteger)callApiWithRequestType:(UTAPIManagerRequestType)requestType
                       serviceType:(NSString *)serviceType
                     requestParams:(NSDictionary *)requestParams
                        methodName:(NSString *)methodName
                        headParams:(NSDictionary *)headParams
                    sucessCallback:(UTRequestCallBack)sucess
                    failedCallback:(UTRequestCallBack)failed;


-(void)cacleRequestWithRequestID:(NSNumber *)requestID;
-(void)cacleRequestWithRequestIDList:(NSMutableArray *)requestIDList;
@end
