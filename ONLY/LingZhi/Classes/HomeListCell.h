//
//  HomeListCell.h
//  LingZhi
//
//  Created by boguoc on 14-2-28.
//
//

#import "ITTXibView.h"
#import "ClassificationModel.h"

@interface HomeListCell : ITTXibCell

@property (weak, nonatomic) IBOutlet UILabel *homeCellLabel;

- (void)layoutHomeListCellWith:(ClassificationModel *)model;

@end
