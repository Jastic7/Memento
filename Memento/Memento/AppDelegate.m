//
//  AppDelegate.m
//  Memento
//
//  Created by Andrey Morozov on 04.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "AppDelegate.h"
#import "Firebase.h"
#import "CoreDataManager.h"

@interface AppDelegate ()

@property (nonatomic, strong) CoreDataManager *coreDataManager;

@end



@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];
    self.coreDataManager = [CoreDataManager manager];
    
    UIFont *font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                            NSFontAttributeName: font}];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
//    [self.coreDataManager saveChanges];
    

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [self.coreDataManager saveChanges];

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
//    [self.coreDataManager saveChanges];
    self.saveChangesBlock();
    
}


@end
