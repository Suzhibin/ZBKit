//
//  ZBFileModel.h
//  ZBKit
//
//  Created by NQ UEC on 2018/4/24.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, ZBFileType) {
    ZBFileTypeUnknown,
    ZBFileTypeRegular,
    ZBFileTypeDirectory,
    // Image
    ZBFileTypeJPG, ZBFileTypePNG, ZBFileTypeGIF, ZBFileTypeSVG, ZBFileTypeBMP, ZBFileTypeTIF,
    // Audio
    ZBFileTypeMP3, ZBFileTypeAAC, ZBFileTypeWAV, ZBFileTypeOGG,
    // Video
    ZBFileTypeMP4, ZBFileTypeAVI, ZBFileTypeFLV, ZBFileTypeMIDI, ZBFileTypeMOV, ZBFileTypeMPG, ZBFileTypeWMV,
    // Apple
    ZBFileTypeDMG, ZBFileTypeIPA, ZBFileTypeNumbers, ZBFileTypePages, ZBFileTypeKeynote,
    // Google
    ZBFileTypeAPK,
    // Microsoft
    ZBFileTypeWord, ZBFileTypeExcel, ZBFileTypePPT, ZBFileTypeEXE, ZBFileTypeDLL,
    // Document
    ZBFileTypeTXT, ZBFileTypeRTF, ZBFileTypePDF, ZBFileTypeZIP, ZBFileType7z, ZBFileTypeCVS, ZBFileTypeMD,
    // Programming
    ZBFileTypeSwift, ZBFileTypeJava, ZBFileTypeC, ZBFileTypeCPP, ZBFileTypePHP,
    ZBFileTypeJSON, ZBFileTypePList, ZBFileTypeXML, ZBFileTypeDatabase,
    ZBFileTypeJS, ZBFileTypeHTML, ZBFileTypeCSS,
    ZBFileTypeBIN, ZBFileTypeDat, ZBFileTypeSQL, ZBFileTypeJAR,
    // Adobe
    ZBFileTypeFlash, ZBFileTypePSD, ZBFileTypeEPS,
    // Other
    ZBFileTypeTTF, ZBFileTypeTorrent,
};@interface ZBFileModel : NSObject

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, strong) NSString *modificationDateText;
@property (nonatomic, copy) NSString *typeImageName;
@property (nonatomic, strong) NSString *extension;
@property (nonatomic, assign) NSUInteger filesCount; // File always 0

@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, assign) ZBFileType type;

- (instancetype)initWithFileURL:(NSURL *)URL;

- (BOOL)isCanPreviewInWebView;
@end
