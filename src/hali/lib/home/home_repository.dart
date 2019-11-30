import 'dart:async';

class HomeRepository {  
  Future<void> loadAsync(String token) async {
    /// write from keystore/keychain
    await Future.delayed(new Duration(seconds: 2));
  }

  Future<void> saveAsync(String token) async {
    /// write from keystore/keychain
    await Future.delayed(new Duration(seconds: 2));
  }
}
