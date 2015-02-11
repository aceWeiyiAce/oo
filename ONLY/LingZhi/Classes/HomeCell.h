//
//  HomeCell.h
//  LingZhi
//
//  Created by boguoc on 14-3-7.
//
//

#import "ITTXibView.h"
#import "HomeListModel.h"
#import "HomeModel.h"

@protocol HomeCellDelegate <NSObject>

- (void)didOnPageAtId:(HomeModel *)homeModel;

@end

@interface HomeCell : ITTXibCell

@property (nonatomic ,strong)NSString *pageNum;
@property (nonatomic ,assign)int row;
@property (nonatomic ,strong)HomeListModel *home;
@property (nonatomic ,assign)id<HomeCellDelegate>delegate;

@end
