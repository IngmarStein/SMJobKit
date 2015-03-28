#import "SMJTestClient.h"
#import "SMJMissingClient.h"
#import "SMJErrorTypes.h"
@import XCTest;

@interface SMJClientTests : XCTestCase
@end

@implementation SMJClientTests

- (void) testBundledVersion
{
  XCTAssertEqualObjects([SMJTestClient bundledVersion], @"0.01", @"Missing/wrong version");
  XCTAssertEqualObjects([SMJMissingClient bundledVersion], nil, @"Missing client should return nil");
}

- (void) testInstalledVersion
{
  XCTAssertEqualObjects([SMJTestClient installedVersion], nil, @"Missing client should return nil");
}

- (void) testForProblems
{
  XCTAssertNil([SMJTestClient checkForProblems], @"TestService should not have problems");
  
  NSArray* errors = [SMJMissingClient checkForProblems];
  XCTAssertEqual(errors.count, (NSUInteger)1, @"MissingService should have one error");
  NSError* error = [errors objectAtIndex:0];
  XCTAssertEqual((SMJErrorCode)error.code, SMJErrorCodeBundleNotFound, @"Missing service should be missing");
}

@end
