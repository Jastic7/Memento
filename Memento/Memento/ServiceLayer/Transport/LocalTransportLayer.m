//
//  LocalTransportLayer.m
//  Memento
//
//  Created by Andrey Morozov on 29.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "LocalTransportLayer.h"
#import "SetMO+CoreDataClass.h"
#import "ItemMO+CoreDataClass.h"
#import <CoreData/CoreData.h>
#import "SetMapper.h"
#import <FirebaseDatabase/FirebaseDatabase.h>
#import <FirebaseAuth/FirebaseAuth.h>

static LocalTransportLayer *sharedInstance = nil;

@interface LocalTransportLayer ()

@property (nonatomic, copy) NSString *modelName;
@property (nonatomic, strong) NSPersistentContainer *container;
@property (nonatomic, readonly) NSManagedObjectContext *managedContext;

//@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end


@implementation LocalTransportLayer

#pragma mark - Getters

- (NSPersistentContainer *)container {
    if (!_container) {
        _container = [[NSPersistentContainer alloc] initWithName:self.modelName];
        [_container.viewContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [_container loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull description, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Unresolved error while LocalTrasportLayer configuring: %@", error);
            }
        }];
    }
    
    return _container;
}

- (NSManagedObjectContext *)managedContext {
    return self.container.viewContext;
}



#pragma mark - Singleton

+ (instancetype)managerWithModelName:(NSString *)modelName {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.modelName = modelName;
    });
    
    return sharedInstance;
}


#pragma mark - TransportLayerProtocol Implementation

- (NSString *)uniqueId {
    return [[[FIRDatabase database] reference] childByAutoId].key;
}


#pragma mark - Authentication

- (void)logOut:(NSError *)error {
    [[FIRAuth auth] signOut:&error];
}

- (void)createNewUserWithEmail:(NSString *)email
                      password:(NSString *)password
                       success:(SuccessCompletionBlock)success
                       failure:(FailureCompletionBlock)failure {
    NSString *errorMessage = @"Network connection is not avaliable. Please check it and try sign up again.";
    failure([self errorWithMessage:errorMessage]);
}

- (void)authorizeWithEmail:(NSString *)email
                  password:(NSString *)password
                   success:(SuccessCompletionBlock)success
                   failure:(FailureCompletionBlock)failure {
    NSString *errorMessage = @"Network connection is not avaliable. Please check it and try log in again.";
    failure([self errorWithMessage:errorMessage]);
}

- (void)addListenerForAuthStateChange:(void (^)(id))listener {
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
        if (user) {
            listener(user.uid);
        } else {
            listener(nil);
        }
    }];
}


#pragma mark - Updating

- (void)establishEditedEmail:(NSString *)email
             currentPassword:(NSString *)password
                     success:(SuccessCompletionBlock)success
                     failure:(FailureCompletionBlock)failure {
    NSString *errorMessage = @"Network connection is not avaliable. Please check it and try update email again.";
    failure([self errorWithMessage:errorMessage]);
}

- (void)establishEditedPassword:(NSString *)password
                currentPassword:(NSString *)currentPassword
                     completion:(TransportCompletionBlock)completion {
    NSString *errorMessage = @"Network connection is not avaliable. Please check it and try update password again.";
    completion([self errorWithMessage:errorMessage]);
}


#pragma mark - Data retrieving

- (void)obtainDataWithParameters:(NSDictionary <NSString *, NSString *> *)parameters
                         success:(SuccessCompletionBlock)success
                         failure:(FailureCompletionBlock)failure {
    NSString *dataType = parameters[@"dataType"];
    NSString *dataId   = parameters[@"dataId"];
    NSString *ownerId  = parameters[@"ownerId"];
    
    if ([dataType isEqualToString:@"sets"]) {
        NSFetchRequest *setRequest = [SetMO fetchRequest];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ownerIdentifier = %@", ownerId];
        setRequest.predicate = predicate;
        
        NSError *error;
        NSArray <SetMO *> *results = [self.managedContext executeFetchRequest:setRequest error:&error];
        if (error) {
            failure(error);
        } else {
            id response = [self jsonFromSetsMO:results];
            success(response);
        }
    }
}


#pragma mark - Data saving

- (void)postData:(id)jsonData
      parameters:(NSDictionary <NSString *, NSString *> *)parameters
      completion:(TransportCompletionBlock)completion {
    NSString *dataType = parameters[@"dataType"];
    
    if ([dataType isEqualToString:@"sets"]) {
        SetMO *setMO = [self saveSet:jsonData];
        setMO.identifier = parameters[@"dataId"];
        setMO.ownerIdentifier = parameters[@"ownerId"];
    }
    
    [self saveChanges];
}


#pragma mark - Mapper

- (NSDictionary *)jsonFromSetsMO:(NSArray <SetMO *> *)setsMO {
    NSString *uniqueId;
    NSMutableDictionary *jsonModels = [NSMutableDictionary dictionary];
    
    for (SetMO *setMO in setsMO) {
        uniqueId = setMO.identifier;
        NSDictionary *json = [self jsonFromSetMO:setMO];
        
        jsonModels[uniqueId] = json;
    }
    
    return jsonModels;
}

- (NSDictionary *)jsonFromSetMO:(SetMO *)setMO {
    NSDictionary *itemsMO = [self jsonFromItemsMO:setMO.items];
    
    NSDictionary *jsonModel = @{ @"author"          : setMO.author,
                                 @"definitionLang"  : setMO.definitionLang,
                                 @"termLang"        : setMO.termLang,
                                 @"title"           : setMO.title,
                                 @"items"           : itemsMO,
                                 @"identifier"      : setMO.identifier };
    
    return jsonModel;
}

- (NSDictionary *)jsonFromItemsMO:(NSOrderedSet<ItemMO *> *)itemsMO {
    NSString *uniqueId;
    NSMutableDictionary *jsonModels = [NSMutableDictionary dictionary];
    
    for (ItemMO *itemMO in itemsMO) {
        uniqueId = itemMO.identifier;
        NSDictionary *json = [self jsonFromItemMO:itemMO];
        
        jsonModels[uniqueId] = json;
    }
    
    return jsonModels;
}

- (NSDictionary *)jsonFromItemMO:(ItemMO *)itemMO {
    NSDictionary <NSString *, id> *jsonModel = @{ @"term"           : itemMO.term,
                                                  @"definition"     : itemMO.definition,
                                                  @"learnProgress"  : itemMO.learnProgress,
                                                  @"identifier"     : itemMO.identifier };
    
    return jsonModel;
}


#pragma mark - Helpers

- (NSError *)errorWithMessage:(NSString *)errorMessage {
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : NSLocalizedString(errorMessage,nil)};
    NSError *error = [NSError errorWithDomain:@"Memento" code:-7 userInfo:userInfo];
    
    return error;
}


#pragma mark - Private

- (SetMO *)saveSet:(id)jsonData {
    NSDictionary <NSString *, id> *setDictionary = jsonData;
    NSFetchRequest *setRequest = [SetMO fetchRequest];
    setRequest.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", setDictionary[@"identifier"]];
    
    NSMutableOrderedSet <ItemMO *> *currentItems;
    SetMO *setMO = [self.managedContext executeFetchRequest:setRequest error:nil].firstObject;
    if (setMO) {
        currentItems = [setMO.items mutableCopy];
    } else {
        setMO = [[SetMO alloc]initWithContext:self.managedContext];
    }
    
    NSOrderedSet <ItemMO *> *insertedItems = [NSOrderedSet new];
    for (NSString *key in setDictionary) {
        if ([key isEqualToString:@"items"]) {
            NSDictionary *itemsMOJson = setDictionary[key];
            insertedItems = [self saveItems:itemsMOJson];
        } else {
            id value = setDictionary[key];
            [setMO setValue:value forKey:key];
        }
    }
    
    [currentItems minusSet:[insertedItems set]];
    for (ItemMO *deletingItem in currentItems) {
        [self.managedContext deleteObject:deletingItem];
    }
    
    setMO.items = insertedItems;
    return setMO;
}

- (NSOrderedSet <ItemMO *> *)saveItems:(id)jsonData {
    NSDictionary *itemsMODict = jsonData;
    NSMutableOrderedSet <ItemMO *> *insertedItemsMO = [NSMutableOrderedSet new];
    for (NSString *key in itemsMODict) {
        NSDictionary *itemMODict = itemsMODict[key];
        ItemMO *insertedItemMO = [self saveItem:itemMODict];
        [insertedItemsMO addObject:insertedItemMO];
    }
    
    return [insertedItemsMO copy];
}

- (ItemMO *)saveItem:(id)jsonData {
    NSDictionary <NSString *, NSString *> *itemDictionary = jsonData;
    ItemMO *itemMO = [[ItemMO alloc] initWithContext:self.managedContext];
    
    for (NSString *key in itemDictionary) {
        NSString *value = itemDictionary[key];
        [itemMO setValue:value forKey:key];
    }
    
    return itemMO;
}

- (void)saveChanges {
    if (self.managedContext.hasChanges) {
        NSError *error;
        [self.managedContext save:&error];
        
        if (error) {
            NSLog(@"Unresolved error while LocalTrasportLayer are saving changes: %@", error);
        }
    }
}

@end
