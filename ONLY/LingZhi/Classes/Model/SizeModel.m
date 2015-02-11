//
//  SizeModel.m
//  LingZhi
//
//  Created by boguoc on 14-3-27.
//
//

#import "SizeModel.h"

@implementation SizeModel

-(NSDictionary *)attributeMapDictionary
{
    return @{@"name"    : @"sdisplayName",
             @"pName"   : @"sname",
             @"sizeId"  : @"sizeId",
             @"active"  : @"active",
             @"snumber" : @"snumber"
             };
}

@end
