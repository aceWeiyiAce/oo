//
//  TrackCell.h
//  LingZhi
//
//  Created by pk on 3/5/14.
//
//

#import "ITTXibView.h"
#import "MyTrack.h"

typedef void(^TapGestureAction)(NSString * productId);

@interface TrackCell : ITTXibCell


@property (nonatomic,copy) TapGestureAction tapAction;

@property (nonatomic,strong) MyTrack * track;


/**
 *  根据传回的足迹显示对应的信息
 *
 *  @param track
 */
- (void) showTrackInfoWithTrack:(MyTrack *)track;

-(void)showTrackWithModel:(MyTrack *)track;

@end
