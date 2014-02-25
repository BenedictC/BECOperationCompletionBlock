//
//  NSOperation+EMKCompetionBlock.m
//  OperationCompetionBlock
//
//  Created by Benedict Cohen on 25/02/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "NSOperation+EMKCompetionBlock.h"



@implementation NSOperation (EMKCompetionBlock)

-(void(^)(void))EMK_newCompletionBlockUsingDispatchQueue:(dispatch_queue_t)queue block:(void(^)(NSOperation *operation))block
{
    dispatch_queue_t normalizedQueue = (queue == NULL) ? dispatch_get_main_queue() : queue;
    __weak typeof(self) weakSelf = self;

    return ^{
        dispatch_async(normalizedQueue, ^{
            block(weakSelf);
        });
    };
}



-(void)EMK_setCompletionBlockUsingDispatchQueue:(dispatch_queue_t)queue block:(void(^)(NSOperation *operation))block
{
    self.completionBlock = [self EMK_newCompletionBlockUsingDispatchQueue:queue block:block];
}

@end
