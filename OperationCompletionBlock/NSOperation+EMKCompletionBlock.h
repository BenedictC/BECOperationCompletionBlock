//
//  NSOperation+EMKCompletionBlock.h
//  OperationCompletionBlock
//
//  Created by Benedict Cohen on 25/02/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSOperation (EMKCompletionBlock)

/**
 *  Creates a block suitable for use with NSOperation's completionBlock property.
 *
 *  @param queue The dispatch queue that block will be asynchronously enqueued to. If NULL then the main queue is used.
 *  @param block The block to execute on completion. operation is the completed operation.
 */
-(void(^)(void))EMK_newCompletionBlockUsingDispatchQueue:(dispatch_queue_t)queue block:(void(^)(NSOperation *op))block;



/**
 *  Sets completionBlock to a block which will asynchronously execute block on queue. This method uses
 *  EMK_newCompletionBlockUsingDispatchQueue:block: to create block. Using this method helps to avoid retain cycles by
 *  and makes threading requirements explicit.
 *
 *  @param queue The dispatch queue that block will be asynchronously enqueued to. If NULL then the main queue is used.
 *  @param block The block to execute on completion. operation is the completed operation.
 */
-(void)EMK_setCompletionBlockUsingDispatchQueue:(dispatch_queue_t)queue block:(void(^)(NSOperation *operation))block;

@end
