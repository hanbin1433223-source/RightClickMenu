#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parent
PROJECT_DIR = ROOT / "RightClickMenu.xcodeproj"
PBXPROJ = PROJECT_DIR / "project.pbxproj"

PROJECT_DIR.mkdir(exist_ok=True)

PBXPROJ.write_text(
    r'''// !$*UTF8*$!
{
    archiveVersion = 1;
    classes = {
    };
    objectVersion = 60;
    objects = {

/* Begin PBXBuildFile section */
        A001001 /* App.swift in Sources */ = {isa = PBXBuildFile; fileRef = A001101 /* App.swift */; };
        A001002 /* ContentView.swift in Sources */ = {isa = PBXBuildFile; fileRef = A001102 /* ContentView.swift */; };
        A001003 /* FileType.swift in Sources */ = {isa = PBXBuildFile; fileRef = A001103 /* FileType.swift */; };
        A001004 /* AppConfig.swift in Sources */ = {isa = PBXBuildFile; fileRef = A001104 /* AppConfig.swift */; };
        A001005 /* FileCreator.swift in Sources */ = {isa = PBXBuildFile; fileRef = A001105 /* FileCreator.swift */; };
        A001006 /* TemplateManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = A001106 /* TemplateManager.swift */; };
        A001007 /* FileTypeList.swift in Sources */ = {isa = PBXBuildFile; fileRef = A001107 /* FileTypeList.swift */; };
        A001008 /* AppTheme.swift in Sources */ = {isa = PBXBuildFile; fileRef = A001108 /* AppTheme.swift */; };
        A001009 /* Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = A001109 /* Assets.xcassets */; };
        A001010 /* RightClickMenuExtension.appex in Embed App Extensions */ = {isa = PBXBuildFile; fileRef = A002300 /* RightClickMenuExtension.appex */; settings = {ATTRIBUTES = (RemoveHeadersOnCopy, ); }; };
        A002001 /* FinderSync.swift in Sources */ = {isa = PBXBuildFile; fileRef = A002101 /* FinderSync.swift */; };
        A002002 /* ExtensionConfig.swift in Sources */ = {isa = PBXBuildFile; fileRef = A002102 /* ExtensionConfig.swift */; };
        A002003 /* FileType.swift in Sources */ = {isa = PBXBuildFile; fileRef = A001103 /* FileType.swift */; };
        A002004 /* AppConfig.swift in Sources */ = {isa = PBXBuildFile; fileRef = A001104 /* AppConfig.swift */; };
        A002005 /* FileCreator.swift in Sources */ = {isa = PBXBuildFile; fileRef = A001105 /* FileCreator.swift */; };
        A002006 /* TemplateManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = A001106 /* TemplateManager.swift */; };
/* End PBXBuildFile section */

/* Begin PBXContainerItemProxy section */
        A003001 /* PBXContainerItemProxy */ = {
            isa = PBXContainerItemProxy;
            containerPortal = A000001 /* Project object */;
            proxyType = 1;
            remoteGlobalIDString = A002000;
            remoteInfo = RightClickMenuExtension;
        };
/* End PBXContainerItemProxy section */

/* Begin PBXCopyFilesBuildPhase section */
        A001401 /* Embed App Extensions */ = {
            isa = PBXCopyFilesBuildPhase;
            buildActionMask = 2147483647;
            dstPath = "";
            dstSubfolderSpec = 13;
            files = (
                A001010 /* RightClickMenuExtension.appex in Embed App Extensions */,
            );
            name = "Embed App Extensions";
            runOnlyForDeploymentPostprocessing = 0;
        };
/* End PBXCopyFilesBuildPhase section */

/* Begin PBXFileReference section */
        A001100 /* RightClickMenu.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = RightClickMenu.app; sourceTree = BUILT_PRODUCTS_DIR; };
        A001101 /* App.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = App.swift; sourceTree = "<group>"; };
        A001102 /* ContentView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ContentView.swift; sourceTree = "<group>"; };
        A001103 /* FileType.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Models/FileType.swift; sourceTree = "<group>"; };
        A001104 /* AppConfig.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Models/AppConfig.swift; sourceTree = "<group>"; };
        A001105 /* FileCreator.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Services/FileCreator.swift; sourceTree = "<group>"; };
        A001106 /* TemplateManager.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Services/TemplateManager.swift; sourceTree = "<group>"; };
        A001107 /* FileTypeList.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Views/FileTypeList.swift; sourceTree = "<group>"; };
        A001108 /* AppTheme.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Views/AppTheme.swift; sourceTree = "<group>"; };
        A001109 /* Assets.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; };
        A001110 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
        A001111 /* RightClickMenu.entitlements */ = {isa = PBXFileReference; lastKnownFileType = text.plist.entitlements; path = RightClickMenu.entitlements; sourceTree = "<group>"; };
        A002101 /* FinderSync.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = FinderSync.swift; sourceTree = "<group>"; };
        A002102 /* ExtensionConfig.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ExtensionConfig.swift; sourceTree = "<group>"; };
        A002103 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
        A002104 /* RightClickMenuExtension.entitlements */ = {isa = PBXFileReference; lastKnownFileType = text.plist.entitlements; path = RightClickMenuExtension.entitlements; sourceTree = "<group>"; };
        A002300 /* RightClickMenuExtension.appex */ = {isa = PBXFileReference; explicitFileType = "wrapper.app-extension"; includeInIndex = 0; path = RightClickMenuExtension.appex; sourceTree = BUILT_PRODUCTS_DIR; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
        A001202 /* Frameworks */ = {isa = PBXFrameworksBuildPhase; buildActionMask = 2147483647; files = (); runOnlyForDeploymentPostprocessing = 0; };
        A002202 /* Frameworks */ = {isa = PBXFrameworksBuildPhase; buildActionMask = 2147483647; files = (); runOnlyForDeploymentPostprocessing = 0; };
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
        A000100 = {
            isa = PBXGroup;
            children = (
                A001200 /* RightClickMenu */,
                A002200 /* RightClickMenuExtension */,
                A000200 /* Products */,
            );
            sourceTree = "<group>";
        };
        A000200 /* Products */ = {
            isa = PBXGroup;
            children = (
                A001100 /* RightClickMenu.app */,
                A002300 /* RightClickMenuExtension.appex */,
            );
            name = Products;
            sourceTree = "<group>";
        };
        A001200 /* RightClickMenu */ = {
            isa = PBXGroup;
            children = (
                A001101 /* App.swift */,
                A001102 /* ContentView.swift */,
                A001103 /* FileType.swift */,
                A001104 /* AppConfig.swift */,
                A001105 /* FileCreator.swift */,
                A001106 /* TemplateManager.swift */,
                A001107 /* FileTypeList.swift */,
                A001108 /* AppTheme.swift */,
                A001109 /* Assets.xcassets */,
                A001110 /* Info.plist */,
                A001111 /* RightClickMenu.entitlements */,
            );
            path = RightClickMenu;
            sourceTree = "<group>";
        };
        A002200 /* RightClickMenuExtension */ = {
            isa = PBXGroup;
            children = (
                A002101 /* FinderSync.swift */,
                A002102 /* ExtensionConfig.swift */,
                A002103 /* Info.plist */,
                A002104 /* RightClickMenuExtension.entitlements */,
            );
            path = RightClickMenuExtension;
            sourceTree = "<group>";
        };
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
        A001000 /* RightClickMenu */ = {
            isa = PBXNativeTarget;
            buildConfigurationList = A001500 /* Build configuration list for PBXNativeTarget "RightClickMenu" */;
            buildPhases = (
                A001201 /* Sources */,
                A001202 /* Frameworks */,
                A001203 /* Resources */,
                A001401 /* Embed App Extensions */,
            );
            buildRules = ();
            dependencies = (
                A001301 /* PBXTargetDependency */,
            );
            name = RightClickMenu;
            productName = RightClickMenu;
            productReference = A001100 /* RightClickMenu.app */;
            productType = "com.apple.product-type.application";
        };
        A002000 /* RightClickMenuExtension */ = {
            isa = PBXNativeTarget;
            buildConfigurationList = A002500 /* Build configuration list for PBXNativeTarget "RightClickMenuExtension" */;
            buildPhases = (
                A002201 /* Sources */,
                A002202 /* Frameworks */,
                A002203 /* Resources */,
            );
            buildRules = ();
            dependencies = ();
            name = RightClickMenuExtension;
            productName = RightClickMenuExtension;
            productReference = A002300 /* RightClickMenuExtension.appex */;
            productType = "com.apple.product-type.app-extension";
        };
/* End PBXNativeTarget section */

/* Begin PBXProject section */
        A000001 /* Project object */ = {
            isa = PBXProject;
            attributes = {
                BuildIndependentTargetsInParallel = 1;
                LastSwiftUpdateCheck = 1600;
                LastUpgradeCheck = 1600;
                TargetAttributes = {
                    A001000 = {CreatedOnToolsVersion = 16.0;};
                    A002000 = {CreatedOnToolsVersion = 16.0;};
                };
            };
            buildConfigurationList = A000500 /* Build configuration list for PBXProject "RightClickMenu" */;
            compatibilityVersion = "Xcode 15.0";
            developmentRegion = zh-Hans;
            hasScannedForEncodings = 0;
            knownRegions = (zh-Hans, en, Base, );
            mainGroup = A000100;
            productRefGroup = A000200 /* Products */;
            projectDirPath = "";
            projectRoot = "";
            targets = (
                A001000 /* RightClickMenu */,
                A002000 /* RightClickMenuExtension */,
            );
        };
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
        A001203 /* Resources */ = {isa = PBXResourcesBuildPhase; buildActionMask = 2147483647; files = (A001009 /* Assets.xcassets in Resources */, ); runOnlyForDeploymentPostprocessing = 0; };
        A002203 /* Resources */ = {isa = PBXResourcesBuildPhase; buildActionMask = 2147483647; files = (); runOnlyForDeploymentPostprocessing = 0; };
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
        A001201 /* Sources */ = {isa = PBXSourcesBuildPhase; buildActionMask = 2147483647; files = (A001001, A001002, A001003, A001004, A001005, A001006, A001007, A001008, ); runOnlyForDeploymentPostprocessing = 0; };
        A002201 /* Sources */ = {isa = PBXSourcesBuildPhase; buildActionMask = 2147483647; files = (A002001, A002002, A002003, A002004, A002005, A002006, ); runOnlyForDeploymentPostprocessing = 0; };
/* End PBXSourcesBuildPhase section */

/* Begin PBXTargetDependency section */
        A001301 /* PBXTargetDependency */ = {isa = PBXTargetDependency; target = A002000 /* RightClickMenuExtension */; targetProxy = A003001 /* PBXContainerItemProxy */; };
/* End PBXTargetDependency section */

/* Begin XCBuildConfiguration section */
        A000501 /* Debug */ = {isa = XCBuildConfiguration; buildSettings = {ALWAYS_SEARCH_USER_PATHS = NO; CLANG_ENABLE_MODULES = YES; CLANG_ENABLE_OBJC_ARC = YES; CLANG_WARN_DOCUMENTATION_COMMENTS = YES; CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES; COPY_PHASE_STRIP = NO; DEBUG_INFORMATION_FORMAT = dwarf; ENABLE_STRICT_OBJC_MSGSEND = YES; ENABLE_TESTABILITY = YES; GCC_C_LANGUAGE_STANDARD = gnu17; GCC_NO_COMMON_BLOCKS = YES; GCC_OPTIMIZATION_LEVEL = 0; GCC_PREPROCESSOR_DEFINITIONS = ("DEBUG=1", "$(inherited)", ); MACOSX_DEPLOYMENT_TARGET = 14.0; MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE; MTL_FAST_MATH = YES; ONLY_ACTIVE_ARCH = YES; SDKROOT = macosx; SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG; SWIFT_OPTIMIZATION_LEVEL = "-Onone"; }; name = Debug; };
        A000502 /* Release */ = {isa = XCBuildConfiguration; buildSettings = {ALWAYS_SEARCH_USER_PATHS = NO; CLANG_ENABLE_MODULES = YES; CLANG_ENABLE_OBJC_ARC = YES; CLANG_WARN_DOCUMENTATION_COMMENTS = YES; CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES; COPY_PHASE_STRIP = NO; DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym"; ENABLE_NS_ASSERTIONS = NO; ENABLE_STRICT_OBJC_MSGSEND = YES; GCC_C_LANGUAGE_STANDARD = gnu17; GCC_NO_COMMON_BLOCKS = YES; MACOSX_DEPLOYMENT_TARGET = 14.0; MTL_ENABLE_DEBUG_INFO = NO; MTL_FAST_MATH = YES; SDKROOT = macosx; SWIFT_COMPILATION_MODE = wholemodule; SWIFT_OPTIMIZATION_LEVEL = "-O"; }; name = Release; };
        A001501 /* Debug */ = {isa = XCBuildConfiguration; buildSettings = {ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon; CODE_SIGN_ENTITLEMENTS = RightClickMenu/RightClickMenu.entitlements; CODE_SIGN_STYLE = Automatic; COMBINE_HIDPI_IMAGES = YES; CURRENT_PROJECT_VERSION = 1; DEVELOPMENT_ASSET_PATHS = ""; ENABLE_PREVIEWS = YES; GENERATE_INFOPLIST_FILE = NO; INFOPLIST_FILE = RightClickMenu/Info.plist; LD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "@executable_path/../Frameworks", ); MARKETING_VERSION = 1.0; PRODUCT_BUNDLE_IDENTIFIER = com.rightclickmenu.app; PRODUCT_NAME = "$(TARGET_NAME)"; SWIFT_EMIT_LOC_STRINGS = YES; SWIFT_VERSION = 5.0; }; name = Debug; };
        A001502 /* Release */ = {isa = XCBuildConfiguration; buildSettings = {ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon; CODE_SIGN_ENTITLEMENTS = RightClickMenu/RightClickMenu.entitlements; CODE_SIGN_STYLE = Automatic; COMBINE_HIDPI_IMAGES = YES; CURRENT_PROJECT_VERSION = 1; DEVELOPMENT_ASSET_PATHS = ""; ENABLE_PREVIEWS = YES; GENERATE_INFOPLIST_FILE = NO; INFOPLIST_FILE = RightClickMenu/Info.plist; LD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "@executable_path/../Frameworks", ); MARKETING_VERSION = 1.0; PRODUCT_BUNDLE_IDENTIFIER = com.rightclickmenu.app; PRODUCT_NAME = "$(TARGET_NAME)"; SWIFT_EMIT_LOC_STRINGS = YES; SWIFT_VERSION = 5.0; }; name = Release; };
        A002501 /* Debug */ = {isa = XCBuildConfiguration; buildSettings = {CODE_SIGN_ENTITLEMENTS = RightClickMenuExtension/RightClickMenuExtension.entitlements; CODE_SIGN_STYLE = Automatic; COMBINE_HIDPI_IMAGES = YES; CURRENT_PROJECT_VERSION = 1; ENABLE_PREVIEWS = YES; GENERATE_INFOPLIST_FILE = NO; INFOPLIST_FILE = RightClickMenuExtension/Info.plist; LD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "@executable_path/../Frameworks", "@executable_path/../../../../Frameworks", ); MARKETING_VERSION = 1.0; PRODUCT_BUNDLE_IDENTIFIER = com.rightclickmenu.app.finder-extension; PRODUCT_NAME = "$(TARGET_NAME)"; SKIP_INSTALL = YES; SWIFT_EMIT_LOC_STRINGS = YES; SWIFT_VERSION = 5.0; WRAPPER_EXTENSION = appex; }; name = Debug; };
        A002502 /* Release */ = {isa = XCBuildConfiguration; buildSettings = {CODE_SIGN_ENTITLEMENTS = RightClickMenuExtension/RightClickMenuExtension.entitlements; CODE_SIGN_STYLE = Automatic; COMBINE_HIDPI_IMAGES = YES; CURRENT_PROJECT_VERSION = 1; ENABLE_PREVIEWS = YES; GENERATE_INFOPLIST_FILE = NO; INFOPLIST_FILE = RightClickMenuExtension/Info.plist; LD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "@executable_path/../Frameworks", "@executable_path/../../../../Frameworks", ); MARKETING_VERSION = 1.0; PRODUCT_BUNDLE_IDENTIFIER = com.rightclickmenu.app.finder-extension; PRODUCT_NAME = "$(TARGET_NAME)"; SKIP_INSTALL = YES; SWIFT_EMIT_LOC_STRINGS = YES; SWIFT_VERSION = 5.0; WRAPPER_EXTENSION = appex; }; name = Release; };
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
        A000500 /* Build configuration list for PBXProject "RightClickMenu" */ = {isa = XCConfigurationList; buildConfigurations = (A000501 /* Debug */, A000502 /* Release */, ); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; };
        A001500 /* Build configuration list for PBXNativeTarget "RightClickMenu" */ = {isa = XCConfigurationList; buildConfigurations = (A001501 /* Debug */, A001502 /* Release */, ); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; };
        A002500 /* Build configuration list for PBXNativeTarget "RightClickMenuExtension" */ = {isa = XCConfigurationList; buildConfigurations = (A002501 /* Debug */, A002502 /* Release */, ); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; };
/* End XCConfigurationList section */
    };
    rootObject = A000001 /* Project object */;
}
''',
    encoding="utf-8",
)

print(f"Generated {PBXPROJ.relative_to(ROOT)}")
