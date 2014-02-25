EMKOperationCompletionBlock
===========================

A category on NSOperation for adding a completion block without worrying about retain cycles.

The category adds 2 methods to `NSOperation`:

- `EMK_setCompletionBlockUsingDispatchQueue:block:`
- `EMK_newCompletionBlockUsingDispatchQueue:block:`

`EMK_setCompletionBlockUsingDispatchQueue:block:` replaces  `setCompletionBlock:`. If the value for `queue` is null then the main queue is used. The signature of `block` is `void(^)(NSOperation *operation)`. The type should be changed from `NSOperation` to match the type of the specific operation.

`EMK_newCompletionBlockUsingDispatchQueue:block:` is used by `EMK_setCompletionBlockUsingDispatchQueue:block:` but is rarely, if ever, need to be called otherwise.