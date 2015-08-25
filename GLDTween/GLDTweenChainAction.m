//
//  GLDTweenChainAction.m
//  GLDTween
//
//  Created by Ryo Miyake on 2015/08/25.
//  Copyright (c) 2014 THE GUILD. All rights reserved.
//

#import "GLDTweenChainAction.h"
#import "GLDTween.h"

@interface GLDTweenChainAction()
@property (atomic, copy) void (^completed)(void);
@property (atomic, assign) BOOL suspended;
@end

@implementation GLDTweenChainAction

- (void)executeWithCompleted:(void(^)(void))completed
{
    _completed = completed;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self execute];
    });
}

- (void)execute
{
    while (_suspended) {
        [NSThread sleepForTimeInterval:.1];
    }
}

- (void)complete
{
    if(_completed)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), _completed);
}

- (void)cancel
{
    _completed = nil;
}

- (void)pause
{
    _suspended = YES;
}

- (void)resume
{
    _suspended = NO;
}

- (void)removeProps:(NSArray *)props
{
}

@end


@interface GLDTweenChainActionAdd()
@property (strong, nonatomic) NSObject *target;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (strong, nonatomic) GLDTweenBlock *completionBLock;
@end

@implementation GLDTweenChainActionAdd

- (id)initWithTarget:(NSObject*)target params:(NSDictionary*)params
{
    if(self = [self init]){
        _target = target;
        _params = [params mutableCopy];
        _completionBLock = _params ? _params[GLDTweenParamCompletionBlock] : nil;
    }
    return self;
}

- (void)execute
{
    [super execute];
    typeof(self) __weak wself = self;
    GLDTweenBlock *block = [[GLDTweenBlock alloc] initWithBlock:^{
        [wself.completionBLock execute];
        [wself complete];
    }];
    _params[GLDTweenParamCompletionBlock] = block;
    dispatch_async(dispatch_get_main_queue(), ^{
        [GLDTween addTween:_target withParams:_params];
    });
}

- (void)cancel
{
    [super cancel];
    [GLDTween removeTween:_target];
}

- (void)pause
{
    [super pause];
    [GLDTween pauseTween:_target];
}

- (void)resume
{
    [super resume];
    [GLDTween resumeTween:_target];
}

- (void)removeProps:(NSArray *)props
{
    [super removeProps:props];
    [GLDTween removeTween:_target withProps:props];
}

@end

@interface GLDTweenChainActionWait()
@property (assign, nonatomic) NSTimeInterval delay;
@end

@implementation GLDTweenChainActionWait

- (id)initWithDelay:(NSTimeInterval)delay
{
    if(self = [self init]){
        _delay = delay;
    }
    return self;
}

- (void)execute
{
    [super execute];
    [NSThread sleepForTimeInterval:_delay];
    [self complete];
}

@end

@interface GLDTweenChainActionCall()
@property (nonatomic, copy) void (^block)(void);
@end

@implementation GLDTweenChainActionCall

- (id)initWithBlock:(void(^)(void))block
{
    if(self = [self init]){
        _block = block;
    }
    return self;
}

- (void)execute
{
    [super execute];
    if(_block)
        dispatch_async(dispatch_get_main_queue(), _block);
    [self complete];
}

@end