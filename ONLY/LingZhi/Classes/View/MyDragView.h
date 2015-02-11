//
//  MyDragView.h
//  LingZhi
//
//  Created by pk on 14-3-9.
//
//

#import <UIKit/UIKit.h>

typedef void(^RETURN_ANIMOTION_ACTION)();

@interface MyDragView : UIView

@property (nonatomic,assign) NSUInteger distance;
@property (nonatomic,copy) RETURN_ANIMOTION_ACTION animotionAction;

@end
