//
//  LightboxSnippet.h
//  LightboxExporter
//

#import <Cocoa/Cocoa.h>
#import "PhotoInfo.h"


@interface LightboxSnippet : NSObject {
	NSString       *mTag;
	NSString       *mServerPath;
	BOOL           mIsXHTML;
	NSMutableArray *mInfoList;
}

-(LightboxSnippet *)initWithTag: (NSString *)t andPath: (NSString *)p isXHTML: (BOOL)iX;
-(void)addPhoto: (PhotoInfo*)p;
-(void)writeToFile: (NSString *)filename;
@end
