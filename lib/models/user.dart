class AppUser {
  final String uid;

  AppUser(this.uid);
}

class AppUserData {
  final String uid;
  final String name;
  final int waterCounter;
  final String password;
  final String passwordSign;
  final String playerUid;
  final String phone;
  final String token;
  final String ImageUrl;
  final bool DBiometrique;
  final bool CBiometrique;
  final bool autoBrightness;
  final bool isDark;
  final String primaryColor;
  final String langues;

  AppUserData(
      {required this.uid,
      required this.name,
      required this.waterCounter,
      required this.password,
      required this.passwordSign,
      required this.playerUid,
      required this.phone,
      required this.token,
      required this.ImageUrl,
      required this.DBiometrique,
      required this.CBiometrique,
      required this.autoBrightness,
      required this.isDark,
      required this.primaryColor,
      required this.langues});
}
