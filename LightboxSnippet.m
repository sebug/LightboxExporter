//
//  LightboxSnippet.m
//  LightboxExporter
//

#import "LightboxSnippet.h"


@implementation LightboxSnippet

-(LightboxSnippet *)initWithTag:(NSString *)t andPath:(NSString *)p isXHTML: (BOOL)iX {
	self = [super init];
	if (self) {
		mTag = t;
		mServerPath = p;
		mIsXHTML = iX;
		mInfoList = [NSMutableArray arrayWithCapacity:1]; // No idea about the size
		
		return self;
	}
	return self;
}

-(void)addPhoto:(PhotoInfo *)p {
	[mInfoList addObject: p];
}

-(void)writeToFile:(NSString *)filename {
	NSMutableString *ostr = [[NSMutableString alloc] initWithCapacity:100];
	for (int i = 0; i < [mInfoList count]; i++) {
		NSString *line = [[mInfoList objectAtIndex: i]
						  htmlRepresentationWithPath:mServerPath tag:mTag isXHTML:mIsXHTML];
		[ostr appendFormat: @"%@\n", line];
	}
	[ostr writeToFile: filename atomically: YES encoding: NSUTF8StringEncoding error:nil];
}
@end
