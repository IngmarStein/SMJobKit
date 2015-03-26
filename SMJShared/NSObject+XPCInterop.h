#import <Foundation/NSObject.h>
#import <xpc/xpc.h>

@interface NSObject (XPCInterop)

+ (instancetype) objectWithXPCObject:(xpc_object_t)xpcObject;
@property (NS_NONATOMIC_IOSONLY, readonly) xpc_object_t XPCObject;

@end
