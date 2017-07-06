//
//  CoreDataManager.m
//  Memento
//
//  Created by Andrey Morozov on 02.07.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>


@interface CoreDataManager ()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedContext;

@end

@implementation CoreDataManager

#pragma mark - Initialization

+ (instancetype)manager {
    static CoreDataManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [CoreDataManager new];
        [manager setupCoreDataStack];
    });
    
    return manager;
}

- (void)setupCoreDataStack {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Memento" withExtension:@"momd"];
        
        self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *databaseName = [paths.firstObject stringByAppendingPathComponent:@"Database.sqlite"];
        NSURL *storeURL = [NSURL fileURLWithPath:databaseName];
        
        [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration:nil
                                                                URL:storeURL
                                                            options:nil
                                                              error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.managedContext = [[NSManagedObjectContext alloc]  initWithConcurrencyType:NSMainQueueConcurrencyType];
            [self.managedContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
            self.managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        });
        
    });
}


#pragma mark - Implementation

- (NSArray *)getManagedObjectsOfType:(NSString *)type
                       withPredicate:(NSPredicate *)predicate
                     sortDescriptors:(NSArray <NSSortDescriptor *> *)sortDescriptors
                               error:(NSError *)error {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:type];
    
    if (predicate) {
        fetchRequest.predicate = predicate;
    }
    
    if (sortDescriptors) {
        fetchRequest.sortDescriptors = sortDescriptors;
    }
    
    return [self.managedContext executeFetchRequest:fetchRequest error:&error];
}

- (NSManagedObject *)createManagedObjectForType:(NSString *)type {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:type inManagedObjectContext:self.managedContext];
    
    NSManagedObject *managedObject = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedContext];
    
    return managedObject;
}

- (void)removeManagedObject:(NSManagedObject *)managedObject {
    [self.managedContext deleteObject:managedObject];
}

- (NSError *)saveChanges {
    NSError *error = nil;
    if (self.managedContext.hasChanges) {
        [self.managedContext save:&error];
    }
    return error;
}


@end
