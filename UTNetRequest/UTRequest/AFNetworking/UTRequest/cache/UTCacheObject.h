//
//  UTCacheObject.h
//  MobileUU
//
//  Created by dcj on 15/8/12.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTObject.h"

@interface UTCacheObject : UTObject

@property (nonatomic,strong) NSData * contentData;
@property (nonatomic,strong) NSDate * lastUpdateDate;
@property (nonatomic,assign) BOOL isOutDate;
@property (nonatomic,assign) BOOL isEmptyData;

-(instancetype)initWithCacheData:(NSData *)cacheData;
-(void)updateContentData:(NSData *)contentData;
@end
