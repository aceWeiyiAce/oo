//
//  UserInfo.m
//  LingZhi
//
//  Created by boguoc on 14-4-25.
//
//

#import "UserInfo.h"

@implementation UserInfo

-(NSDictionary *)attributeMapDictionary
{
    return @{@"userId"      : @"userId",
             @"sound"       : @"sound",
             @"silent"      : @"silent",
             @"vibration"   : @"vibration",
             @"isOpenNoti"  : @"isOpenNoti"};
}

@end
