#import "NSObject+XPCInterop.h"

#import <Foundation/NSString.h>
#import <xpc/xpc.h>

@interface NSString (XPCInterop)

+ (instancetype) stringWithXPCString:(xpc_object_t)xpcString;
@property (NS_NONATOMIC_IOSONLY, readonly) xpc_object_t XPCString;

@end
