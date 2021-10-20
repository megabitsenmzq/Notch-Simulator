//
//  main.m
//  Notch Simulator Helper
//
//  Created by Jinyu Meng on 2021/10/20.
//

#import <Cocoa/Cocoa.h>

int main(int argc, const char * argv[]) {
    
    BOOL running = NO;
    BOOL active = NO;
    
    NSArray *applications = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.JinyuMeng.Notch-Simulator"];
    if (applications.count > 0) {
        NSRunningApplication *application = [applications firstObject];
        
        running = YES;
        active = [application isActive];
    }
    
    if (!running && !active) {
        NSArray *pathComponents = [[[NSBundle mainBundle] bundlePath] pathComponents];
        pathComponents = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 4)];
        NSString *path = [NSString pathWithComponents:pathComponents];
        [[NSWorkspace sharedWorkspace] launchApplication:path];
    }
    [NSApp terminate:nil];
    return NSApplicationMain(argc, argv);
}

