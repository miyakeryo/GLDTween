//
//  GLDTween+Chain.h
//  GLDTween
//
//  Created by Ryo Miyake on 2015/08/25.
//  Copyright (c) 2014 THE GUILD. All rights reserved.
//

#import "GLDTween.h"
#import "GLDTweenChain.h"

@interface GLDTween (Chain)

+ (GLDTweenChain *(^)(NSObject *target))get;

@end
