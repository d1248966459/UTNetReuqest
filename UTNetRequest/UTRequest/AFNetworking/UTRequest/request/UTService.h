//
//  UTService.h
//  MobileUU
//
//  Created by dcj on 15/8/13.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTObject.h"

@protocol UTServiceProtocol <NSObject>


@property (nonatomic,copy,readonly) NSString * apiBaseUrl;
@property (nonatomic,copy,readonly) NSString * apiVersion;

@end


@interface UTService : UTObject

@property (nonatomic,copy,readonly) NSString * urlString;
@property (nonatomic,copy,readonly) NSString * version;
@property (nonatomic,weak) id<UTServiceProtocol>child;


@end
