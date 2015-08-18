//
//  UTNetWorkStatus.h
//  MobileUU
//
//  Created by dcj on 15/8/17.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "UTObject.h"

typedef NS_ENUM(NSUInteger, UTNetWorkCurrentStatus) {
    UTNetWorkCurrentStatusNoNet,
    UTNetWorkCurrentStatusWifi,
};

@interface UTNetWorkStatus : UTObject



+(instancetype)sharedInstance;

@end
