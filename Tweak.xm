#import <UIKit/UIKit.h>
#import "headers.h"

UIViewController* firstAvailableUIViewController (UIView* view){
    UIResponder *responder = [view nextResponder];
    while (responder != nil) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

void writeToLog(NSString * str){
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError* error;
        NSString* filePath = @"/var/mobile/Media/Downloads/debugSSV.log";
        NSString* newLog = [NSString stringWithFormat:@"Log:%@", str];
        
        NSString* fileString = @"";
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            fileString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        }

        fileString = [fileString stringByAppendingFormat:@"\n%@", newLog];
        [fileString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    });
}

%hook _SFWebView
-(void)didMoveToWindow{
	%orig;
	_SFWebView* sfwv = self;
	writeToLog([NSString stringWithFormat:@"Got the webview %@", sfwv]);
}
%end

static bool hasCreatedSFSVC = NO;

%hook CSMainPageView
-(void)updateForPresentation:(id)arg1 {
	%orig;
	if(!hasCreatedSFSVC){
		hasCreatedSFSVC = YES;
		CGRect frameRect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
		SFSafariViewControllerConfiguration* config = [[objc_getClass("SFSafariViewControllerConfiguration") alloc] init];
		SFSafariViewController *svc = [[objc_getClass("SFSafariViewController") alloc] initWithURL:[NSURL URLWithString:@"https://junesiphone.com/designer/"] configuration:config];
		svc.view.frame = frameRect;
		[svc _setShowingLinkPreviewWithMinimalUI:YES];    

		writeToLog([NSString stringWithFormat:@"Created SFSafariViewController %@", svc]);        

		UIViewController * vc = firstAvailableUIViewController(self);
		[vc addChildViewController:svc];

		/* Just to block touches to SFSafariView */
		UIView* webViewHolder = [[UIView alloc] initWithFrame:frameRect];
		UIView* webViewHolderCover = [[UIView alloc] initWithFrame:frameRect];
		[webViewHolder addSubview:svc.view];
		[webViewHolder addSubview:webViewHolderCover];
		[webViewHolder bringSubviewToFront:webViewHolderCover];
		webViewHolderCover.backgroundColor = [UIColor blackColor];
		webViewHolderCover.alpha = 0.01;
		[self addSubview:webViewHolder];
		[self sendSubviewToBack:webViewHolder];
	}

}
%end