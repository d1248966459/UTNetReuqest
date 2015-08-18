//
//  UTRequestFactory.h
//  MobileUU
//
//  Created by dcj on 15/8/13.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTObject.h"

@interface UTRequestFactory : UTObject

+(instancetype)sharedInstnce;

-(NSURLRequest *)generatorPOSTRequestWithMetohdName:(NSString *)methodName requestParams:(NSDictionary *)requestParams headParams:(NSDictionary *)headParams serviceType:(NSString *)serviceType;
-(NSURLRequest *)generatorGETRequestWithMetohdName:(NSString *)methodName requestParams:(NSDictionary *)requestParams headParams:(NSDictionary *)headParams serviceType:(NSString *)serviceType;

@end
