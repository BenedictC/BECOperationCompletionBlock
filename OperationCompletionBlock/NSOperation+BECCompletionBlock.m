//
//  NSOperation+BECCompletionBlock.m
//  OperationCompetionBlock
//
//  Created by Benedict Cohen on 25/02/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "NSOperation+BECCompletionBlock.h"



@implementation NSOperation (BECCompletionBlock)

-(void(^)(void))BEC_newCompletionBlockUsingDispatchQueue:(dispatch_queue_t)queue block:(void(^)(NSOperation *operation))block
{
    dispatch_queue_t normalizedQueue = (queue == NULL) ? dispatch_get_main_queue() : queue;
    __weak typeof(self) weakSelf = self;

    return ^{
        dispatch_async(normalizedQueue, ^{
            block(weakSelf);
        });
    };
}



-(void)BEC_setCompletionBlockUsingDispatchQueue:(dispatch_queue_t)queue block:(void(^)(NSOperation *operation))block
{
    self.completionBlock = [self BEC_newCompletionBlockUsingDispatchQueue:queue block:block];
}

@end
