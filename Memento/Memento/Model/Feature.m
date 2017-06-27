//
//  Feature.m
//  Memento
//
//  Created by Andrey Morozov on 27.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "Feature.h"

@interface Feature ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *detailInformation;
@property (nonatomic, copy) NSString *imageName;

@end

@implementation Feature

- (instancetype)initWithName:(NSString *)name detailDescription:(NSString *)details imageName:(NSString *)imageName {
    self = [super init];
    
    if (self) {
        _name = name;
        _detailDescription = details;
        _imageName = imageName;
    }
    
    return self;
}

+ (instancetype)featureWithName:(NSString *)name detailDescription:(NSString *)details imageName:(NSString *)imageName {
    return [[self alloc] initWithName:name detailDescription:details imageName:imageName];
}

@end
