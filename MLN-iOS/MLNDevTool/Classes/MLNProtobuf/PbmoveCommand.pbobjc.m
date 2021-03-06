// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: PBMoveCommand.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

#import "PbmoveCommand.pbobjc.h"
#import "PbbaseCommand.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - PbmoveCommandRoot

@implementation PbmoveCommandRoot

// No extensions in the file and none of the imports (direct or indirect)
// defined extensions, so no need to generate +extensionRegistry.

@end

#pragma mark - PbmoveCommandRoot_FileDescriptor

static GPBFileDescriptor *PbmoveCommandRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@""
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - pbmovecommand

@implementation pbmovecommand

@dynamic hasBasecommand, basecommand;
@dynamic oldFilePath;
@dynamic oldRelativeFilePath;
@dynamic newFilePath;
@dynamic newRelativeFilePath;

typedef struct pbmovecommand__storage_ {
  uint32_t _has_storage_[1];
  pbbasecommand *basecommand;
  NSString *oldFilePath;
  NSString *oldRelativeFilePath;
  NSString *newFilePath;
  NSString *newRelativeFilePath;
} pbmovecommand__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "basecommand",
        .dataTypeSpecific.className = GPBStringifySymbol(pbbasecommand),
        .number = pbmovecommand_FieldNumber_Basecommand,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(pbmovecommand__storage_, basecommand),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "oldFilePath",
        .dataTypeSpecific.className = NULL,
        .number = pbmovecommand_FieldNumber_OldFilePath,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(pbmovecommand__storage_, oldFilePath),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "oldRelativeFilePath",
        .dataTypeSpecific.className = NULL,
        .number = pbmovecommand_FieldNumber_OldRelativeFilePath,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(pbmovecommand__storage_, oldRelativeFilePath),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "newFilePath",
        .dataTypeSpecific.className = NULL,
        .number = pbmovecommand_FieldNumber_NewFilePath,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(pbmovecommand__storage_, newFilePath),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "newRelativeFilePath",
        .dataTypeSpecific.className = NULL,
        .number = pbmovecommand_FieldNumber_NewRelativeFilePath,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(pbmovecommand__storage_, newRelativeFilePath),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[pbmovecommand class]
                                     rootClass:[PbmoveCommandRoot class]
                                          file:PbmoveCommandRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(pbmovecommand__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\004\002\013\000\003\023\000\004\013\000\005\023\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
