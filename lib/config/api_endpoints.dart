class ApiEndpoints {
  static const String getRegisterOtp = 'Registration/RegisterCustomerPortal';
  static const String getResentOtpForRegisterOtpandUseName = 'ForgotUsername/ResendOTPForUserNameAndRegistration';
  static const String registeration = 'Registration/UpdateUsernamePassword';
  static const String getforgotPasswordOtp = 'ForgotPassword/ForgotPasswordSendOTP';
  static const String getresendforgotPasswordOtp = 'ForgotPassword/ResendOTPForForgetPassword';
  static const String forgotPasswordReset = 'ForgotPassword/ResetPassword';
  static const String login = 'User/CheckUserAuthentication';
  static const String logout = 'User/LogOut';
  static const String getCustomerAccounts = 'Home/GetCustomerAccounts';
  static const String getHome = 'Home/GetHome';
  static const String getSalesInvoiceList = 'SaleInvoice/GetSalesAndDOList';
  static const String getForgotUserNameOtp = 'ForgotUsername/ForgotUserNameSendOTP';
  static const String sendUserName = 'ForgotUsername/ValidateOTPAndGetUsername';
  static const String getProfile = 'CustomerProfile/GetProfile';
  static const String updateProfile = 'CustomerProfile/UpdateProfile';
  static const String getOutstandingList = 'Reports/ReportPortalCustomerSOA';
  static const String getSalesDetails = 'Transaction/GetSalesInvoiceEdit';
  static const String getCollectionDetails = 'Transaction/GetCollectionVoucherForEdit';
  static const String getCollections = 'Collection/GetCollectionList';
  static const String getBottleDetails = 'SaleInvoice/GetBottleDetails';
  static const String getDoDetails= 'Transaction/EditDeliveryOrder';
  static const String getMaterialList= 'CustomerProfile/GetMaterialsForCustomerProfile';
  static const String getCouponList= 'SaleInvoice/GetCouponDetails';
  static const String getNotificationUnseen= 'Notification/GetUnseenNotificationDetails';
  static const String updateProfilePicture= 'CustomerProfile/UpdateProfilePicture';
  static const String uploadImage= 'Document/FileUpload';
  static const String deleteImage= 'Document/FileDeletion';
  static const String notificationStatusUpdation= 'Notification/UpdateNotificationSeenStatus';
  static const String imageView= 'Document/FileView';





// Add more endpoints as needed
}
