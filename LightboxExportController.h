//
//  LightboxExportController.h
//  LightboxExporter
//

#import <Cocoa/Cocoa.h>
#import "ExportPluginProtocol.h"

@interface LightboxExportController : NSObject <ExportPluginProtocol> {
	id <ExportImageProtocol> mExportMgr;
	
	IBOutlet NSBox <ExportPluginBoxProtocol> *mSettingsBox;
	IBOutlet NSControl *mFirstView;
	
	IBOutlet NSTextField *mTagField;
	IBOutlet NSTextField *mPhotoPathField;
	IBOutlet NSButton    *mXSnippetButton;
	
	NSString *mExportDir;
	NSString *mTag;
	NSString *mPhotoPath;
	int      mXSnippet;
	
	ExportPluginProgress mProgress;
	NSLock *mProgressLock;
	BOOL mCancelExport;
}

// overrides
- (void)awakeFromNib;
- (void)dealloc;

// getters/setters
- (NSString *)exportDir;
- (void)setExportDir:(NSString *)dir;
- (NSString *)tag;
- (void)setTag:(NSString *)t;
- (NSString *)photoPath;
- (void)setPhotoPath: (NSString *)path;
- (int)xSnippet;
- (void)setXSnippet: (int)state;
@end
