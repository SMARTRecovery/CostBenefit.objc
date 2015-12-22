//
//  SMRCoreDataStack.h
//  SMARTRecovery
//
//  Created by Aaron Schachter on 3/30/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SMRCoreDataStack : NSObject

@property (nonatomic,strong,readonly) NSManagedObjectContext* managedObjectContext;

- (id)initWithStoreURL:(NSURL*)storeURL modelURL:(NSURL*)modelURL;

@end
