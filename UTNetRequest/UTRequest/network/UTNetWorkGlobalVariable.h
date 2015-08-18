//
//  UTNetWorkGlobalVariable.h
//  MobileUU
//
//  Created by dcj on 15/8/13.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTObject.h"


extern NSString * const UTServiceTypeUserinfo;



extern NSString * const requestTypeGet;
extern NSString * const requestTypePost;
extern NSString * const requestTypePut;
extern NSString * const requestTypeDelet;


static NSTimeInterval UTCache_VALIABLE_TIME = 60;
static BOOL UT_shouldCache = NO;

typedef NS_ENUM(NSUInteger , UTAPIManagerRequestType) {
    UTAPIManagerRequestTypeGet = 0,
    UTAPIManagerRequestTypePost,
    UTAPIManagerRequestTypePut,
    UTAPIManagerRequestTypeDelet,
};

typedef NS_ENUM(NSUInteger, UTAPIManagerErrorType) {
    UTAPIManagerErrorTypeDefault,
    UTAPIManagerErrorTypeSucess,
    UTAPIManagerErrorTypeNoContent,
    UTAPIManagerErrorTypeParamsError,
    UTAPIManagerErrorTypeTimeOut,
    UTAPIManagerErrorTypeNoNetWork,
};



@interface UTNetWorkGlobalVariable : UTObject



@end
