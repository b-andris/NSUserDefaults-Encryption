# NSUserDefaults+Encryption

A category adding support for AES encrypted key-value pairs to NSUserDefaults.

## Usage

``` objc
[NSUserDefaults setPassword:<#password#>];

[[NSUserDefaults standardUserDefaults] setEncryptedFloat:1.0 forKey:@"1.0"];
```

## Installation

### Cocoapods

Add
```
pod 'NSUserDefaults+Encryption', :git => 'https://github.com/b-andris/NSUserDefaults-Encryption.git', :tag => '1.0.0'
```
to your Podfile.

### Manual

Copy the NSUserDefaults+Encryption.h and the NSUserDefaults+Encryption.m files into your Xcode project.

## Encryption

All encryption is performed by [RNCryptor](https://github.com/RNCryptor/RNCryptor).

NOTE: In order to enable lookup the [sha256](http://en.wikipedia.org/wiki/SHA-2#Examples_of_SHA-2_variants) hashes of all encrypted keys are stored in plain text making them vulnerable to dictionary attacks.

(Key meaning the argument of methods such as
```
-[NSUserDefaults objectForKey:]
```
and not the encryption key)

A discussion on the security implications of this can be found [here](A discussion on the security aspects of using a plaintext hash as IV : http://security.stackexchange.com/questions/4594/when-using-aes-and-cbc-can-the-iv-be-a-hash-of-the-plaintext).

## Version History

* 1.0.0 Implemented a encrypted version of many documented NSUserDefaults methods.


## LICENSE

NSUserDefaults+Encryption is available under the MIT license:
```
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```