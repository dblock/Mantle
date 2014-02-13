//
//  MTL238Spec.m
//  Mantle
//
//  Created by Daniel Doubrovkine on 2/13/14.
//  Copyright (c) 2014 GitHub. All rights reserved.
//

@interface TestClass : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) Class klass;
- (instancetype) initWithClass:(Class)klass;
@end

@implementation TestClass

- (instancetype) initWithClass:(Class)klass
{
	self = [super init];
	
	if (self) {
		_klass = klass;
	}
	
	return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
	return @{
        @"klass" : @"klass_type",
	};
}

+ (NSValueTransformer *)klassJSONTransformer {
	return [MTLValueTransformer transformerWithBlock:^(NSString *str) {
		return NSClassFromString(str);
	}];
}

@end

SpecBegin(TestClass)

it(@"from JSON", ^{
	TestClass *testInstance = [MTLJSONAdapter modelOfClass:[TestClass class] fromJSONDictionary:@{ @"klass_type" : @"NSString" } error:nil];
	expect(testInstance.klass).to.equal([NSString class]);
});

it(@"serialize", ^{
	TestClass *testInstance = [[TestClass alloc] initWithClass:[NSString class]];
	expect(testInstance.klass).to.equal([NSString class]);
	expect(^{
		[NSKeyedArchiver archivedDataWithRootObject:testInstance];
	}).to.raise(@"NSInvalidArgumentException");
});

pending(@"deserialize", ^{
	// TODO: doens't reproduce the problem
	expect(^{
		// TODO: get the path from Bundle
		[NSKeyedUnarchiver unarchiveObjectWithFile:@"/Users/dblock/source/mantle/dblock/MantleTests/238.data"];
	}).to.raise(@"NSInvalidArgumentException");
});

SpecEnd
