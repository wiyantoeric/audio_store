import 'package:audio_store/model/cart_item.dart';
import 'package:audio_store/model/item.dart';
import 'package:audio_store/model/transaction.dart';
import 'package:audio_store/model/user_profile.dart';
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

Future<void> updateUserProfile(
    {required String uid, required UserProfile userProfile}) async {
  try {
    await _supabase.from('user').update({
      'uid': uid,
      'full_name': userProfile.fullName,
      'address': userProfile.address,
      'phone': userProfile.phone,
    }).eq('uid', uid);
  } catch (e) {
    Logger().e(e);
  }
}

Future<UserProfile?> getUserProfile({required String uid}) async {
  try {
    final res = await _supabase.from('user').select().eq('uid', uid).single();
    return UserProfile.fromJson(res);
  } catch (e) {
    Logger().e(e);
  }
  return null;
}

Future<void> insertTransaction({
  required String uid,
  required Transaction transaction,
}) async {
  try {
    await _supabase.from('transactions').insert([
      {
        'uid': uid,
        'item_ids': transaction.itemIds,
        'price': transaction.totalPrice,
        'qtys': transaction.qtys,
      }
    ]);
  } catch (e) {
    Logger().e(e);
  }
}

Future<List<CartItem?>?> getTransactions() async {
  try {
    final res = await _supabase.from('transactions').select();
    Logger().i(res);

    // return res.map((json) => Item.fromJson(json)).toList();
  } catch (e) {
    Logger().e(e);
  }
  return null;
}

// LEGACY: Cloud cart
// Future<List<CartItem?>?> getCartItems() async {
//   try {
//     final res = await _supabase
//         .from('cart')
//         .select()
//         .eq('uid', Supabase.instance.client.auth.currentUser!.id);
//     final cartItems = res.map((json) => CartItem.fromJson(json)).toList();
//     return cartItems;
//   } catch (e) {
//     Logger().e(e);
//     return null;
//   }
// }

Future<Item?> getCartItem({required int itemId}) async {
  try {
    final res = await _supabase.from('cart').select().eq('id', itemId).single();
    return Item.fromJson(res);
  } catch (e) {
    Logger().e(e);
    return null;
  }
}

// Future<void> insertCartItem({
//   required int itemId,
//   required int qty,
//   required double subtotal,
// }) async {
//   try {
//     await _supabase.from('cart').insert([
//       {
//         'item_id': itemId,
//         'qty': qty,
//         'subtotal': subtotal,
//         'uid': Supabase.instance.client.auth.currentUser!.id,
//       }
//     ]);
//   } catch (e) {
//     Logger().e(e);
//   }
// }

// Future<void> deleteCartItem({
//   required int id,
// }) async {
//   try {
//     await _supabase.from('cart').delete().eq('id', id);
//   } catch (e) {
//     Logger().e(e);
//   }
// }

// Future<void> updateCartItem({
//   required int id,
//   required int qty,
//   required double subtotal,
// }) async {
//   try {
//     await _supabase.from('cart').update({
//       'qty': qty,
//       'subtotal': subtotal,
//     }).eq('id', id);
//   } catch (e) {
//     Logger().e(e);
//   }
// }
