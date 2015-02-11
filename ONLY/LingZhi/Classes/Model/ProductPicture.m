//
//  ProductPicture.m
//  LingZhi
//
//  Created by pk on 14-4-3.
//
//

#import "ProductPicture.h"

@implementation ProductPicture

-(NSDictionary *)attributeMapDictionary
{
    return @{@"pictureId"        : @"pictureId",
             @"pnumber"          : @"pnumber",
             @"imageUrl"         : @"purl",
            
             };
}

@end
