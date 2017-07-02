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

- (void)applicationWillTerminate:(UIApplication *)application {
    self.saveChangesBlock();
}


@end
