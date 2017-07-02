//
//  CoreDataManager.h
//  Memento
//
//  Created by Andrey Morozov on 02.07.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObject;

@interface CoreDataManager : NSObject

+ (instancetype)manager;
- (NSArray *)getManagedObjectsOfType:(NSString *)type
                       withPredicate:(NSPredicate *)predicate
                     sortDescriptors:(NSArray <NSSortDescriptor *> *)sortDescriptors
                               error:(NSError *)error;

- (NSManagedObject *)createManagedObjectForType:(NSString *)type;
- (void)removeManagedObject:(NSManagedObject *)managedObject;
- (NSError *)saveChanges;

@end
