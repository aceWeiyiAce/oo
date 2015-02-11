//
//  HomeListModel.m
//  LingZhi
//
//  Created by boguoc on 14-3-7.
//
//

#import "HomeListModel.h"
#import "HomeModel.h"

@implementation HomeListModel

-(NSDictionary *)attributeMapDictionary
{
    return @{@"homes"   : @"categoryList",
             @"pageNum" : @"pageNum"};
}

+(id)createTestModelWithModelId:(NSString *)modelId
{
    HomeListModel *homeList = [[HomeListModel alloc]init];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<2; i++) {
        [array addObjectsFromArray:[HomeModel createTestModels]];
    }
    homeList.homes = array;
    
    return homeList;
}


@end
