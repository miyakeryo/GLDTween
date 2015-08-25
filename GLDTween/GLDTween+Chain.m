//
//  GLDTween+Chain.m
//  GLDTween
//
//  Created by Ryo Miyake on 2015/08/25.
//  Copyright (c) 2014 THE GUILD. All rights reserved.
//

#import "GLDTween+Chain.h"

@implementation GLDTween (Chain)

+ (GLDTweenChain *(^)(NSObject *target))get
{
    return ^GLDTweenChain *(NSObject *target){
        return [GLDTweenChain get:target];
    };
}

@end
