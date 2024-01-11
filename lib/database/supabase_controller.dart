import 'package:audio_store/model/item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

final _supabase = Supabase.instance.client;

Future<bool> registerUser(
  String email,
  String password,
) async {
  try {
    await _supabase.auth.signUp(email: email, password: password);
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
    await _supabase.auth.signInWithPassword(email: email, password: password);
  } catch (e) {
    Logger().e(e);
    return false;
  }
  return true;
}

Future<bool> logoutUser() async {
  try {
    await _supabase.auth.signOut();
  } catch (e) {
    Logger().e(e);
    return false;
  }
  return true;
}

Future<List<Item?>?> getItems() async {
  try {
    final res = await _supabase.from('items').select();
    return res.map((json) => Item.fromJson(json)).toList();
  } catch (e) {
    Logger().e(e);
    return null;
  }
}

Future<Item?> getItem({
  required int id,
}) async {
  try {
    final res = await _supabase.from('items').select().eq('id', id).single();
    return Item.fromJson(res);
  } catch (e) {
    Logger().e(e);
    return null;
  }
}