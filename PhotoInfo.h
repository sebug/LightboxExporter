//
//  PhotoInfo.h
//  LightboxExporter
//

#import <Cocoa/Cocoa.h>


@interface PhotoInfo : NSObject {
	NSString *mFilename;
	NSString *mDescription;
	int mWidth;
	int mHeight;
}

-(PhotoInfo*) initWithFilename: (NSString *)fn;
-(void) setWidth: (int)w andHeight: (int)h;
-(void) setDescription: (NSString *)desc;
-(NSString *) htmlRepresentationWithPath: (NSString *)path tag: (NSString*) t isXHTML: (BOOL)iX;
@end
