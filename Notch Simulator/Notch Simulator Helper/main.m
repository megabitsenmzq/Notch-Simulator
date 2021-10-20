//
//  main.m
//  Notch Simulator Helper
//
//  Created by Jinyu Meng on 2021/10/20.
//

#import <Cocoa/Cocoa.h>

int main(int argc, const char * argv[]) {
    NSArray *pathComponents = [[[NSBundle mainBundle] bundlePath] pathComponents];
    pathComponents = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 4)];
    NSString *path = [NSString pathWithComponents:pathComponents];
    [[NSWorkspace sharedWorkspace] launchApplication:path];
    return NSApplicationMain(argc, argv);
}

