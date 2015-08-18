//
//  UTObject+UTNetWorkingMethod.m
//  MobileUU
//
//  Created by dcj on 15/8/12.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTObject+UTNetWorkingMethod.h"

@implementation NSObject (UTNetWorkingMethod)

-(id)UTDefaultValueWithValue:(id)defaultValueData{
    if (![defaultValueData isKindOfClass:[self class]]) {
        return defaultValueData;
    }
    if ([self UTIsEmptyObject]) {
        return defaultValueData;
    }
    return self;
}

-(BOOL)UTIsEmptyObject{
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    
    return NO;

}

@end
