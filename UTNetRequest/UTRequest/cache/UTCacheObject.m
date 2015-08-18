//
//  UTCacheObject.m
//  MobileUU
//
//  Created by dcj on 15/8/12.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTCacheObject.h"
#import "UTNetWorkGlobalVariable.h"
@implementation UTCacheObject

-(instancetype)initWithCacheData:(NSData *)cacheData{
    if (self = [super init]) {
        self.contentData = cacheData;
    }
    return self;
}
-(void)updateContentData:(NSData *)contentData{
    self.contentData = contentData;
}

-(BOOL)isEmptyData{
    return self.contentData == nil;
}
-(BOOL)isOutDate{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateDate];
    return timeInterval > UTCache_VALIABLE_TIME;
}
-(void)setContentData:(NSData *)contentData{
    _contentData = contentData;
    self.lastUpdateDate = [NSDate dateWithTimeIntervalSinceNow:0];
}

@end
