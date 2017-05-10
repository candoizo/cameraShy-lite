#define kPrefsAppID 					CFSTR("com.candoizo.camerashy")
#define kSettingsChangedNotification 	CFSTR("com.candoizo.camerashy.settingschanged")

@interface SBDashBoardPageControl
-(long long)numberOfPages;
@end

static BOOL nosuggest;
static BOOL solidg;

static void loadPreferences() {
	CFPreferencesAppSynchronize(kPrefsAppID);
	solidg = !CFPreferencesCopyAppValue(CFSTR("solidg"), kPrefsAppID) ? YES : [CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("solidg"), kPrefsAppID)) boolValue];
  nosuggest = !CFPreferencesCopyAppValue(CFSTR("nosuggest"), kPrefsAppID) ? NO : [CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("nosuggest"), kPrefsAppID)) boolValue];
}
static void prefsCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	loadPreferences();
}


%hook SBDashBoardPageControl //hides page indicators
-(void)setCurrentPage:(long long)arg1 {
  if(solidg) { %orig(2);} //2 for camera (this seems to work if theres less than 2 for some reason)

	else { %orig; }
}

- (id)_pageIndicatorImage:(_Bool)arg1 { return nil;} //no images for the dots, weeeeeee

-(double)_indicatorSpacing { //spacing inbetween

if ([self numberOfPages] == 1) { return %orig; } //no camera so do nothing

else if ([self numberOfPages] == 2) {
  NSLog(@"pages was 2");
	//check the orientation
	double screenHeight = [[%c(UIScreen) mainScreen] bounds].size.height;
	double screenWidth = [[%c(UIScreen) mainScreen] bounds].size.width;

if (screenWidth > screenHeight) { //roatated
		float tempHeight = screenWidth;
		screenWidth = screenHeight;
		screenHeight = tempHeight;
		double sweet2th = screenWidth*1.7;
		return sweet2th;
}
else {
  double sweet2th = screenWidth*0.93; //double sweet2th = screenWidth*0.91844; this is old
  return sweet2th;
}
}

else { //was 3 or more somehow

 double screenHeight = [[%c(UIScreen) mainScreen] bounds].size.height; //pretty sure there's an easier way
 double screenWidth = [[%c(UIScreen) mainScreen] bounds].size.width;

if (screenWidth > screenHeight) {
    float tempHeight = screenWidth;
    screenWidth = screenHeight;
    screenHeight = tempHeight;
		double sweet = screenWidth*0.845;
		return sweet;
}
else {
//this is getting logged a bajillion times.. fix it from using too much data declaring sweet over and over
  double sweet = screenWidth*0.466666;
  return sweet;
}
}


}
%end

%hook SBDashBoardSlideUpToAppController //hides app grabber because it hides my thingy for some reason, probably because i actually end up extending the frame with my method of choice :p
-(void)_setTargetApp:(id)arg1 withAppSuggestion:(id)arg2 {
  if(!nosuggest){
    %orig();
}
else {
//we dont do anything
}
}
%end

//--------------------------------Preferences
%ctor {
	@autoreleasepool {
		loadPreferences();

		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
			NULL,
			(CFNotificationCallback)prefsCallback,
			kSettingsChangedNotification,
			NULL,
			CFNotificationSuspensionBehaviorDeliverImmediately
		);
	}
}
