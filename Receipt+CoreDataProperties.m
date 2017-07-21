//
//  Receipt+CoreDataProperties.m
//  Receipts
//
//  Created by Errol Cheong on 2017-07-20.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "Receipt+CoreDataProperties.h"

@implementation Receipt (CoreDataProperties)

+ (NSFetchRequest<Receipt *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Receipt"];
}

@dynamic amount;
@dynamic note;
@dynamic timeStamp;
@dynamic tags;

@end
