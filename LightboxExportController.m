//
//  LightboxExportController.m
//  LightboxExporter
//

#import "LightboxExportController.h"
#import "PhotoInfo.h"
#import "LightboxSnippet.h"
#import <QuickTime/QuickTime.h>
#import <QTKit/QTKit.h>

@implementation LightboxExportController

const int BIG_SIZE = 800; // Size of the big photos
const int SMALL_SIZE = 320; // Size of the small photos

- (void)awakeFromNib {
	[mTagField setStringValue: @""];
	[mPhotoPathField setStringValue: @""];
	[mXSnippetButton setState:NSOffState];
}

- (id)initWithExportImageObj:(id <ExportImageProtocol>)obj {
	if(self = [super init]) {
		mExportMgr = obj;
		mProgress.message = nil;
		mProgressLock = [[NSLock alloc] init];
	}
	return self;
}

- (void)dealloc {
	[mExportDir release];
	[mProgressLock release];
	[mProgress.message release];
	
	[super dealloc];
}

- (NSString *)exportDir { return mExportDir; }
- (void) setExportDir:(NSString *)dir {
	[mExportDir release];
	mExportDir = [dir retain];
}

- (NSString *)tag { return mTag; }
- (void)setTag:(NSString *)t {
	[mTag release];
	mTag = [t retain];
}

- (NSString *)photoPath { return mPhotoPath; }
- (void)setPhotoPath:(NSString *)path {
	[mPhotoPath release];
	mPhotoPath = [path retain];
}

- (int)xSnippet { return mXSnippet; }
- (void)setXSnippet:(int)state {
	mXSnippet = state;
}

- (NSView <ExportPluginBoxProtocol> *)settingsView {
	return mSettingsBox;
}

- (NSView *)firstView {
	return mFirstView;
}

- (void)viewWillBeActivated {}
- (void)viewWillBeDeactivated {}

- (NSString *)requiredFileType {
	if([mExportMgr imageCount] > 1) return @"";
	else return @"jpg";
}

- (BOOL)wantsDestinationPrompt {
	return YES;
}

- (NSString *)getDestinationPath {
	return @"";
}

- (NSString *)defaultFileName {
	if([mExportMgr imageCount] > 1) return @"";
	else return @"pic-0";
}

- (NSString *)defaultDirectory {
	return @"~/Desktop/";
}

- (BOOL)treatSingleSelectionDifferently {
	return NO;
}

- (BOOL)handlesMovieFiles {
	return NO;
}

- (BOOL)validateUserCreatedPath:(NSString *)path {
	return NO;
}

- (void)clickExport {
	[mExportMgr clickExport];
}

- (void)startExport:(NSString *)path {
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	
	[self setTag: [mTagField stringValue]];
	[self setPhotoPath: [mPhotoPathField stringValue]];
	[self setXSnippet: [mXSnippetButton state]];
	
	// First, try to see whether the directories already exist
	NSString *bigImageDir = [path stringByAppendingString: @"/big"];
	NSString *smallImageDir = [path stringByAppendingString: @"/small"];
	
	BOOL canStartExport = YES;
	NSString *snippetFile = [path stringByAppendingString: @"/snippet.html"];
	if ([fileMgr fileExistsAtPath: snippetFile]) canStartExport = FALSE;
	
	if (canStartExport &&
		([fileMgr fileExistsAtPath:bigImageDir] ||
		[fileMgr fileExistsAtPath:smallImageDir])) {
		int count = [mExportMgr imageCount];
		int i;
		for (i = 0; canStartExport && i < count; i++) {
			NSString *filename = [NSString stringWithFormat: @"pic-%d.jpg", i];
			if ([fileMgr fileExistsAtPath:
				 [bigImageDir stringByAppendingPathComponent: filename]] ||
				[fileMgr fileExistsAtPath:
				 [smallImageDir stringByAppendingPathComponent: filename]])
				canStartExport = NO;
		}
	}
	if (!canStartExport &&
		NSRunCriticalAlertPanel(@"Files exist",
								@"One or more images already exist in directory.",
								@"Replace", nil, @"Cancel") == NSAlertDefaultReturn)
		canStartExport = YES;
	if (canStartExport) [mExportMgr startExport];
}

- (void)performExport:(NSString *)path {
	int count = [mExportMgr imageCount];
	BOOL succeeded = YES;
	mCancelExport = NO;
	
	[self setExportDir:path];
	
	// Export options for big and small images
	ImageExportOptions bigOptions,smallOptions;
	bigOptions.format = kQTFileTypeJPEG;
	bigOptions.rotation = 0.0;
	bigOptions.metadata = NO;
	bigOptions.quality = EQualityHigh;
	smallOptions = bigOptions;
	
	// Size of the images to export
	bigOptions.width = bigOptions.height = BIG_SIZE;
	smallOptions.width = smallOptions.height = SMALL_SIZE;
	
	[self lockProgress];
	mProgress.indeterminateProgress = NO;
	mProgress.totalItems = count - 1;
	[mProgress.message autorelease];
	mProgress.message = @"Exporting";
	[self unlockProgress];
	
	// The export directories (which we might have to create)
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSString *bigImageDir = [[self exportDir] stringByAppendingString: @"/big"];
	NSString *smallImageDir = [[self exportDir] stringByAppendingString: @"/small"];
	
	if (![fileMgr fileExistsAtPath:bigImageDir]) {
		[fileMgr createDirectoryAtPath:bigImageDir
				 withIntermediateDirectories: YES
				 attributes: nil
								 error: NULL];
	}
	if (![fileMgr fileExistsAtPath:smallImageDir]) {
		[fileMgr createDirectoryAtPath:smallImageDir
		   withIntermediateDirectories: YES
							attributes: nil
								 error: NULL];
	}
	
	// Collect HTML snippet information
	BOOL isX = NO;
	if ([self xSnippet]) isX = YES;
	LightboxSnippet *snippet = [[LightboxSnippet alloc] initWithTag:[self tag] andPath: [self photoPath] isXHTML: isX];
	
	NSString *dest;
	int i;
	for (i = 0; mCancelExport == NO && succeeded == YES && i < count; i++) {
		[self lockProgress];
		mProgress.currentItem = i;
		[mProgress.message autorelease];
		mProgress.message = [[NSString stringWithFormat: @"Image %d of %d", i + 1, count]
							 retain];
		[self unlockProgress];
		
		dest = [bigImageDir stringByAppendingPathComponent:
				[NSString stringWithFormat:@"pic-%d.jpg", i]];
		succeeded = [mExportMgr exportImageAtIndex:i dest:dest options:&bigOptions];
		if (succeeded) {
			dest = [smallImageDir stringByAppendingPathComponent:
					[NSString stringWithFormat:@"pic-%d.jpg", i]];
			succeeded = [mExportMgr exportImageAtIndex:i dest:dest options:&smallOptions];
		}
		
		// Now, for the file info
		PhotoInfo *pInfo = [[PhotoInfo alloc] initWithFilename:[NSString stringWithFormat:@"pic-%d.jpg", i]];
		NSSize sz = [mExportMgr imageSizeAtIndex:i];
		int smallwidth = SMALL_SIZE;
		int smallheight = SMALL_SIZE;
		if (sz.width > sz.height) smallheight = (sz.height / sz.width) * SMALL_SIZE;
		else if (sz.height > sz.width) smallwidth = (sz.width / sz.height) * SMALL_SIZE;
		
		[pInfo setWidth:smallwidth andHeight:smallheight]; // note: float -> int conversion
		if ([mExportMgr imageCommentsAtIndex:i]) {
			[pInfo setDescription:[mExportMgr imageCommentsAtIndex:i]];
		} else {
			[pInfo setDescription: @""];
		}
		[snippet addPhoto:pInfo];
	}
	
	[snippet writeToFile:[[self exportDir] stringByAppendingPathComponent:@"snippet.html"]];
	
	// Handle failure
	if (!succeeded) {
		[self lockProgress];
		[mProgress.message autorelease];
		mProgress.message = [[NSString
							  stringWithFormat:@"Unable to create image %d", i] retain];
		[self cancelExport];
		mProgress.shouldCancel = YES;
		[self unlockProgress];
		return;
	}
	
	[self lockProgress];
	[mProgress.message autorelease];
	mProgress.message = nil;
	mProgress.shouldStop = YES;
	[self unlockProgress];
}

- (ExportPluginProgress *)progress {
	return &mProgress;
}

- (void)lockProgress {
	[mProgressLock lock];
}

- (void)unlockProgress {
	[mProgressLock unlock];
}

- (void)cancelExport {
	mCancelExport = YES;
}

- (NSString *)name {
	return @"Lightbox exporter";
}
@end
