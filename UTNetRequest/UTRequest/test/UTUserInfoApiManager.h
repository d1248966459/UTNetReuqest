//
//  UTUserInfoApiManager.h
//  MobileUU
//
//  Created by dcj on 15/8/13.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTAPIBaseManager.h"
@class UTUserInfoModel;
typedef void(^Completion)(UTUserInfoModel * model,NSError * error);
@interface UTUserInfoApiManager : UTAPIBaseManager<UTAPIManager,UTAPIDataValidator,UTAPIManagerParmSourceDelegate,UTAPIManagerApiDidCallBackDelegate,UTAPIManagerInterceptorDelegate>

-(void)LoadDataWithSucess:(Completion)completion;
@end
