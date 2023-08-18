

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/wallet_model.dart';


class WalletNotifier extends StateNotifier<WalletModel> {
  WalletNotifier(): super(WalletModel(walletAddress: '', privateKey: ''));
  void setWallet(WalletModel wallet) => state = wallet;
}

final walletProvider = StateNotifierProvider<WalletNotifier, WalletModel>((ref) => WalletNotifier());