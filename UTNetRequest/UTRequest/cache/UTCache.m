//
//  UTCache.m
//  MobileUU
//
//  Created by dcj on 15/8/12.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTCache.h"
#import "NSDictionary+UTNetWorkingMethod.h"
#import "UTCacheObject.h"

static NSUInteger cacheCountLimt = 1000;

@interface UTCache ()

@property (nonatomic,strong) NSCache * cache;

@end


@implementation UTCache

-(NSCache *)cache{
    if (_cache == nil) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = cacheCountLimt;
    }
    return _cache;
}


+(instancetype)sharedInstance{
    static UTCache * cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (cache == nil) {
            cache = [[UTCache alloc] init];
        }
    });
    return cache;
}

-(void)cleanDataWithWithMethodName:(NSString *)methodName requestParams:(NSDictionary *)params{
    [self cleanDataWithKey:[self keyWithMetohdName:methodName andParams:params]];
}

-(BOOL)savedatatoCacheWithData:(NSData *)cacheData MethodName:(NSString *)methodName requestParams:(NSDictionary *)params{
    [self saveCacheData:cacheData withKey:[self keyWithMetohdName:methodName andParams:params]];
    
    return YES;
}

-(NSData *)readDataFromCacheWithMethodName:(NSString *)methodName requestParams:(NSDictionary *)params{
    UTCacheObject * cacheObject = [self.cache objectForKey:[self keyWithMetohdName:methodName andParams:params]];
    if (cacheObject.isOutDate||cacheObject.isEmptyData) {
        return nil;
    }else{
        return cacheObject.contentData;
    }
}

-(void)saveCacheData:(NSData *)cacheData withKey:(NSString *)key{
    UTCacheObject * cacheObject = [self.cache objectForKey:key];
    if (cacheObject == nil) {
        cacheObject = [[UTCacheObject alloc] init];
    }
    [cacheObject updateContentData:cacheData];
    [self.cache setObject:cacheObject forKey:key];
}

-(void)cleanAllData{
    [self.cache removeAllObjects];
}
-(void)cleanDataWithKey:(NSString *)key{
    [self.cache removeObjectForKey:key];
}

-(NSString *)keyWithMetohdName:(NSString *)methodName andParams:(NSDictionary *)params{
    return [NSString stringWithFormat:@"%@%@",methodName,[params UT_UrlStringWithSignature:NO]];
}
@end
