#import "CoreDataService.h"

@interface CoreDataService()

//-(void) copyDbFromBundle;
-(void) setPersistentStore;

@end

@implementation CoreDataService

static CoreDataService *s_sharedInstance = nil;

NSString* const kDatabaseName = @"Skylock.sqlite";

- (id)init {
    self = [super init];
    if (self) {
		[self setPersistentStore];
    }
    return self;
}

+ (CoreDataService *)sharedInstance {
	if (s_sharedInstance == nil) {
		s_sharedInstance = [[CoreDataService alloc] init];
	}
	
	return s_sharedInstance;
}

#pragma mark - Core data init

//- (void)copyDatabaseFromBundle {
//#warning - TODO create and add updated DB before store!!!
//	
//	// get database path in bundle
//	NSString *inBundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
//	
//	// get documents database path
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
//	NSString *documentsDirectory = [paths objectAtIndex:0];
//	NSString *docPath = [documentsDirectory stringByAppendingPathComponent:DB_NAME];
//	
//	// check if database in documents already exist
//	if([[NSFileManager defaultManager] fileExistsAtPath:docPath] == NO){
//		// copy database from bundle
//		NSError* err = nil;
//		[[NSFileManager defaultManager] copyItemAtPath:inBundlePath toPath:docPath error:&err];
//		if (err != nil) {
//			DLog(@"Database copy error: %@", err);
//		}
//		
//		DLog(@"Copied database URL: %@", docPath);
//	}
//}

- (void)setPersistentStore {
	NSError *error = nil;
	
	// init persistent store
	
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Skylock" withExtension:@"momd"];
	//NSLog(@"Model URL %@", modelURL);
	NSManagedObjectModel* model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	
	NSURL* documentsUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
	NSURL *storeURL = [documentsUrl URLByAppendingPathComponent:kDatabaseName];
	NSPersistentStoreCoordinator* coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	if (![coord addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
	{
		// replace store
		[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
		error = nil;
		if (![coord addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
			NSLog(@"Store Error %@", error);
			abort();
		}
	}  
	
	_managedObjectContext = [[NSManagedObjectContext alloc] init];
	[_managedObjectContext setPersistentStoreCoordinator:coord];
}

#pragma mark -

#pragma mark database methods

- (void)emptyTableForClass:(Class)inClass {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(inClass) inManagedObjectContext:[self managedObjectContext]];
	[request setEntity:entity];
	
	NSError *error = nil;
	NSArray *items = [_managedObjectContext executeFetchRequest:request error:&error];
	
	for (NSManagedObject *managedObject in items) {
		[_managedObjectContext deleteObject:managedObject];
	}
	if (![_managedObjectContext save:&error]) {
		NSLog(@"Error deleting - error:%@",error);
	}
}

- (id)getNewCoreDataObjectForClass:(Class)inClass{
	return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(inClass) inManagedObjectContext:[self managedObjectContext]];
}

- (id)coreDataObjectForClass:(Class)inClass create:(BOOL)inCreate{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(inClass) inManagedObjectContext:[self managedObjectContext]];
	[request setEntity:entity];
	
	NSError *error = nil;
	NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];	
	if (error != nil) {
		NSLog(@"Error %@", error);
	}
	
	id obj = [array lastObject];
	
	if (obj == nil) {
		obj = [self getNewCoreDataObjectForClass:inClass];
	}
	
	return obj;
}

- (NSArray*)allCoreDataObjectsForClass:(Class)inClass{
	return [self allCoreDataObjectsForClass:inClass sortedBy:nil];
}

- (NSArray*)allCoreDataObjectsForClass:(Class)inClass whereAttr:(NSString*)inAttr equals:(id)inObj{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(inClass) inManagedObjectContext:[self managedObjectContext]];
	[request setEntity:entity];
	
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", inAttr, inObj];
	[request setPredicate:predicate];
	
	NSError *error = nil;
	NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];	
	if (error != nil) {
		NSLog(@"Error %@", error);
	}
	return array;
}

- (NSArray*)allCoreDataObjectsForClass:(Class)inClass sortedBy:(NSArray*)inSortDescs{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(inClass) inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    
    request.sortDescriptors = inSortDescs;
    NSError *error = nil;
    NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (error != nil) {
        NSLog(@"Error %@", error);
    }
    return array;
}

-(void) deleteObjects:(NSSet*)inObjs{
	for (NSManagedObject* o in inObjs) {
		[o.managedObjectContext deleteObject:o];
	}
}

-(void)deleteObject:(NSManagedObject *)inObj
{
    [inObj.managedObjectContext deleteObject:inObj];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

@end
