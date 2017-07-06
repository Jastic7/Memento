//
//  SetMapper.h
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "BaseMapper.h"


@interface SetMapper : BaseMapper
@property (nonatomic, readonly) NSDateFormatter *dateFormatter;
@end
