//
//  AppDelegate.m
//  MedicalCase
//
//  Created by ihefe-JF on 15/4/1.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataStack.h"

#import "RawDataProcess.h"
#import "IHMsgSocket.h"
#import "MessageObject+DY.h"

@interface AppDelegate ()
@property (nonatomic,strong) CoreDataStack *coreDataStack;
@property (nonatomic,strong) RawDataProcess *rawDataProcess;
@end

@implementation AppDelegate

@synthesize revealSideViewController = _revealSideViewController;

-(IHMsgSocket *)socket
{
    if (!_socket) {
        _socket = [IHMsgSocket sharedRequest];
        [_socket connectToHost:@"192.168.10.106" onPort:2323];
    }
    return _socket;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.coreDataStack = [[CoreDataStack alloc] init];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.rawDataProcess = [RawDataProcess sharedRawData];
    });
    
    UINavigationController *nav = (UINavigationController*)self.window.rootViewController;
    self.revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:nav];
    self.revealSideViewController.delegate = self;
    self.window.rootViewController = self.revealSideViewController;
    
    self.window.backgroundColor  = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self SaveTestDataToCoreData];
    return YES;
}
-(void)SaveTestDataToCoreData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"personInfo" ofType:@"plist"];
    NSMutableDictionary *data  =[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    [self.coreDataStack entityInitDoctorManagementWithDoctorDic:data];
}
#pragma mark - PPRevealSideViewController delegate

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller willPushController:(UIViewController *)pushedController {
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didPushController:(UIViewController *)pushedController {
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller willPopToController:(UIViewController *)centerController {
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didPopToController:(UIViewController *)centerController {
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didChangeCenterController:(UIViewController *)newCenterController {
    
}

- (BOOL) pprevealSideViewController:(PPRevealSideViewController *)controller shouldDeactivateDirectionGesture:(UIGestureRecognizer*)gesture forView:(UIView*)view {
    return NO;
}

- (PPRevealSideDirection)pprevealSideViewController:(PPRevealSideViewController*)controller directionsAllowedForPanningOnView:(UIView*)view {

    
    return PPRevealSideDirectionLeft | PPRevealSideDirectionRight | PPRevealSideDirectionTop | PPRevealSideDirectionBottom;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self.coreDataStack saveContext];
}


@end
