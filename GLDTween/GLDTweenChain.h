//
//  GLDTweenChain.h
//  GLDTween
//
//  Created by Ryo Miyake on 2015/08/25.
//  Copyright (c) 2014 THE GUILD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLDTweenChain : NSObject

+ (GLDTweenChain *)get:(NSObject *)target;

- (GLDTweenChain *)set:(NSDictionary *)params;
- (GLDTweenChain *)to:(NSDictionary *)params;
- (GLDTweenChain *)wait:(NSTimeInterval)delay;
- (GLDTweenChain *)call:(void(^)(void))block;

+ (void)remove:(NSObject *)target;
+ (void)remove:(NSObject *)target props:(NSArray *)props;
+ (void)removeAllTweens;

+ (void)pause:(NSObject *)target;
+ (void)pauseAllTweens;

+ (void)resume:(NSObject *)target;
+ (void)resumeAllTweens;

@end

@interface GLDTweenChain(Blocks)

+ (GLDTweenChain *(^)(NSObject *target))get;

- (GLDTweenChain *(^)(NSDictionary *params))set;
- (GLDTweenChain *(^)(NSDictionary *params))to;
- (GLDTweenChain *(^)(NSTimeInterval delay))wait;
- (GLDTweenChain *(^)(void(^block)(void)))call;
- (GLDTweenChain *(^)())remove;

+ (void(^)(NSObject *target))remove;
+ (void(^)(NSObject *target, NSArray *props))removeProps;
+ (void(^)(void))removeAll;

+ (void(^)(NSObject *target))pause;
+ (void(^)(void))pauseAll;

+ (void(^)(NSObject *target))resume;
+ (void(^)(void))resumeAll;

@end
