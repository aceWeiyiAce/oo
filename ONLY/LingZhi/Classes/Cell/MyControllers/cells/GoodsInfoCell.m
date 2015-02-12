//
//  GoodsInfoCell.m
//  JiuBa
//
//  Created by apple on 15/2/12.
//
//

#import "GoodsInfoCell.h"

@implementation GoodsInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
        static NSString *goodsCell = @"GoodsInfoCell";
    GoodsInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:goodsCell owner:self options:nil] firstObject];
    }
    return cell;
}
@end
