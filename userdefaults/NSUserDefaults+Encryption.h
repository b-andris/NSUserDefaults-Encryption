//
//  NSUserDefaults+Encryption.h
//  userdefaults
//
//  Created by Benjamin Andris Suter-Dörig on 30/09/14.
//  Copyright (c) 2014 Benjamin Andris Suter-Dörig. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
	BAVolatileDomainTypeNone = 0,
	BAVolatileDomainTypeEncrypted = 1<<0,
	BAVolatileDomainTypeUnencrypted = 1<<1,
	BAVolatileDomainTypeAll = -1,
} BAVolatileDomainType;

@interface NSUserDefaults (Encryption)

+ (void)setPassword:(NSString*)pPassword useKeyChache:(BOOL) useKeyCache;

- (NSArray *)decryptedArrayForKey:(NSString *)defaultName;
- (BOOL)decryptedBoolForKey:(NSString *)defaultName;
- (NSData *)decryptedDataForKey:(NSString *)defaultName;
- (NSDictionary *)decryptedDictionaryForKey:(NSString *)defaultName;
- (double)decryptedDoubleForKey:(NSString *)defaultName;
- (float)decryptedFloatForKey:(NSString *)defaultName;
- (NSInteger)decryptedIntegerForKey:(NSString *)defaultName;
- (id)decryptedObjectForKey:(NSString *)defaultName;
- (NSArray *)decryptedStringArrayForKey:(NSString *)defaultName;
- (NSMutableArray*)decryptedMutableArrayValueForKey:(NSString*)defaultName;
- (NSString *)decryptedStringForKey:(NSString *)defaultName;
- (NSURL *)decryptedURLForKey:(NSString *)defaultName;

- (void)setEncryptedBool:(BOOL)value forKey:(NSString *)defaultName;
- (void)setEncryptedFloat:(float)value forKey:(NSString *)defaultName;
- (void)setEncryptedInteger:(NSInteger)value forKey:(NSString *)defaultName;
- (void)setEncryptedObject:(id)value forKey:(NSString *)defaultName;
- (void)setEncryptedDouble:(double)value forKey:(NSString *)defaultName;
- (void)setEncryptedURL:(NSURL *)url forKey:(NSString *)defaultName;

- (void)removeEncryptedObjectForKey:(NSString *)defaultName;

- (void)registerEncryptedDefaults:(NSDictionary *)dictionary;
- (BOOL)encryptedObjectIsForcedForKey:(NSString *)key;
- (BOOL)encryptedObjectIsForcedForKey:(NSString *)key inDomain:(NSString *)domain;
- (BOOL)encryptedObjectIsForcedForKey:(NSString *)key inEncryptedDomain:(NSString *)domain;
- (BOOL)objectIsForcedForKey:(NSString *)key inEncryptedDomain:(NSString *)domain;
- (void)setPersistentEncryptedDomain:(NSDictionary *)domain forName:(NSString *)domainName;
- (NSDictionary *)decryptedPersistentDomainForName:(NSString *)domainName;

- (void)removeVolatileEncryptedDomainForName:(NSString *)domainName;
- (void)setVolatileEncryptedDomain:(NSDictionary *)domain forName:(NSString *)domainName;
- (NSDictionary *)decryptedVolatileDomainForName:(NSString *)domainName;
- (NSArray*)namesOfVolatileDomainsOfType:(BAVolatileDomainType)type;

- (NSDictionary *)decryptedDictionaryRepresentation;

- (void)addEncryptedSuiteNamed:(NSString *)suiteName;
- (void)removeEncryptedSuiteNamed:(NSString *)suiteName;

@end
