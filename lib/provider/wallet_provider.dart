

import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletNotifier extends StateNotifier<String> {
  WalletNotifier(): super("");
  void setWalletAddress(String wallet) => state = wallet;
}

final walletProvider = StateNotifierProvider<WalletNotifier, String>((ref) => WalletNotifier());