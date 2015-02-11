//
//  ProductDetailInfoModel.m
//  LingZhi
//
//  Created by pk on 4/3/14.
//
//

#import "ProductDetailInfoModel.h"



@implementation ProductDetailInfoModel

-(NSDictionary *)attributeMapDictionary
{
    return @{@"productInfo"     : @"productInfo",
             @"imageUrlArr"     : @"availableImages",
             @"colorArr"        : @"availableColors",
             @"sizeArr"         : @"availableSizes",
             @"macthProducts"   : @"matchProList",
             @"collectId"   : @"collectId",};
}

-(void)setCollectId:(NSString *)collectId
{
    _collectId = collectId;
    if (![collectId isEqualToString:@""] && collectId) {
        _isCollected = YES;
    }else{
        _isCollected = NO;
    }
}

@end
