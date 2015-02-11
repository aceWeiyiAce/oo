//
//  ITTBaseModelObject.h
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/*!
 *	The Super class of all custom model. All type of property must be NSObject type
 */
@interface ITTBaseModelObject : NSObject <NSCoding, NSCopying>
{
}

- (id)initWithDataDic:(NSDictionary*)data;

/*!
 *	Subclass must override this method, otherwise app will crash if call this methods
 *	Key-Value pair by dictionary key name and property name.
 *	key:    property name
 *	value:  dictionary key name
 *	\returns a dictionary key-value pair by property name and key of data dictionary
 */
- (NSDictionary*)attributeMapDictionary;

/*!
 *	You can implement this. Default implementation nil is returned
 */
- (NSString*)customDescription;

- (NSData*)getArchivedData;

- (NSDictionary*)propertiesAndValuesDictionary;


@end
