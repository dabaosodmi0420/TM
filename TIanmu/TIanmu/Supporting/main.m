//
//  main.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/12.
//

#import <UIKit/UIKit.h>
#import "TMAppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([TMAppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
