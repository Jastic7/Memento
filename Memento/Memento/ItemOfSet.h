//
//  ItemOfSet.h
//  Memento
//
//  Created by Andrey Morozov on 05.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemOfSet : NSObject

@property (nonatomic, copy) NSString *term;
@property (nonatomic, copy) NSString *definition;

-(instancetype)initWithTerm:(NSString *)term definition:(NSString *)definition;
+(instancetype)itemOfSetWithTerm:(NSString *)term definition:(NSString *)definition;

@end
