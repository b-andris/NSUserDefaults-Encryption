//
//  ViewController.m
//  userdefaults
//
//  Created by Benjamin Andris Suter-Dörig on 30/09/14.
//  Copyright (c) 2014 Benjamin Andris Suter-Dörig. All rights reserved.
//

#import "ViewController.h"
#import "NSUserDefaults+Encryption.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *keyTextView;
@property (weak, nonatomic) IBOutlet UITextField *valueTextView;
@property (weak, nonatomic) IBOutlet UITextView *encryptedTextView;
@property (weak, nonatomic) IBOutlet UITextView *decryptedTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[NSUserDefaults setPassword:@"SOME PASSWORD"];
	[self reloadView];
}

- (IBAction)save:(id)sender {
	[[NSUserDefaults standardUserDefaults] setEncryptedObject:[NSJSONSerialization JSONObjectWithData:[self.valueTextView.text dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:NULL] forKey:self.keyTextView.text];
	[self reloadView];
}

- (IBAction)load:(id)sender {
	self.valueTextView.text = [self stringFromJSONObject:[[NSUserDefaults standardUserDefaults] decryptedObjectForKey:self.keyTextView.text]];
	[self reloadView];
}

- (IBAction)delete:(id)sender {
	NSLog(@"%@",[[NSUserDefaults standardUserDefaults] decryptedObjectForKey:self.keyTextView.text]);
	[[NSUserDefaults standardUserDefaults] removeEncryptedObjectForKey:self.keyTextView.text];
	NSLog(@"%@",[[NSUserDefaults standardUserDefaults] decryptedObjectForKey:self.keyTextView.text]);
	[self reloadView];
}

- (void)reloadView{
	[self.keyTextView resignFirstResponder];
	[self.valueTextView resignFirstResponder];
	self.encryptedTextView.text = [self stringFromJSONObject:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
	self.decryptedTextView.text = [self stringFromJSONObject:[[NSUserDefaults standardUserDefaults] decryptedDictionaryRepresentation]];
}

- (NSString*)stringFromJSONObject:(id)object{
	object = [self ensureObjectSafetyForJSONObject:object];
	if (object == [NSNull null]) {
		return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:object options:(NSJSONWritingOptions)NSJSONReadingAllowFragments error:NULL] encoding:NSUTF8StringEncoding];
	} else {
		return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:NULL] encoding:NSUTF8StringEncoding];
	}

}

- (id)ensureObjectSafetyForJSONObject:(id)object{
	if ([object isKindOfClass:[NSDictionary class]]) {
		NSMutableDictionary* objectCopy = [object mutableCopy];
		for (NSInteger i = 0; i < objectCopy.count; i++) {
			NSString* key = objectCopy.allKeys[i];
			objectCopy[key] = [self ensureObjectSafetyForJSONObject:objectCopy[key]];
		}
		return objectCopy;
	} else if ([object isKindOfClass:[NSArray class]]) {
		NSMutableArray* objectCopy = [object mutableCopy];
		for (NSInteger i = 0; i < objectCopy.count; i++) objectCopy[i] = [self ensureObjectSafetyForJSONObject:objectCopy[i]];
		return objectCopy;
	} else if ([object isKindOfClass:[NSString class]]) {
		return [object copy];
	} else if ([object isKindOfClass:[NSNumber class]]) {
		return [object copy];
	} else if ([object isKindOfClass:[NSData class]]) {
		return [object base64EncodedStringWithOptions:0];
	}
	return [NSNull null];
}

@end
