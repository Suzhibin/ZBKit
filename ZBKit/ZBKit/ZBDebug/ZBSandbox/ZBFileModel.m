//
//  ZBFileModel.m
//  ZBKit
//
//  Created by NQ UEC on 2018/4/24.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "ZBFileModel.h"
#import "ZBMacros.h"
#import <UIKit/UIKit.h>
static const CGFloat u = 1000.0;
@interface ZBFileModel ()

@property (nonatomic ,strong) dispatch_queue_t fileOperationQueue;
@end
@implementation ZBFileModel

- (instancetype)initWithFileURL:(NSURL *)URL {
    if (self = [super init]) {
        
       _fileOperationQueue = dispatch_queue_create("com.dispatch.ZBFileModel", DISPATCH_QUEUE_SERIAL);
  
        self.URL = URL;
        NSLog(@"lastPathComponent:%@",URL.lastPathComponent);
        self.fileName = URL.lastPathComponent;
        self.attributes = [self attributesWithFileURL:URL];
     
        if ([self.attributes.fileType isEqualToString:NSFileTypeDirectory]) {
            self.type = ZBFileTypeDirectory;
            self.filesCount = [self getFileCountWithpath:URL.path];
            //liman
            if ([URL isFileURL]) {
                NSDictionary *info = [[NSFileManager defaultManager] attributesOfItemAtPath:URL.path error:nil];
                NSDate *current = [info objectForKey:NSFileModificationDate];
                float fileSize= [self getFileSizeWithpath:URL.path];
                self.modificationDateText = [NSString stringWithFormat:@"[%@] %@",  [[self fileModificationDateFormatter] stringFromDate:current], [self fileUnitWithSize:fileSize]];
            }
            ZBKLog(@"文件夹");
        } else {
               ZBKLog(@"文件");
            self.extension = URL.pathExtension;
            self.type = [self fileTypeWithExtension:self.extension];
            self.filesCount = 0;
            //liman
            if ([URL isFileURL]) {
                NSDictionary *info = [[NSFileManager defaultManager] attributesOfItemAtPath:URL.path error:nil];
                NSDate *current = [info objectForKey:NSFileModificationDate];
                CGFloat fileSize= [self getFileSizeWithpath:URL.path];
                self.modificationDateText = [NSString stringWithFormat:@"[%@] %@", [[self fileModificationDateFormatter] stringFromDate:current],[self fileUnitWithSize:fileSize]];
            }
        }
        
        //liman
//        if ([self.modificationDateText containsString:@"[] "]) {
//            self.modificationDateText = [[self.modificationDateText mutableCopy] stringByReplacingOccurrencesOfString:@"[] " withString:@""];
//        }
    }
    
    return self;
}
- (NSString *)fileUnitWithSize:(float)size{

    if (size >= u * u * u) { // >= 1GB
        return [NSString stringWithFormat:@"%.2fGB", size / u / u / u];
    } else if (size >= u * u) { // >= 1MB
        return [NSString stringWithFormat:@"%.2fMB", size / u / u];
    } else { // >= 1KB
        return [NSString stringWithFormat:@"%.2fKB", size / u];
    }
}
- (NSDateFormatter *)fileModificationDateFormatter {
    static NSDateFormatter *_fileModificationDateFormatter;
    if (!_fileModificationDateFormatter) {
        _fileModificationDateFormatter = [[NSDateFormatter alloc] init];
        _fileModificationDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    
    return _fileModificationDateFormatter;
}
- (NSUInteger)getFileSizeWithpath:(NSString *)path{
    __block NSUInteger size = 0;
    //sync
    dispatch_sync(self.fileOperationQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    
    return size;
}
- (NSUInteger)getFileCountWithpath:(NSString *)path{
    __block NSUInteger count = 0;
    //sync
    dispatch_sync(self.fileOperationQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
        count = [[fileEnumerator allObjects] count];
    });
    return count;
}
- (NSDictionary *)attributesWithFileURL:(NSURL *)URL{
    NSError *error;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:URL.path error:&error];
    return attributes;
}
- (NSString *)typeImageName {
    if (!_typeImageName) {
        //        NSString *fileExtension = [self.URL pathExtension];
        //        NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtension, NULL);
        //        NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
        //        NSLog(@"%@, UTI = %@, contentType = %@", self.URL.lastPathComponent, UTI, contentType);
        
        switch (self.type) {
            case ZBFileTypeUnknown: _typeImageName = @"icon_file_type_default"; break;
            case ZBFileTypeRegular: _typeImageName = @"icon_file_type_default"; break;
            case ZBFileTypeDirectory: _typeImageName = self.filesCount == 0 ? @"icon_file_type_folder_empty" : @"icon_file_type_folder_not_empty"; break;
                // Image
            case ZBFileTypeJPG: _typeImageName = @"icon_file_type_jpg"; break;
            case ZBFileTypePNG: _typeImageName = @"icon_file_type_png"; break;
            case ZBFileTypeGIF: _typeImageName = @"icon_file_type_gif"; break;
            case ZBFileTypeSVG: _typeImageName = @"icon_file_type_svg"; break;
            case ZBFileTypeBMP: _typeImageName = @"icon_file_type_bmp"; break;
            case ZBFileTypeTIF: _typeImageName = @"icon_file_type_tif"; break;
                // Audio
            case ZBFileTypeMP3: _typeImageName = @"icon_file_type_mp3"; break;
            case ZBFileTypeAAC: _typeImageName = @"icon_file_type_aac"; break;
            case ZBFileTypeWAV: _typeImageName = @"icon_file_type_wav"; break;
            case ZBFileTypeOGG: _typeImageName = @"icon_file_type_ogg"; break;
                // Video
            case ZBFileTypeMP4: _typeImageName = @"icon_file_type_mp4"; break;
            case ZBFileTypeAVI: _typeImageName = @"icon_file_type_avi"; break;
            case ZBFileTypeFLV: _typeImageName = @"icon_file_type_flv"; break;
            case ZBFileTypeMIDI: _typeImageName = @"icon_file_type_midi"; break;
            case ZBFileTypeMOV: _typeImageName = @"icon_file_type_mov"; break;
            case ZBFileTypeMPG: _typeImageName = @"icon_file_type_mpg"; break;
            case ZBFileTypeWMV: _typeImageName = @"icon_file_type_wmv"; break;
                // Apple
            case ZBFileTypeDMG: _typeImageName = @"icon_file_type_dmg"; break;
            case ZBFileTypeIPA: _typeImageName = @"icon_file_type_ipa"; break;
            case ZBFileTypeNumbers: _typeImageName = @"icon_file_type_numbers"; break;
            case ZBFileTypePages: _typeImageName = @"icon_file_type_pages"; break;
            case ZBFileTypeKeynote: _typeImageName = @"icon_file_type_keynote"; break;
                // Google
            case ZBFileTypeAPK: _typeImageName = @"icon_file_type_apk"; break;
                // Microsoft
            case ZBFileTypeWord: _typeImageName = @"icon_file_type_doc"; break;
            case ZBFileTypeExcel: _typeImageName = @"icon_file_type_xls"; break;
            case ZBFileTypePPT: _typeImageName = @"icon_file_type_ppt"; break;
            case ZBFileTypeEXE: _typeImageName = @"icon_file_type_exe"; break;
            case ZBFileTypeDLL: _typeImageName = @"icon_file_type_dll"; break;
                // Document
            case ZBFileTypeTXT: _typeImageName = @"icon_file_type_txt"; break;
            case ZBFileTypeRTF: _typeImageName = @"icon_file_type_rtf"; break;
            case ZBFileTypePDF: _typeImageName = @"icon_file_type_pdf"; break;
            case ZBFileTypeZIP: _typeImageName = @"icon_file_type_zip"; break;
            case ZBFileType7z: _typeImageName = @"icon_file_type_7z"; break;
            case ZBFileTypeCVS: _typeImageName = @"icon_file_type_cvs"; break;
            case ZBFileTypeMD: _typeImageName = @"icon_file_type_md"; break;
                // Programming
            case ZBFileTypeSwift: _typeImageName = @"icon_file_type_swift"; break;
            case ZBFileTypeJava: _typeImageName = @"icon_file_type_java"; break;
            case ZBFileTypeC: _typeImageName = @"icon_file_type_c"; break;
            case ZBFileTypeCPP: _typeImageName = @"icon_file_type_cpp"; break;
            case ZBFileTypePHP: _typeImageName = @"icon_file_type_php"; break;
            case ZBFileTypeJSON: _typeImageName = @"icon_file_type_json"; break;
            case ZBFileTypePList: _typeImageName = @"icon_file_type_plist"; break;
            case ZBFileTypeXML: _typeImageName = @"icon_file_type_xml"; break;
            case ZBFileTypeDatabase: _typeImageName = @"icon_file_type_db"; break;
            case ZBFileTypeJS: _typeImageName = @"icon_file_type_js"; break;
            case ZBFileTypeHTML: _typeImageName = @"icon_file_type_html"; break;
            case ZBFileTypeCSS: _typeImageName = @"icon_file_type_css"; break;
            case ZBFileTypeBIN: _typeImageName = @"icon_file_type_bin"; break;
            case ZBFileTypeDat: _typeImageName = @"icon_file_type_dat"; break;
            case ZBFileTypeSQL: _typeImageName = @"icon_file_type_sql"; break;
            case ZBFileTypeJAR: _typeImageName = @"icon_file_type_jar"; break;
                // Adobe
            case ZBFileTypeFlash: _typeImageName = @"icon_file_type_fla"; break;
            case ZBFileTypePSD: _typeImageName = @"icon_file_type_psd"; break;
            case ZBFileTypeEPS: _typeImageName = @"icon_file_type_eps"; break;
                // Other
            case ZBFileTypeTTF: _typeImageName = @"icon_file_type_ttf"; break;
            case ZBFileTypeTorrent: _typeImageName = @"icon_file_type_torrent"; break;
        }
    }
    
    return _typeImageName;
}
- (ZBFileType)fileTypeWithExtension:(NSString *)extension {
    ZBFileType type = ZBFileTypeUnknown;
    
    if ((nil == extension || (NSNull *)extension == [NSNull null])) {
        return type;
    }
    if([@"" isEqualToString:extension]){
        type = ZBFileTypeRegular;
    }
    // Image
    else if ([extension compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeJPG;
    } else if ([extension compare:@"png" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypePNG;
    } else if ([extension compare:@"gif" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeGIF;
    } else if ([extension compare:@"svg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeSVG;
    } else if ([extension compare:@"bmp" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeBMP;
    } else if ([extension compare:@"tif" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeTIF;
    }
    // Audio
    else if ([extension compare:@"mp3" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeMP3;
    } else if ([extension compare:@"aac" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeAAC;
    } else if ([extension compare:@"wav" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeWAV;
    } else if ([extension compare:@"ogg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeOGG;
    }
    // Video
    else if ([extension compare:@"mp4" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeMP4;
    } else if ([extension compare:@"avi" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeAVI;
    } else if ([extension compare:@"flv" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeFLV;
    } else if ([extension compare:@"midi" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeMIDI;
    } else if ([extension compare:@"mov" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeMOV;
    } else if ([extension compare:@"mpg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeMPG;
    } else if ([extension compare:@"wmv" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeWMV;
    }
    // Apple
    else if ([extension compare:@"dmg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeDMG;
    } else if ([extension compare:@"ipa" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeIPA;
    } else if ([extension compare:@"numbers" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeNumbers;
    } else if ([extension compare:@"pages" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypePages;
    } else if ([extension compare:@"key" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeKeynote;
    }
    // Google
    else if ([extension compare:@"apk" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeAPK;
    }
    // Microsoft
    else if ([extension compare:@"doc" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
             [extension compare:@"docx" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeWord;
    } else if ([extension compare:@"xls" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
               [extension compare:@"xlsx" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeExcel;
    } else if ([extension compare:@"ppt" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
               [extension compare:@"pptx" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypePPT;
    } else if ([extension compare:@"exe" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeEXE;
    } else if ([extension compare:@"dll" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeDLL;
    }
    // Document
    else if ([extension compare:@"txt" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeTXT;
    } else if ([extension compare:@"rtf" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeRTF;
    } else if ([extension compare:@"pdf" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypePDF;
    } else if ([extension compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeZIP;
    } else if ([extension compare:@"7z" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileType7z;
    } else if ([extension compare:@"cvs" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeCVS;
    } else if ([extension compare:@"md" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeMD;
    }
    // Programming
    else if ([extension compare:@"swift" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeSwift;
    } else if ([extension compare:@"java" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeJava;
    } else if ([extension compare:@"c" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeC;
    } else if ([extension compare:@"cpp" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeCPP;
    } else if ([extension compare:@"php" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypePHP;
    } else if ([extension compare:@"json" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeJSON;
    } else if ([extension compare:@"plist" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypePList;
    } else if ([extension compare:@"xml" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeXML;
    } else if ([extension compare:@"db" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeDatabase;
    } else if ([extension compare:@"js" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeJS;
    } else if ([extension compare:@"html" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeHTML;
    } else if ([extension compare:@"css" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeCSS;
    } else if ([extension compare:@"bin" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeBIN;
    } else if ([extension compare:@"dat" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeDat;
    } else if ([extension compare:@"sql" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeSQL;
    } else if ([extension compare:@"jar" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeJAR;
    }
    // Adobe
    else if ([extension compare:@"psd" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypePSD;
    }
    else if ([extension compare:@"eps" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeEPS;
    }
    // Other
    else if ([extension compare:@"ttf" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeTTF;
    } else if ([extension compare:@"torrent" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZBFileTypeTorrent;
    }
    
    return type;
}

- (BOOL)isCanPreviewInWebView {
    if (// Image
        self.type == ZBFileTypePNG ||
        self.type == ZBFileTypeJPG ||
        self.type == ZBFileTypeGIF ||
        self.type == ZBFileTypeSVG ||
        self.type == ZBFileTypeBMP ||
        // Audio
        self.type == ZBFileTypeWAV ||
        // Apple
        self.type == ZBFileTypeNumbers ||
        self.type == ZBFileTypePages ||
        self.type == ZBFileTypeKeynote ||
        // Microsoft
        self.type == ZBFileTypeWord ||
        self.type == ZBFileTypeExcel ||
        // Document
        self.type == ZBFileTypeTXT || // 编码问题
        self.type == ZBFileTypePDF ||
        self.type == ZBFileTypeMD ||
        // Programming
        self.type == ZBFileTypeJava ||
        self.type == ZBFileTypeSwift ||
        self.type == ZBFileTypeCSS ||
        // Adobe
        self.type == ZBFileTypePSD) {
        return YES;
    }
    
    return NO;
}

@end
