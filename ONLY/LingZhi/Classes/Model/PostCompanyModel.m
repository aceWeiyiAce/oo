//
//  PostCompanyModel.m
//  LingZhi
//
//  Created by pk on 4/14/14.
//
//

#import "PostCompanyModel.h"

@implementation PostCompanyModel

-(NSDictionary *)attributeMapDictionary
{

    return @{@"carrierId"    : @"carrierId",
             @"carriderCode" : @"carriderCode",
             @"carrierName"  : @"carrierName",
             @"useSign"      : @"useSign",
             };
}

@end
