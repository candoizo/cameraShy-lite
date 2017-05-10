
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>


#define kBundlePath @"/Library/Application Support/cameraShy/Themes/"
#define kSelfBundlePath @"/Library/PreferenceBundles/cameraShyPrefs.bundle"


@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(id)arg1;

@optional
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1;
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 inTableView:(id)arg2;
@end

@interface PSTableCell ()
- (id)initWithStyle:(int)style reuseIdentifier:(id)arg2;
@end

@interface PSListController ()
-(void)clearCache;
-(void)reload;
-(void)viewWillAppear:(BOOL)animated;
@end

@interface CSLShared : NSObject
+(NSString *)localisedStringForKey:(NSString *)key;
+(void)parseSpecifiers:(NSArray *)specifiers;
@end

@implementation CSLShared

+(NSString *)localisedStringForKey:(NSString *)key {
	NSString *englishString = [[NSBundle bundleWithPath:[NSString stringWithFormat:@"%@/en.lproj",kSelfBundlePath]] localizedStringForKey:key value:@"" table:nil];
	return [[NSBundle bundleWithPath:kSelfBundlePath] localizedStringForKey:key value:englishString table:nil];
}

+(void)parseSpecifiers:(NSArray *)specifiers {
	for (PSSpecifier *specifier in specifiers) {
		NSString *localisedTitle = [CSLShared localisedStringForKey:specifier.properties[@"label"]];
		NSString *localisedFooter = [CSLShared localisedStringForKey:specifier.properties[@"footerText"]];
		[specifier setProperty:localisedFooter forKey:@"footerText"];
		specifier.name = localisedTitle;
	}
}
@end

@interface cameraShyPrefsListController: PSListController {
}
@end

@implementation cameraShyPrefsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"cameraShyPrefs" target:self] retain];
	}
	[CSLShared parseSpecifiers:_specifiers];
	return _specifiers;
}

-(void)twitterButton {
	NSString *user = @"candoizo";
	if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];

	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];

	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];

	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];

	else
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];

}

-(void)paypalButton {
		NSString *userr = @"andreasott";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://www.paypal.me/" stringByAppendingString:userr]]];
}

-(void)fireButton {
	//playlists/303896337
	NSString *track = @"303896337";
	if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"soundcloud:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"soundcloud://playlists:" stringByAppendingString:track]]];
	else	if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"youtube:"]])
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"youtube://6HlnjWwNqrY" stringByAppendingString:track]]];
		else
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://soundcloud.com/wvlfboy/dashin" stringByAppendingString:@""]]];
}
-(void)btcButton {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://s31.postimg.org/dufu1c897/g_VVu_LWE.png" stringByAppendingString:@""]]];
}
-(void)bugButton {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://ghostbin.com/paste/p8zwt" stringByAppendingString:@""]]];
}
@end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////BUTTONS ARE ABOVE, OTHER SHIT IS BELOW////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface cameraShyTitleCell : PSTableCell <PreferencesTableCustomView> {
	UILabel *tweakTitle;
	UILabel *tweakSubtitle;
}

@end

@implementation cameraShyTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {

		int width = self.contentView.bounds.size.width;

		CGRect frame = CGRectMake(0, 20, width, 60);
		CGRect subtitleFrame = CGRectMake(0, 55, width, 60);

		tweakTitle = [[UILabel alloc] initWithFrame:frame];
		[tweakTitle setNumberOfLines:1];
		[tweakTitle setFont:[UIFont fontWithName:@"GillSans-Light" size:48]];
		[tweakTitle setText:@"cameraShy lite"];
		[tweakTitle setBackgroundColor:[UIColor clearColor]];
		[tweakTitle setTextColor:[UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1.0]];
		[tweakTitle setTextAlignment:NSTextAlignmentCenter];
		tweakTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		tweakTitle.contentMode = UIViewContentModeScaleToFill;

		tweakSubtitle = [[UILabel alloc] initWithFrame:subtitleFrame];
		[tweakSubtitle setNumberOfLines:1];
		[tweakSubtitle setFont:[UIFont fontWithName:@"SanFranciscoRounded-Light" size:18]];
		[tweakSubtitle setText:[CSLShared localisedStringForKey:@"FIRST_SUBTITLE_TEXT"]];
		[tweakSubtitle setBackgroundColor:[UIColor clearColor]];
		[tweakSubtitle setTextColor:[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1.0]];
		[tweakSubtitle setTextAlignment:NSTextAlignmentCenter];
		tweakSubtitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		tweakSubtitle.contentMode = UIViewContentModeScaleToFill;

		[self addSubview:tweakTitle];
		[self addSubview:tweakSubtitle];
	}

	return self;
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
	return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cameraShyTitleCell" specifier:specifier];
}

- (void)setFrame:(CGRect)frame {
	frame.origin.x = 0;
	[super setFrame:frame];
}

- (CGFloat)preferredHeightForWidth:(CGFloat)arg1{
    return 125.0f;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width inTableView:(id)tableView {
	return [self preferredHeightForWidth:width];
}

@end
