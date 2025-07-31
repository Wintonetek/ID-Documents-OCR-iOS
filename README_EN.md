# # ID-Documents-OCR-iOS
# Identification of identification documents, including second-generation certificates, home visit permits, Hong Kong and Macau travel permits, passport recognition, and NFC data reading for various types of documents.
# For specific information on the integration of the ID recognition SDK, please contact us.
# You can also refer to the attached example demo to learn the usage of this SDK through code.
# 
# # Explanation of Main Document Types
# Document Name Document MAINID (in decimal)
# First-generation ID Card (Not currently supported) 1
# Front of Second-generation ID Card 2
# Back of Second-generation ID Card 3
# Temporary ID Card 4
# Driver's License 5
# Vehicle License 6
# Military Officer's ID 7
# Soldier's ID (Not currently supported) 8
# Machine-readable Documents Passport Page Mainland Travel Permit for Hong Kong and Macao Residents 9
# Taiwan Resident Travel Permit to the Mainland 10
# Mainland Resident Travel Permit to Taiwan 11
# Visa 12
# Passport 13
# Card Page Front of Mainland Travel Permit for Hong Kong and Macao Residents 14
# Back of Mainland Travel Permit for Hong Kong and Macao Residents 15
# Household Register 16
# New Version of Hong Kong and Macao Permit 22
# Exit-Entry Permit for Border Areas 23
# Front of New Version of Taiwan Resident Travel Permit to the Mainland 25
# Back of New Version of Taiwan Resident Travel Permit to the Mainland 26
# Supplementary Page of Motor Vehicle Driver's License 28
# Photo Page of 2017 Version of Travel Permit to Taiwan 29
# Supplementary Page of Motor Vehicle License 30
# Photo Page of Residence Permit for Hong Kong, Macao, and Taiwan Residents 31
# Issuing Authority Page of Residence Permit for Hong Kong, Macao, and Taiwan Residents 32
# Photo Page of 2017 Version of Foreigner's Permanent Residence ID Card 33
# Electronic Driver's License 34
# Electronic Vehicle License 35
# Supplementary Page of Electronic Driver's License 36
# Supplementary Page of Electronic Vehicle License 37
# Residence Permit 1000
# 2003 Version of Hong Kong Permanent Identity Card 1001(1)
# 2018 Version of Hong Kong Identity Card 1001(2)
# Boarding Pass (Currently not supported by the camera device) (Not currently supported) 1002
# Border Resident Permit (A) (Photo Page) (Not currently supported) 1003
# Border Resident Permit (B) (Personal Information Page) (Not currently supported) 1004
# Macao Identity Card 1005
# Collection Voucher (Supported by scanners) (Not currently supported) 1006
# Lawyer's License (A) (Information Page) 1007
# Lawyer's License (B) (Photo Page) 1008
# IC Card of Road Transport Certificate of the People's Republic of China (Not currently supported) 1009
# New Version of Macao Identity Card (Not currently supported) 1012
# New Version of Shenzhen Residence Permit 1013
# Macao Blue Card 1014
# Hong Kong Entry Slip 1015
# Machine-readable Code of Passport (Not currently supported) 1020
# Beijing Social Security Card 1021
# National Health Insurance Card 1030
# Front of Taiwan Identity Card 1031
# Back of Taiwan Identity Card 1032
# MRZ3*30 (Not currently supported) 1033
# MRZ2*44 (Not currently supported) 1034
# MRZ2*36 (Not currently supported) 1036
# Xiamen Social Security Card 1039
# Photo Page of Fujian Social Security Card 1041
# Malaysian Identity Card 2001
# California Driver's License 2002
# New Zealand Driver's License 2003
# Singapore Identity Card 2004
# ID2 (MRZ2*36) TD-2 Type Machine-readable Code 2006
# ID1 (MRZ3*30) (Not currently supported) 2007
# ID3 (MRZ2*44) (Not currently supported) 2008
# TD-1 Type Machine-readable Code 2009
# Indonesian Resident Identity Card - KEPT 2010(1)
# Indonesian Resident Identity Card - KPT 2010(2)
# Front of Thai Identity Card 2011
# Thai Driver's License 2012(1)
# Thai Driver's License - Private Car 2012(2)
# Mexican Voter ID AB 2013(1)
# Mexican Voter ID C 2013(2)
# Mexican Voter ID DE 2013(3)
# Back of Mexican Voter ID ABC 2014
# Back of Thai Identity Card 2016
# Swedish Driver's License 2020
# Malaysian Driver's License 2021
# Philippine Identity Card 2022
# Singapore Driver's License 2031
# Indonesian Driver's License 2041
# Japanese Driver's License 2051
# 
# 2 2.Interface Introduction
# For the following interfaces, please refer to the demo program. 
# 
# 2.1-(int)InitIDCardWithDevcode:(NSString *)devcode recogLanguage:(int) recogLanguage; 
# /*
# Core initialization: before calling other methods, please make sure to call this method, otherwise, all other functions will fail!
# devcode: development code
# recogLanguage: the recognition language, “0”- Chinese character, the recognition result is in Chinese; “3”- English character, the recognition result is in English
# Return Value: “0” means success, others mean fail; with this return value, we can judge whether the license and initialization are succeed or not!
# */
# The following chart states return value and related description:
# Return Value    Description
# 0    Core initialization succeed;
# -10012    Devcode is lacked, pls refer to 2.1
# -10600    License file is lacked, pls refer to 1.4.2
# -10601    Devcode is wrong, pls refer to 1.4.1 & 2.1
# -10602    The
# -10603    License expired;
# -10604    Core version error
# -10605    “Bundle display name” in the plist is inconsistent with what in the license file, pls refer to 1.4.3 & 1.4.4
# -10606    “CompanyName” in the plist in inconsistent with what in the license file, pls refer to 1.4.3 & 1.4.4
# -10090    License expired, but within 30 days.
# -10609    SDK version error.
# 
# 2.2-(void)setParameterWithMode:(int)nMode CardType:(int)nType;
# /*
# Set the recognition mode and document type
# Parameter: 
# nMode: “0”- capture image and recognition, import image and recognition; 1- video stream recognition
# nType: document type
# */
# 
# 2.3- (void)setPictureClearValueEx:(int)nValue;
# /*
# Set up the threshold for judging image clarity, the default value is 80;
# Parameter: nValue: 0-255
# */
# 
# 2.4- (void)setVideoStreamCropTypeExWithType:(int)nType;
# /*
# Set up the method to detect lines, otherwise default detecting method will be applied.
# Parameters: nType: “0”- guide frame; “1”- automatic line detection
# */
# 
# 2.5- (int) setROIWithLeft: (int)nLeft Top: (int)nTop Right: (int)nRight Bottom: (int)nBottom;
# /*
# Set up the region of interest
# Parameter: the distance of document image to the guide frame (top, bottom, left, right), detailed info please refer to Demo. 
# Return Value: “0”- succeed; others- failed
# */
# 
# 2.6-(int) SetDetectIDCardType:(int) nType;
# /*
# Set up the recognition type of Chinese second generation ID card
# Parameter: nType: “0” – both sides; “1” – obverse side; “2” – reverse side
# Return Value: “0”- succeed; others – failed
# */
# 
# 2.7- (int)setRecogRotateType:(int)nRotateType;
# /*
# Parameter: nRotateType: clockwise rotate; “0” – no rotate; “1” - 90 degree; “2” – 180 degree; “3” – 270 degree; 
# Return Value: “0” – Succeed, other – Failed
# */
# 
# 2.8- (int) newLoadImageWithBuffer:(UInt8 *)buffer Width:(int)width Height:(int)height;
# /*
# Import image data to the memory
# Parameter: image data and image width & height
# Return Value: “0” – Succeed; others – failed
# */
# 
# 2.9- (IDCardSlideLine *) newConfirmSlideLine;
# /*
# Detect slide lines
# Return Value: SlideLine object, after succeed, the attribute “allLine” is the code for document type
# */
# 
# 2.10- (NSDictionary *)obtainRealTimeFourConersID;
# /*
# After detecting the four sidelines, obtain related four points
# Return Value: NSDictionary object
# {
#  key:value
#  @"isSucceed":,NSNumber object
#  @"point1":CGPoint,
#  @"point2":CGPoint,
#  @"point3":CGPoint,
#  @"point4":CGPoint
#  }
# isSucceed: NSNumber object, “1” – succeed; “-1” – failed
# Connect point1, point2, point3 & point4, draw the frame in anticlockwise direction
# */
# 
# 2.11- (int)detectLightspot;
# /*
# Detect light spot
# Return Value:
# 0: there are light spots in the sensitive region;
# -1: core initialization failed;
# -2: there is no light spot in the sensitive region;
# -3: loading image data failed.
# */
# 
# 2.12- (int) newCheckPicIsClear;
# /*
# Detect image clarity
# Return Value: “0” – Succeed; others – failed
# */
# 
# 2.13- (int)setIDCardRejectType:(int)nCartType isSet:(bool)isSet;
# /*
# Rejecting interface
# Parameter: nCartType – document type; “isSet-YES” to set the rejecting type, “No” – default value
# Return Value: no meaning
# */
# 
# 2.14- (int) GetAcquireMRZSignal:(UInt8 *)buffer Width:(int)width Height:(int)height Left:(int)left Right:(int)right Top:(int)top Bottom:(int)bottom RotateType:(int)rotatetype;
# /*
# Acquire MRZ type
# Parameter: image data, image width, height and region of interested
# Return Value: “1” means 1034, “2” means 1036, “3” means 1033, in other words two & three lines MRZ
# */
# 
# 2.15- (int) loadMRZImageWithBuffer:(UInt8 *)buffer Width:(int)width Height:(int)height;
# /*
# Load MRZ
# Parameter: image data and image width, height
# Return Value: “0” – Succeed; others – failed
# */
# 
# 2.16-(int)LoadImageToMemoryWithFileName:(NSString *)lpImageFileName Type:(int)type;
# /*
# Load image path
# Parameter: lpImageFileName: image path; “type” please upload “0”
# Return Value: “0” – Succeed, others – failed, “3” – no image 
# */
# 
# 2.17- (void)processImageWithProcessType:(int)nProcessType setType:(int)nSetType;
# /*
# Image pre-process interface
# Parameter: nProcessType: “0” – cancel all the operation, “1” – cutting, “2” – rotating, “3” – cutting + rotating, “4” – tilt correction, “5”- cutting + tilt correction, “6” – tilt correction + rotating, “7”- cutting + tilt correction + rotating
# nSetType: “0” – cancel operation, “1” – set up operation
# */
# 
# 2.18- (int) saveImage:(NSString *)path
# /*
# Save the cutting image
# Parameter: path: the path to save image
# Return Value: “0” – Succeed; other – failed
# */
# 2.19- (int) saveHeaderImage: (NSString *)path;
# /*
# Save the head image
# Parameter: path: the path to save image
# Return Value: “0” – Succeed, others – failed
# */
# 
# 2.20- (int) autoRecogChineseID;
# /*
# Automatically recognize both side of Chinese 2 generation ID card, call when needed
# Return Value: document type code
# */
# 
# 2.21- (int) recogIDCardWithMainID: (int) nMainID;
# /*
# Recognize document 
# Parameter: nMainID: document type code
# Return Value: document type code
# */
# 2.22-(NSString *)GetFieldNameWithIndex:(int) nIndex;
# /*SacnGetFieldName*/
# 2.23-(NSString *)GetRecogResultWithIndex:(int) nIndex;
#  /*ScanGetFieldName*/
# 
# 2.24-(NSString *)GetFieldNameWithIndex:(int) nIndex nMain:(int)nMain;
#    /*Import recognition GetFieldName*/
# 2.25-(NSString *)GetRecogResultWithIndex:(int) nIndex nMain:(int)nMain;
#     /*Import recognitionGetFieldName*/
# 2.26-(void)recogFree;
#    /*ReleaseCore*/
# 
# 2.27 - (void)setIDCardIDWithMainID:(int)nMainID subID:(int)nSubID subIDCount:(int)nSubIDCount; 
# /*
#  Set up recognition template
#  Parameter:  nMainID: document type code; nSubID: the default value is “0”; nSubIDCount: the default value is “1”;
#  */
# 
# 2.28- (void)addIDCardIDWithMainID:(int)nMainID subID:(int)nSubID subIDCount:(int)nSubIDCount; 
# /*
#  Add recognition template
#  Parameter:  nMainID: document type code; nSubID: the default value is “0”; nsubIDCount: the default value is “1”.
#  */
# 
# 3. NFC reading and PKD verification
# Please refer to the Demo program in the SDK for calling the following interfaces!!  
# 3.1 -(int)InitIDCardWithDevcode:(NSString *)devcode;  
# /*
# Initialize the core, before calling other methods, this method must be called, otherwise other function calls are invalid!
# Devcode: development code
# Return value: 0 success, other values indicate failure; Determine whether authorization and core initialization are successful based on the return value of this method!
# */
# The following table returns the values and corresponding descriptions for this.  
# Return Value Return Value Description
# 0 core initialization;
# -10012 core initialization method did not pass in development code; Reference 2.1
# -10600 authorization file not found; Refer to 1.4.2
# -10601 The development code passed in the core initialization method is incorrect; Refer to 1.4.1 and 2.1
# -The value of the Bundle identifier bound to the authorization file in the 10602 project plist file is inconsistent; Refer to 1.4.3 and 1.4.4
# -10603 authorization expired;  
# -10604 core version number error
# -The Bundle display name in the plist file of 10605 project does not match the value bound to the authorization file; Refer to 1.4.3 and 1.4.4
# -The value bound between Company Name and authorization file in the plist file of 10606 project is inconsistent; Refer to 1.4.3 and 1.4.4
# -10090 authorization expires, but within 30 days;  
# -10609 SDK version number error;
# -10704 Unauthorized NFC
# /**
# NFC scanning passport interface, requires cooperation with scanning recognition to obtain three elements
# CardType: ID card
# PassportNumber: Passport number
# DateOfBirth: Date of Birth
# DateOfExpiry: Valid until
# PassportDetailBlock: Return information, including passportDict: Passport information (the NFC content in the internationalization file is the key of the dictionary) groupId: The groupId contained in the passport tag read by NFC scanning.
# MatchDict: Does the hash value of each dg match the hash value in the SOD
# SodDict: the base64 value of sod
# */
# 3.2 - (void)NFCScanPassportWithCardType:(int)cardType passportNumber:(NSString*)passportNumber dateOfBirth:(NSString*)dateOfBirth dateOfExpiry:(NSString*)dateOfExpiry passportDetail:(passportDetailBlock)passportDetailBlock;
# Note 2:
# //NFC
# 'Issuing country code'='Issuing country code';
# English name "=" English name ";
# Passport number "=" Passport number ";
# Date of birth "=" date of birth ";
# Date of expiry "=" Valid until ";
# Nationality code "=" holder's nationality code ";
# National name "=" National name ";
# Sex "=" Gender ";
# Place of birth "=" place of birth ";
# Place of issue "=" place of issuance ";
# Date of issue "=" Issuance date ";
# 'Issuing organization'='Issuing authority';
# //Homecoming Permit, Taiwan Compatriot Permit
# Card number "=" ID number ";
# Valid until "=" Valid until ";
# Chinese name "=" Chinese name ";
# Number "=" Number of certificate replacements ";
# Number of issues "=" Number of issuances ";
# The above are both international content and key values for passportDict (a dictionary that identifies passport information returned by the interface)
# 
# PKD authentication (chip information authentication)
# The authentication process consists of three parts: verifying the hash values of each DG with the hash values in SOD (i.e. matchDict), verifying the signature of SOD credentials, and authenticating/querying public key directory certificates.
# (1) Determine whether the matchDict returned by NFC reading information contains mismatched hash values. If it does, it is directly judged as authentication failure. If all hash values match, server authentication is performed.
# (2) Upload the base64 value of SOD in sodDict to the server for verification.
# 3.2 Server Verification Instructions
# Interface: https://netocr.com/validatePassport/sodVerifierBase64
# Request method: POST
# Request parameter: fileBase64 (the base64 value of SOD)
# 
# The specific integration process and identification information can be obtained by contacting us for the development manual and testing authorization.
# 
# Contact Us：
# Email: lijj@sinosecu.com.cn  &  zhangss@sinosecu.com.cn
# WhatsApp:+86 17310630901
