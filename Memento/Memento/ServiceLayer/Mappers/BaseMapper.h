//
//  BaseMapper.h
//  Memento
//
//  Created by Andrey Morozov on 04.06.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"


@interface BaseMapper : NSObject

/*!
 * @brief Create model object from json format.
 * @param json Json data represents single object.
 * @return created object.
 */
- (id)modelFromJsonOfObject:(NSDictionary *)json;

/*!
 * @brief Create model objects from json data
 * @param json Json data represents  many objects.
 * @return created objects.
 */
- (NSMutableArray <id> *)modelsFromJsonOfListObject:(NSDictionary *)json;

/*!
 * @brief Serialize model object to json format
 * @param model Object which is being serialized.
 * @return Json data from model.
 */
- (NSDictionary *)jsonFromModel:(id)model;

/*!
 * @brief Serialize model objects to json format.
 * @param models Object which is being serialized.
 * @return Json data from models.
 */
- (NSDictionary *)jsonFromModelArray:(NSArray <id> *)models;


@end
