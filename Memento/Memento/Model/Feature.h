//
//  Feature.h
//  Memento
//
//  Created by Andrey Morozov on 27.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feature : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *detailDescription;
@property (nonatomic, copy, readonly) NSString *imageName;

- (instancetype)initWithName:(NSString *)name detailDescription:(NSString *)details imageName:(NSString *)imageName;
+ (instancetype)featureWithName:(NSString *)name detailDescription:(NSString *)details imageName:(NSString *)imageName;

@end
