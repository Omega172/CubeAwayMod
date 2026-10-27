#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <dlfcn.h>
#import <string.h>

static BOOL DisabledReady(id rSelf, SEL eSelector)
{
    return NO;
}

static void DisabledAction(id rSelf, SEL eSelector)
{
}

static void DisabledActionOne(id rSelf, SEL eSelector, id rValue)
{
}

static void DisabledActionTwo(id rSelf, SEL eSelector, id rFirst, id rSecond)
{
}

static void DisabledActionThree(id rSelf, SEL eSelector, id rFirst, id rSecond, id rThird)
{
}

static void HiddenBanner(id rSelf, SEL eSelector, BOOL bHidden)
{
    ((void (*)(id, SEL, BOOL))class_getMethodImplementation([UIView class], eSelector))(rSelf, eSelector, YES);
}

static void InvisibleBanner(id rSelf, SEL eSelector, CGFloat dAlpha)
{
    ((void (*)(id, SEL, CGFloat))class_getMethodImplementation([UIView class], eSelector))(rSelf, eSelector, 0);
}

static void DisabledAutoload(id rSelf, SEL eSelector, BOOL bAutoload)
{
}

static BOOL Replace(Class clTarget, const char *szSelector, IMP pReplacement, const char *szTypes)
{
    SEL eSelector = sel_registerName(szSelector);
    Method hMethod = class_getInstanceMethod(clTarget, eSelector);
    if (!hMethod || strcmp(method_getTypeEncoding(hMethod), szTypes) != 0)
        return NO;
    class_replaceMethod(clTarget, eSelector, pReplacement, method_getTypeEncoding(hMethod));
    return YES;
}

__attribute__((constructor)) static void InitializeAdDisabler(void)
{
    @autoreleasepool
    {
        if (!dlopen("@executable_path/Frameworks/AppLovinSDK.framework/AppLovinSDK", RTLD_NOW | RTLD_GLOBAL))
        {
            NSLog(@"[CubeAwayMod] Cannot load AppLovinSDK: %s", dlerror());
            return;
        }
        unsigned int uHooks = 0;
        const char *aClasses[] = { "MAInterstitialAd", "MAAppOpenAd", "MARewardedAd" };
        for (unsigned int uIndex = 0; uIndex < sizeof(aClasses) / sizeof(aClasses[0]); ++uIndex)
        {
            Class clTarget = objc_getClass(aClasses[uIndex]);
            if (!clTarget)
                continue;
            uHooks += Replace(clTarget, "isReady", (IMP)DisabledReady, "B16@0:8");
            uHooks += Replace(clTarget, "loadAd", (IMP)DisabledAction, "v16@0:8");
            uHooks += Replace(clTarget, "showAd", (IMP)DisabledAction, "v16@0:8");
            uHooks += Replace(clTarget, "showAdForPlacement:", (IMP)DisabledActionOne, "v24@0:8@16");
            uHooks += Replace(clTarget, "showAdForPlacement:customData:", (IMP)DisabledActionTwo, "v32@0:8@16@24");
            uHooks += Replace(clTarget, "showAdForPlacement:customData:viewController:", (IMP)DisabledActionThree, "v40@0:8@16@24@32");
        }
        Class clBanner = objc_getClass("MAAdView");
        if (clBanner)
        {
            uHooks += Replace(clBanner, "loadAd", (IMP)DisabledAction, "v16@0:8");
            uHooks += Replace(clBanner, "startAutoRefresh", (IMP)DisabledAction, "v16@0:8");
            uHooks += Replace(clBanner, "autoload", (IMP)DisabledReady, "B16@0:8");
            uHooks += Replace(clBanner, "setAutoload:", (IMP)DisabledAutoload, "v20@0:8B16");
            uHooks += Replace(clBanner, "setHidden:", (IMP)HiddenBanner, "v20@0:8B16");
            uHooks += Replace(clBanner, "setAlpha:", (IMP)InvisibleBanner, "v24@0:8d16");
        }
        NSLog(@"[CubeAwayMod] Installed %u MAX ad hooks.", uHooks);
    }
}
