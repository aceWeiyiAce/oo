//
//  DataManager.h
//  LingZhi
//
//  Created by boguoc on 14-3-21.
//
//

#import <Foundation/Foundation.h>

typedef enum{
    kCartType,
    
}AddClassType;

@interface DataManager : NSObject

- (void)addModel:(id)model forType:(AddClassType)type;

@end

