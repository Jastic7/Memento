//
//  Entity.h
//  Memento
//
//  Created by Andrey Morozov on 06.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Entity : NSObject {
    @protected
    NSString *_identifier;
}

@property (nonatomic, copy, readonly) NSString *identifier;

@end
