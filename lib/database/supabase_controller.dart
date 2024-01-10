import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

Future<bool> registerUser(
  String email,
  String password,
) async {
  try {
    await Supabase.instance.client.auth
        .signUp(email: email, password: password);
  } catch (e) {
    Logger().e(e);
    return false;
  }
  return true;
}

Future<bool> loginUser(
  String email,
  String password,
) async {
  try {
    await Supabase.instance.client.auth
        .signInWithPassword(email: email, password: password);
  } catch (e) {
    Logger().e(e);
    return false;
  }
  return true;
}

Future<bool> logoutUser() async {
  try {
    await Supabase.instance.client.auth.signOut();
  } catch (e) {
    Logger().e(e);
    return false;
  }
  return true;
}
