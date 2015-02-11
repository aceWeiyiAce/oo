//
//  NSJSONSerialization+ITTAdditions.h
//  ConvertObjectToJson
//
//  Created by Sword on 13-11-14.
//  Copyright (c) 2013年 Sword. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (ITTAdditions)

/*!
 *	Convert an array of object to a string of json format
 *	\param array An array of object, object contains custom object and system primary object. Such as NSString NSDictionary NSArray etc.
 *	\returns A string of json format
 */
+ (NSString*)jsonStringFromArray:(NSArray*)array;

/*!
 *	Convert a dictionary to a string of json format
 *	\param dictionary A dictionary the key of dictionary must be NSString type,
 *  value of dictionary can be custom object and system primary object. Such as NSString NSDictionary NSArray etc.
 *	\returns A string of json format
 */
+ (NSString*)jsonStringFromDictionary:(NSDictionary*)dictionary;

@end
