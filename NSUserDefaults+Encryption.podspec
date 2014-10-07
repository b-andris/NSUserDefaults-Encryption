Pod::Spec.new do |s|
	s.name         = "NSUserDefaults+Encryption"
	s.version      = "1.0.0"
	s.summary      = "A category adding support for AES encrypted key-value pairs to NSUserDefaults"
	s.homepage     = "https://github.com/b-andris/NSUserDefaults-Encryption"

	s.license = { 
    :type => 'MIT', 
    :text => <<-LIC
© 2014 Benjamin Andris Suter-Dörig

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
LIC
}

	s.author       = "Benjamin Andris Suter-Dörig"

	s.source       = { :git => "https://github.com/b-andris/NSUserDefaults-Encryption.git", :tag => s.version.to_s }

	s.source_files = "userdefaults/NSUserDefaults+Encryption.{h,m}"

	s.requires_arc = true

	s.dependency "RNCryptor", "~> 2.2"
	
	s.ios.deployment_target = '5.0'
	s.osx.deployment_target = '10.7'
end