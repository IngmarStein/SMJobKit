#import "SMJDiagnostics.h"
#import "SMJCompatibility.h"
#import "NSDictionary+XPCInterop.h"
#import <Foundation/Foundation.h>


@implementation NSDictionary (XPCInterop)

+ (instancetype) dictionaryWithXPCDictionary:(xpc_object_t)xpcDictionary
{
  AssertXPCObjectType(xpcDictionary, XPC_TYPE_DICTIONARY);
  
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithCapacity:xpc_dictionary_get_count(xpcDictionary)];
  xpc_dictionary_apply(xpcDictionary, ^bool(const char* key, xpc_object_t xpcValue)
  {
    dictionary[@(key)] = [NSObject objectWithXPCObject:xpcValue];

    return true;
  });
  
  return dictionary;
}

- (xpc_object_t) XPCDictionary
{
  xpc_object_t result = xpc_dictionary_create(NULL, NULL, 0);
  
  [self enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
    xpc_object_t xpcObject = [object XPCObject];
    xpc_dictionary_set_value(result, [key UTF8String], xpcObject);
    
    // xpc_dictionary_set_value retains the input objects, so we need to clean up
    SAFE_XPC_RELEASE(xpcObject);
  }];
  
  return result;
}

- (xpc_object_t) XPCObject
{
  return [self XPCDictionary];
}

@end
