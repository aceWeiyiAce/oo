//
//  UserProtocolCell.h
//  LingZhi
//
//  Created by boguoc on 14-5-8.
//
//

#import "ITTXibView.h"

@interface UserProtocolCell : ITTXibCell

@property (nonatomic,assign) int index;

- (void)layoutUserProtocolCellWithString:(NSString *)string;
- (CGFloat)getUserProtocolCellHeight;

@end
