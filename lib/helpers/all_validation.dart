String? emailValidation(String? value) {
  // التحقق إذا كان الحقل فارغًا
  if (value == null || value.isEmpty) {
    return "البريد الإلكتروني مطلوب";
  }

  // نمط Regex أساسي للتحقق من بنية البريد الإلكتروني
  final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$",
  );

  // التحقق إذا كان الإدخال يطابق نمط البريد الإلكتروني
  if (!emailRegex.hasMatch(value)) {
    return "الرجاء إدخال بريد إلكتروني صالح";
  }

  // التحقق إذا كان البريد يبدأ أو ينتهي بأحرف غير صالحة
  if (value.startsWith('.') ||
      value.startsWith('@') ||
      value.endsWith('.') ||
      value.endsWith('@')) {
    return "البريد الإلكتروني لا يمكن أن يبدأ أو ينتهي بأحرف غير صالحة";
  }

  // التحقق من وجود أكثر من رمز '@'
  if (value.split('@').length - 1 != 1) {
    return "البريد الإلكتروني يحتوي على أكثر من رمز '@'";
  }

  // التحقق من وجود أحرف غير صالحة أو نقاط متتالية
  if (value.contains('..')) {
    return "البريد الإلكتروني يحتوي على نقاط متتالية";
  }

  // التحقق من قواعد النطاق (مثل طول TLD والأحرف الخاصة في النطاق)
  final List<String> emailParts = value.split('@');
  final String domain = emailParts.last;

  // التحقق إذا كان الجزء الخاص بالنطاق يحتوي على نقطة ويتبع قواعد TLD
  if (!domain.contains('.') || domain.split('.').last.length < 2) {
    return "النطاق في البريد الإلكتروني غير صالح";
  }

  // التحقق إذا كان النطاق يحتوي على أحرف غير صالحة (مثل الأحرف الخاصة)
  if (RegExp(r'[!#$%^&*(),?":{}|<>]').hasMatch(domain)) {
    return "النطاق يحتوي على أحرف غير صالحة";
  }

  // إذا اجتاز كل التحقق، إرجاع null (لا توجد أخطاء)
  return null;
}

String? passwordValidation(String? value) {
  // التحقق إذا كان الحقل فارغًا
  if (value == null || value.isEmpty) {
    return "كلمة المرور مطلوبة";
  }

  // التحقق من طول كلمة المرور (حد أدنى 8 أحرف)
  if (value.length < 8) {
    return "كلمة المرور يجب أن تكون على الأقل 8 أحرف";
  }

  // التحقق من وجود حرف كبير واحد على الأقل
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return "كلمة المرور يجب أن تحتوي على حرف كبير واحد على الأقل";
  }

  // التحقق من وجود حرف صغير واحد على الأقل
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return "كلمة المرور يجب أن تحتوي على حرف صغير واحد على الأقل";
  }

  // التحقق من وجود رقم واحد على الأقل
  if (!RegExp(r'\d').hasMatch(value)) {
    return "كلمة المرور يجب أن تحتوي على رقم واحد على الأقل";
  }

  // التحقق من وجود حرف خاص واحد على الأقل
  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
    return "كلمة المرور يجب أن تحتوي على حرف خاص واحد على الأقل";
  }

  // التحقق إذا كانت كلمة المرور تحتوي على مسافات
  if (value.contains(' ')) {
    return "كلمة المرور لا يجب أن تحتوي على مسافات";
  }

  // إذا اجتازت كل التحقق، إرجاع null (لا توجد أخطاء)
  return null;
}

String? confirmPasswordValidation(String? password, String? confirmPassword) {
  // التحقق إذا كان الحقل التأكيدي فارغًا
  if (confirmPassword == null || confirmPassword.isEmpty) {
    return "تأكيد كلمة المرور مطلوب";
  }

  // التحقق إذا كانت كلمتا المرور متطابقتين
  if (password != confirmPassword) {
    return "كلمتا المرور غير متطابقتين";
  }

  // إذا كانت كلمتا المرور متطابقتين، إرجاع null (لا توجد أخطاء)
  return null;
}
