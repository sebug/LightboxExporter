//
//  LightboxExportPluginBox.m
//  LightboxExporter
//

#import "LightboxExportPluginBox.h"


@implementation LightboxExportPluginBox

- (BOOL)performKeyEquivalent:(NSEvent *)anEvent {
	NSString *keyString = [anEvent charactersIgnoringModifiers];
	unichar keyChar = [keyString characterAtIndex:0];
	
	switch (keyChar) {
		case NSFormFeedCharacter:
		case NSNewlineCharacter:
		case NSCarriageReturnCharacter:
		case NSEnterCharacter:
		{
			[mPlugin clickExport];
			return(YES);
		}
		default:
			break;
	}
	
	return([super performKeyEquivalent:anEvent]);
}
@end
