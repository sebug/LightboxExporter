//
//  LightboxExportPluginBox.h
//  LightboxExporter
//

#import <Cocoa/Cocoa.h>
#import "ExportPluginProtocol.h"
#import "ExportPluginBoxProtocol.h"

@interface LightboxExportPluginBox : NSBox <ExportPluginBoxProtocol> {
	IBOutlet id <ExportPluginProtocol> mPlugin;
}

- (BOOL)performKeyEquivalent:(NSEvent *)anEvent;
@end
