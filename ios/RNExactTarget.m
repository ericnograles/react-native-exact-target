
#import "RNExactTarget.h"

@implementation RNExactTarget

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(initializePushManager:(NSString *)etAppId location:(NSString *)etAccessToken)
{
    RCTLogInfo(@"Pretending to initialize ETPush with app ID %@ and access token %@", etAppId, etAccessToken);
}

@end
  
