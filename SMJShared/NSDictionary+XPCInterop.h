#import "NSObject+XPCInterop.h"

#import <Foundation/NSDictionary.h>
#import <xpc/xpc.h>

@interface NSDictionary (XPCInterop)

+ (instancetype) dictionaryWithXPCDictionary:(xpc_object_t)xpcDictionary;
@property (NS_NONATOMIC_IOSONLY, readonly) xpc_object_t XPCDictionary;

@end
