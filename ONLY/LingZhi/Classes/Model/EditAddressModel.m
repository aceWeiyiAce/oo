//
//  EditAddressModel.m
//  LingZhi
//
//  Created by boguoc on 14-3-11.
//
//

#import "EditAddressModel.h"

@implementation EditAddressModel

-(NSDictionary *)attributeMapDictionary
{
    return @{@"content"     : @"content",
             @"isError"     : @"isError",
             @"indexPath"   : @"indexPath",
             @"holder"      : @"holder",
             @"isPicker"    : @"isPicker"};
}

+(id)createAddressModelWithModelId:(NSString *)modelId addressArr:(NSArray *)array
{
    NSMutableArray *holderArr = [[NSMutableArray alloc]initWithObjects:@"姓名",@"地址",@"省或市",@"城市",@"地区",@"邮编",@"手机", nil];
    EditAddressModel *editAddress = [[EditAddressModel alloc]init];
    
    if (array.count>0) {
        editAddress.content = array[[modelId integerValue]];
    } else {
        editAddress.content = @"";
    }
    
    editAddress.holder = [holderArr objectAtIndex:[modelId integerValue]];
    editAddress.isError = @"0";
    NSString *str = array[7];
    
    if ([modelId integerValue] == 4 && str.length > 1) {
        editAddress.isPicker = @"1";
    } else if ([modelId integerValue] == 2 || 3 == [modelId integerValue]){
        editAddress.isPicker = @"1";
    } else {
        editAddress.isPicker = @"0";
    }
    
    return editAddress;
}
@end
