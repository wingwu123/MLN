//
//  MLNUICanvasAnimationDelegate.h
//  MLNUI
//
//  Created by MoMo on 2019/5/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLNUICanvasAnimationDelegate : NSObject <CAAnimationDelegate>

@property (nonatomic, assign) BOOL ignoreAnimationCallback;

- (instancetype)initWithAnimation:(id<CAAnimationDelegate>)animation;

@end

NS_ASSUME_NONNULL_END
