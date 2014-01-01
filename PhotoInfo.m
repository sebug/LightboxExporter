//
//  PhotoInfo.m
//  LightboxExporter
//

#import "PhotoInfo.h"


@implementation PhotoInfo

-(PhotoInfo*)initWithFilename:(NSString *)fn {
	self = [super init];
	
	if (self) {
		mFilename = [fn retain];
	}
	
	return self;
}

-(void)setWidth:(int)w andHeight:(int)h {
	mWidth = w;
	mHeight = h;
}

-(void)setDescription:(NSString *)desc {
	mDescription = desc;
}

-(NSString*)htmlRepresentationWithPath:(NSString *)path tag: (NSString *)t isXHTML:(BOOL) iX {
	NSString *imageEnd = @"";
	if (iX) imageEnd = @" /";
	return [NSString stringWithFormat:
			@"<a rel=\"lightbox[%@]\" href=\"%@/big/%@\" title=\"%@\"><img src=\"%@/small/%@\" width=\"%d\" height=\"%d\" alt=\"\"%@></a>",
			t,
			path,
			mFilename,
			mDescription,
			path,
			mFilename,
			mWidth,
			mHeight,
			imageEnd];
}
@end
