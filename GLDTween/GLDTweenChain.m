//
//  GLDTweenChain.m
//  GLDTween
//
//  Created by Ryo Miyake on 2015/08/25.
//  Copyright (c) 2014 THE GUILD. All rights reserved.
//

#import "GLDTweenChain.h"
#import "GLDTweenChainAction.h"

@interface GLDTweenChain()
@property (strong, nonatomic) NSObject *target;
@property (strong, nonatomic) NSMutableArray *actionList;
@property (strong, nonatomic) GLDTweenChainAction *currentAction;
@end

@implementation GLDTweenChain

@synthesize currentAction = _currentAction;

static NSMutableArray *all_chains = nil;

- (id)init:(NSObject *)target
{
    if(self = [self init]){
        _target = target;
        _actionList = NSMutableArray.array;
        
        @synchronized (all_chains) {
            [all_chains addObject:self];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
            [self execute];
        });
    }
    return self;
}

+ (GLDTweenChain*)get:(NSObject *)target
{
    if(!all_chains){
        all_chains = NSMutableArray.array;
    }
    @synchronized (all_chains){
        for(GLDTweenChain *chain in all_chains){
            if([chain.target isEqual:target]){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
                    [chain resume];
                });
                return chain;
            }
        }
    }
    return [[self alloc] init:target];
}

- (void)deinit
{
    @synchronized (all_chains){
        [all_chains removeObject:self];
    }
}

- (void)addAction:(id)action
{
    @synchronized (self){
        [_actionList addObject:action];
    }
}

- (GLDTweenChainAction*)getNextAction
{
    @synchronized (self){
        id action = [_actionList firstObject];
        if(action)
            [_actionList removeObjectAtIndex:0];
        return action;
    }
}

- (void)setCurrentAction:(GLDTweenChainAction *)currentAction
{
    @synchronized (self){
        _currentAction = currentAction;
    }
}

- (GLDTweenChainAction *)currentAction
{
    @synchronized (self){
        return _currentAction;
    }
}

- (void)execute
{
    self.currentAction = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        GLDTweenChainAction *action = [self getNextAction];
        if(action){
            [action executeWithCompleted:^{
                [self execute];
            }];
            self.currentAction = action;
        }else{
            [self deinit];
        }
    });
}

- (GLDTweenChain *)set:(NSDictionary *)params
{
    NSMutableDictionary *params2 = [params mutableCopy];
    [params2 setObject:@0 forKey:@"duration"];
    [self addAction:[[GLDTweenChainActionAdd alloc] initWithTarget:_target params:params2]];
    return self;
}

- (GLDTweenChain*)to:(NSDictionary *)params
{
    [self addAction:[[GLDTweenChainActionAdd alloc] initWithTarget:_target params:params]];
    return self;
}

- (GLDTweenChain*)wait:(NSTimeInterval)delay
{
    [self addAction:[[GLDTweenChainActionWait alloc] initWithDelay:delay]];
    return self;
}

- (GLDTweenChain*)call:(void(^)(void))block
{
    [self addAction:[[GLDTweenChainActionCall alloc] initWithBlock:block]];
    return self;
}

- (void)_remove
{
    @synchronized (self){
        for(GLDTweenChainAction *action in _actionList){
            [action cancel];
        }
        if(_currentAction)
            [_currentAction cancel];
        _currentAction = nil;
        [_actionList removeAllObjects];
    }
    [self deinit];
}

- (void)removeProps:(NSArray *)props
{
    @synchronized (self){
        for(GLDTweenChainAction *action in _actionList){
            [action removeProps:props];
        }
        if(_currentAction)
            [_currentAction removeProps:props];
    }
    [self deinit];
}

- (void)pause
{
    @synchronized (self){
        for(GLDTweenChainAction *action in _actionList){
            [action pause];
        }
        if(_currentAction){
            [_currentAction pause];
        }
    }
}

- (void)resume
{
    @synchronized (self){
        for(GLDTweenChainAction *action in _actionList){
            [action resume];
        }
        if(_currentAction)
            [_currentAction resume];
    }
}

+ (void)allChainsFilter:(BOOL(^)(GLDTweenChain *chain))filter
                   exec:(BOOL(^)(GLDTweenChain *chain))exec
{
    if(!all_chains)
        return;
    @synchronized (all_chains){
        for(GLDTweenChain *chain in all_chains){
            if(filter(chain)){
                if(!exec(chain)){
                    break;
                }
            }
        }
    }
}

+ (void)remove:(NSObject *)target
{
    [self allChainsFilter:^BOOL(GLDTweenChain *chain) {
        return [chain.target isEqual:target];
    }
                     exec:^BOOL(GLDTweenChain *chain) {
                         [chain _remove];
                         return YES;
                     }];
}

+ (void)remove:(NSObject *)target props:(NSArray *)props
{
    [self allChainsFilter:^BOOL(GLDTweenChain *chain) {
        return [chain.target isEqual:target];
    }
                     exec:^BOOL(GLDTweenChain *chain) {
                         [chain _remove];
                         return YES;
                     }];
}

+ (void)removeAllTweens
{
    [self allChainsFilter:^BOOL(GLDTweenChain *chain) {
        return YES;
    }
                     exec:^BOOL(GLDTweenChain *chain) {
                         [chain _remove];
                         return YES;
                     }];
}

+ (void)pause:(NSObject *)target
{
    [self allChainsFilter:^BOOL(GLDTweenChain *chain) {
        return [chain.target isEqual:target];
    }
                     exec:^BOOL(GLDTweenChain *chain) {
                         [chain pause];
                         return YES;
                     }];
}

+ (void)pauseAllTweens
{
    [self allChainsFilter:^BOOL(GLDTweenChain *chain) {
        return YES;
    }
                     exec:^BOOL(GLDTweenChain *chain) {
                         [chain pause];
                         return YES;
                     }];
}

+ (void)resume:(NSObject *)target
{
    [self allChainsFilter:^BOOL(GLDTweenChain *chain) {
        return [chain.target isEqual:target];
    }
                     exec:^BOOL(GLDTweenChain *chain) {
                         [chain resume];
                         return YES;
                     }];
}

+ (void)resumeAllTweens
{
    [self allChainsFilter:^BOOL(GLDTweenChain *chain) {
        return YES;
    }
                     exec:^BOOL(GLDTweenChain *chain) {
                         [chain resume];
                         return YES;
                     }];
}

@end


@implementation GLDTweenChain(Blocks)

+ (GLDTweenChain*(^)(NSObject *target))get
{
    return ^GLDTweenChain *(NSObject *target){
        return [self get:target];
    };
}

- (GLDTweenChain *(^)(NSDictionary *params))set
{
    return ^GLDTweenChain *(NSDictionary *params){
        return [self set:params];
    };
}

- (GLDTweenChain *(^)(NSDictionary *params))to
{
    return ^GLDTweenChain *(NSDictionary *params){
        return [self to:params];
    };
}

- (GLDTweenChain *(^)(NSTimeInterval delay))wait
{
    return ^GLDTweenChain *(NSTimeInterval delay){
        return [self wait:delay];
    };
}

- (GLDTweenChain *(^)(void(^block)(void)))call
{
    return ^GLDTweenChain *(void(^block)(void) ){
        return [self call:block];
    };
}

- (GLDTweenChain *(^)())remove
{
    return ^GLDTweenChain *(){
        [self _remove];
        return self;
    };
}

+ (void(^)(NSObject *target))remove
{
    return ^(NSObject *target){
        [self remove:target];
    };
}

+ (void(^)(NSObject *target, NSArray *props))removeProps
{
    return ^(NSObject *target, NSArray *props){
        [self remove:target props:props];
    };
}

+ (void(^)(void))removeAll
{
    [self removeAllTweens];
    return ^{};
}

+ (void(^)(NSObject *target))pause
{
    return ^(NSObject *target){
        [self remove:target];
    };
}
+ (void(^)(void))pauseAll
{
    [self pauseAllTweens];
    return ^{};
}

+ (void(^)(NSObject *target))resume
{
    return ^(NSObject *target){
        [self remove:target];
    };
}
+ (void(^)(void))resumeAll
{
    [self resumeAllTweens];
    return ^{};
}

@end
