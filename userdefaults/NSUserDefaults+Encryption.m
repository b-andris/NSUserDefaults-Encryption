//
//  NSUserDefaults+Encryption.m
//  userdefaults
//
//  Created by Benjamin Andris Suter-Dörig on 30/09/14.
//  Copyright (c) 2014 Benjamin Andris Suter-Dörig. All rights reserved.
//

#import "NSUserDefaults+Encryption.h"
#import "RNDecryptor.h"
#import "RNEncryptor.h"

#define ENCRYPTED_KEY_PREFIX @"ch.unibe.biology.encrypted.userdefaults.encrypted.key."

static NSString* password = nil;
static NSMutableDictionary* keyCache = nil;

@implementation NSUserDefaults (Encryption)

#pragma mark - set password
+ (void)setPassword:(NSString*)pPassword useKeyChache:(BOOL) useKeyCache{
	if (useKeyCache && [password isEqualToString:pPassword]) return;
	keyCache = useKeyCache?[NSMutableDictionary dictionary]:nil;
	password = pPassword;
}

#pragma mark - access encrypted defaults
- (NSArray *)decryptedArrayForKey:(NSString *)defaultName{
	id plist = [self decryptedObjectForKey:defaultName];
	return [plist isKindOfClass:[NSArray class]]?plist:nil;
}

- (BOOL)decryptedBoolForKey:(NSString *)defaultName{
	id plist = [self decryptedObjectForKey:defaultName];
	return [plist isKindOfClass:[NSNumber class]]?[plist boolValue]:NO;
}

- (NSData *)decryptedDataForKey:(NSString *)defaultName{
	id plist = [self decryptedObjectForKey:defaultName];
	return [plist isKindOfClass:[NSData class]]?plist:nil;
}

- (NSDictionary *)decryptedDictionaryForKey:(NSString *)defaultName{
	id plist = [self decryptedObjectForKey:defaultName];
	return [plist isKindOfClass:[NSDictionary class]]?plist:nil;
}

- (double)decryptedDoubleForKey:(NSString *)defaultName{
	id plist = [self decryptedObjectForKey:defaultName];
	return [plist isKindOfClass:[NSNumber class]]?[plist doubleValue]:NO;
}

- (float)decryptedFloatForKey:(NSString *)defaultName{
	id plist = [self decryptedObjectForKey:defaultName];
	return [plist isKindOfClass:[NSNumber class]]?[plist floatValue]:NO;
}

- (NSInteger)decryptedIntegerForKey:(NSString *)defaultName{
	id plist = [self decryptedObjectForKey:defaultName];
	return [plist isKindOfClass:[NSNumber class]]?[plist integerValue]:NO;
}

- (id)decryptedObjectForKey:(NSString *)defaultName{
	id plist = [self objectForKey:[self encryptedKeyForUnencryptedKey:defaultName]];
	return [self decryptedObject:plist];
}

- (NSArray *)decryptedStringArrayForKey:(NSString *)defaultName{
	id plist = [self decryptedObjectForKey:defaultName];
	if (![plist isKindOfClass:[NSArray class]]) return nil;
	for (id string in plist) if (![string isKindOfClass:[NSString class]]) return nil;
	return plist;
}

- (NSString *)decryptedStringForKey:(NSString *)defaultName{
	id plist = [self decryptedObjectForKey:defaultName];
	return [plist isKindOfClass:[NSString class]]?plist:nil;
}

- (NSURL *)decryptedURLForKey:(NSString *)defaultName{
	id plist = [self decryptedObjectForKey:defaultName];
	return [plist isKindOfClass:[NSString class]]?[NSURL URLWithString:plist]:nil;
}

#pragma mark - set encrypted defaults
- (void)setEncryptedBool:(BOOL)value forKey:(NSString *)defaultName{
	[self setEncryptedObject:@(value) forKey:defaultName];
}

- (void)setEncryptedFloat:(float)value forKey:(NSString *)defaultName{
	[self setEncryptedObject:@(value) forKey:defaultName];
}

- (void)setEncryptedInteger:(NSInteger)value forKey:(NSString *)defaultName{
	[self setEncryptedObject:@(value) forKey:defaultName];
}

- (void)setEncryptedObject:(id)value forKey:(NSString *)defaultName{
	if (value) {
		[self setObject:[self encryptedObject:value]
				 forKey:[self encryptedKeyForUnencryptedKey:defaultName]];
	} else {
		[self removeEncryptedObjectForKey:defaultName];
	}
}

- (void)setEncryptedDouble:(double)value forKey:(NSString *)defaultName{
	[self setEncryptedObject:@(value) forKey:defaultName];
}

- (void)setEncryptedURL:(NSURL *)url forKey:(NSString *)defaultName{
	[self setEncryptedObject:url.absoluteString forKey:defaultName];
}

- (void)removeEncryptedObjectForKey:(NSString *)defaultName{
	[self removeObjectForKey:[self encryptedKeyForUnencryptedKey:defaultName]];
}

- (void)registerEncryptedDefaults:(NSDictionary *)dictionary{
	[self registerDefaults:[self encryptedContentOfDictionary:dictionary]];
}

#pragma mark - management
- (BOOL)encryptedObjectIsForcedForKey:(NSString *)key{
	return [self objectIsForcedForKey:[self encryptedKeyForUnencryptedKey:key]];
}

- (BOOL)encryptedObjectIsForcedForKey:(NSString *)key inDomain:(NSString *)domain{
	return [self objectIsForcedForKey:[self encryptedKeyForUnencryptedKey:key]
							 inDomain:domain];
}

- (BOOL)encryptedObjectIsForcedForKey:(NSString *)key inEncryptedDomain:(NSString *)domain{
	return [self objectIsForcedForKey:[self encryptedKeyForUnencryptedKey:key]
							 inDomain:[self encryptedKeyForUnencryptedKey:domain]];
}

- (BOOL)objectIsForcedForKey:(NSString *)key inEncryptedDomain:(NSString *)domain{
	return [self objectIsForcedForKey:key
							 inDomain:[self encryptedKeyForUnencryptedKey:domain]];
}

- (void)setPersistentEncryptedDomain:(NSDictionary *)domain forName:(NSString *)domainName{
	NSDictionary* encryptedDomain = [self encryptedContentOfDictionary:domain];
	[self setPersistentDomain:encryptedDomain forName:[self encryptedKeyForUnencryptedKey:domainName]];
}

- (NSDictionary *)decryptedPersistentDomainForName:(NSString *)domainName{
	NSDictionary* encryptedDomain = [self persistentDomainForName:[self encryptedKeyForUnencryptedKey:domainName]];
	return [self decryptedContentOfDictionary:encryptedDomain];
}

- (void)removeVolatileEncryptedDomainForName:(NSString *)domainName{
	[self removeVolatileDomainForName:[self encryptedKeyForUnencryptedKey:domainName]];
}

- (void)setVolatileEncryptedDomain:(NSDictionary *)domain forName:(NSString *)domainName{
	NSDictionary* encryptedDomain = [self encryptedContentOfDictionary:domain];
	[self setVolatileDomain:encryptedDomain forName:[self encryptedKeyForUnencryptedKey:domainName]];
}

- (NSDictionary *)decryptedVolatileDomainForName:(NSString *)domainName{
	NSDictionary* encryptedDomain = [self volatileDomainForName:[self encryptedKeyForUnencryptedKey:domainName]];
	return [self decryptedContentOfDictionary:encryptedDomain];
}

- (NSArray*)namesOfVolatileDomainsOfType:(BAVolatileDomainType)type{
	NSArray* encryptedNames = self.volatileDomainNames;
	NSMutableArray* names = [NSMutableArray arrayWithCapacity:encryptedNames.count];
	for (NSString* name in encryptedNames) {
		if ([name rangeOfString:ENCRYPTED_KEY_PREFIX].location != 0) {
			if (type & BAVolatileDomainTypeEncrypted) [names addObject:[self decryptedKeyForEncryptedKey:name]];
		} else {
			if (type & BAVolatileDomainTypeUnencrypted) [names addObject:name];
		}
	}
	return names;
}

- (NSDictionary *)decryptedDictionaryRepresentation{
	return [self decryptedContentOfDictionary:[self dictionaryRepresentation]];
}

- (void)addEncryptedSuiteNamed:(NSString *)suiteName{
	[self addSuiteNamed:[self encryptedKeyForUnencryptedKey:suiteName]];
}

- (void)removeEncryptedSuiteNamed:(NSString *)suiteName{
	[self removeSuiteNamed:[self encryptedKeyForUnencryptedKey:suiteName]];
}

#pragma mark - helpers
- (NSString*)encryptedKeyForUnencryptedKey:(NSString*)lookupKey{
	if (keyCache[lookupKey]) return keyCache[lookupKey];
	NSData* data = [lookupKey dataUsingEncoding:NSUTF8StringEncoding];
	uint8_t* hash = malloc(CC_SHA256_DIGEST_LENGTH);
	CC_SHA256([data bytes], (CC_LONG)[data length], hash);
	NSData* keyHash = [NSData dataWithBytes:hash length:CC_SHA256_DIGEST_LENGTH];
	free(hash);
	data = [RNEncryptor encryptData:data
					   withSettings:kRNCryptorAES256Settings
						   password:password IV:[keyHash subdataWithRange:NSMakeRange(0, 16)]
					 encryptionSalt:[keyHash subdataWithRange:NSMakeRange(16, 8)]
						   HMACSalt:[keyHash subdataWithRange:NSMakeRange(24, 8)]
							  error:NULL];
	NSString* key = [ENCRYPTED_KEY_PREFIX stringByAppendingString:[data base64EncodedStringWithOptions:0]];
	keyCache[lookupKey] = key;
	return key;
}

- (NSString*)decryptedKeyFromKeyChacheForEcryptedKey:(NSString*)key{
	__block NSString* decryptedKey = nil;
	[keyCache enumerateKeysAndObjectsUsingBlock:^(NSString* dictionaryKey, NSString* obj, BOOL *stop) {
		if ([obj isEqualToString:key]) {
			decryptedKey = dictionaryKey;
			*stop = YES;
		}
	}];
	return decryptedKey;
}

- (NSString*)decryptedKeyForEncryptedKey:(NSString*)key{
	NSString* decryptedKey = [self decryptedKeyFromKeyChacheForEcryptedKey:key];
	if (decryptedKey) return decryptedKey;
	if ([key rangeOfString:ENCRYPTED_KEY_PREFIX].location != 0) return nil;
	NSString* base64 = [key stringByReplacingOccurrencesOfString:ENCRYPTED_KEY_PREFIX withString:@""];
	NSData* encryptedKey = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
	NSData* keyData = [RNDecryptor decryptData:encryptedKey withPassword:password error:NULL];
	decryptedKey = [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];
	keyCache[decryptedKey] = key;
	return decryptedKey;
}

- (NSData*)encryptedObject:(id)object{
	NSData* pListData = [NSPropertyListSerialization dataWithPropertyList:object
																   format:NSPropertyListBinaryFormat_v1_0
																  options:0
																	error:NULL];
	return [RNEncryptor encryptData:pListData withSettings:kRNCryptorAES256Settings password:password error:NULL];
}

- (id)decryptedObject:(NSData*)data{
	NSData* pListData = [RNDecryptor decryptData:data withPassword:password error:NULL];
	return [NSPropertyListSerialization propertyListWithData:pListData options:0 format:NULL error:NULL];
}

- (NSDictionary*)encryptedContentOfDictionary:(NSDictionary*)dictionary{
	NSMutableDictionary* encryptedDictionary = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];
	for (NSString* key in dictionary.keyEnumerator) {
		[encryptedDictionary setObject:[self encryptedObject:dictionary[key]]
							forKey:[self encryptedKeyForUnencryptedKey:key]];
	}
	return encryptedDictionary;
}

- (NSDictionary*)decryptedContentOfDictionary:(NSDictionary*)dictionary{
	NSMutableDictionary* decryptedDictionary = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];
	for (NSString* key in dictionary.keyEnumerator) {
		if ([key rangeOfString:ENCRYPTED_KEY_PREFIX].location == 0) {
			[decryptedDictionary setObject:[self decryptedObject:dictionary[key]]
									forKey:[self decryptedKeyForEncryptedKey:key]];
		} else {
			[decryptedDictionary setObject:dictionary[key] forKey:key];
		}
	}
	return decryptedDictionary;
}

@end
