//
//  NSDictionary+UTNetWorkingMethod.h
//  MobileUU
//
//  Created by dcj on 15/8/12.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (UTNetWorkingMethod)

-(NSString *)UT_UrlStringWithSignature:(BOOL)isForSignature;

-(NSArray *)UT_transformUrlParamsArraySignature:(BOOL)isForSignature;

-(NSString *)jsonString;

@end
