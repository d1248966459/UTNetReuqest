//
//  UTResponse.h
//  MobileUU
//
//  Created by dcj on 15/8/12.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTObject.h"

typedef NS_ENUM(NSInteger, UTURLResponseStatus) {
    UTURLResponseStatusSucess = 0,
    UTURLResponseStatusTimeOut,
    UTURLResponseStatusNONet,
};


@interface UTResponse : UTObject

@property (nonatomic,strong) id contentData;
@property (nonatomic,copy) NSString * contentString;
@property (nonatomic,assign) BOOL isCache;
@property (nonatomic,strong) NSURLRequest * responseRequest;
@property (nonatomic,assign) NSInteger requestID;
@property (nonatomic,strong) NSDictionary * requestParams;
@property (nonatomic,strong) NSData * requestData;
@property (nonatomic,assign) UTURLResponseStatus responseStatus;
@property (nonatomic,strong) NSError * error;


- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData status:(UTURLResponseStatus)status;
- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error;


-(instancetype)initWithData:(NSData *)data;


@end
