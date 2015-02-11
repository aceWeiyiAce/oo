//
//  UserDetailInfo.m
//  LingZhi
//
//  Created by kping on 14-8-18.
//
//

#import "UserDetailInfo.h"

@implementation UserDetailInfo

-(NSDictionary *)attributeMapDictionary
{
    return @{@"loginName"          : @"loginName",
             @"realName"           : @"realName",
             @"birthday"           : @"birthday",
             @"sex"                : @"sex"
            };
}


@end
