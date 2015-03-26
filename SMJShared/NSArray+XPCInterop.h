#import "NSObject+XPCInterop.h"

#import <Foundation/NSArray.h>
#import <xpc/xpc.h>

@interface NSArray (XPCInterop)

+ (instancetype) arrayWithXPCArray:(xpc_object_t)xpcArray;
@property (NS_NONATOMIC_IOSONLY, readonly) xpc_object_t XPCArray;

@end
