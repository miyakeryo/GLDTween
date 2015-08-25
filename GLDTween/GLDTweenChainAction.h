//
//  GLDTweenChainAction.h
//  GLDTween
//
//  Created by Ryo Miyake on 2015/08/25.
//  Copyright (c) 2014 THE GUILD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLDTweenChainAction : NSObject

- (void)executeWithCompleted:(void(^)(void))completed;
- (void)cancel;
- (void)pause;
- (void)resume;
- (void)removeProps:(NSArray *)props;

@end

@interface GLDTweenChainActionAdd : GLDTweenChainAction

- (id)initWithTarget:(NSObject*)target params:(NSDictionary*)params;

@end

@interface GLDTweenChainActionWait : GLDTweenChainAction

- (id)initWithDelay:(NSTimeInterval)delay;

@end

@interface GLDTweenChainActionCall : GLDTweenChainAction

- (id)initWithBlock:(void(^)(void))block;

@end