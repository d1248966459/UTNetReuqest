//
//  UTCache.h
//  MobileUU
//
//  Created by dcj on 15/8/12.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTObject.h"

@interface UTCache : UTObject

+(instancetype)sharedInstance;

-(BOOL)savedatatoCacheWithData:(NSData *)cacheData
                    MethodName:(NSString *)methodName
                 requestParams:(NSDictionary *)params;

-(NSData *)readDataFromCacheWithMethodName:(NSString *)methodName
                             requestParams:(NSDictionary *)params;

-(void)cleanDataWithWithMethodName:(NSString *)methodName
                            requestParams:(NSDictionary *)params;

-(void)cleanAllData;

@end
