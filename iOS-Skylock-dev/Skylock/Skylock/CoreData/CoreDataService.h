#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "CDUsers.h"
#import "CDUser.h"
#import "CDLock.h"
#import "CDLock+Skylock.h"
#import "CDBike.h"
#import "CDBike+Skylock.h"

@interface CoreDataService : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext* managedObjectContext;

@property (nonatomic, strong) CDUser *user;

+ (CoreDataService *)sharedInstance;

- (void)saveContext;

- (id)getNewCoreDataObjectForClass:(Class)inClass;
- (id)coreDataObjectForClass:(Class)inClass create:(BOOL)inCreate;
- (void)deleteObjects:(NSSet*)inObjs;
-(void)deleteObject:(NSManagedObject *)inObj;

- (NSArray*)allCoreDataObjectsForClass:(Class)inClass;
- (NSArray*)allCoreDataObjectsForClass:(Class)inClass whereAttr:(NSString*)inAttr equals:(id)inObj;
- (NSArray*)allCoreDataObjectsForClass:(Class)inClass sortedBy:(NSArray*)inSortDescs;
- (void)emptyTableForClass:(Class)inClass;

@end