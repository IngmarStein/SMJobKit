#import "NSObject+XPCInterop.h"

#import <Foundation/NSValue.h>
#import <xpc/xpc.h>

@interface NSNumber (XPCInterop)

+ (instancetype) numberWithXPCNumber:(xpc_object_t)xpcNumber;
@property (NS_NONATOMIC_IOSONLY, readonly) xpc_object_t XPCNumber;

@end
