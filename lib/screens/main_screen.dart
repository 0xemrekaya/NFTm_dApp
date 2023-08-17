import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import '../provider/wallet_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  MainScreen({super.key});
  static String id = "Main Screen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final String title = "Create a Web3 Wallet for App.";

  final rpcUrl = dotenv.env['SEPOLIA_RPC_URL'];
  late Client httpClient;
  late Web3Client ethClient;
  String? walletAddress;

  @override
  void initState() {
    super.initState();
    _initWeb3();
  }

  Future<void> _initWeb3() async {
    httpClient = Client();
    ethClient = Web3Client(
      rpcUrl.toString(),
      httpClient,
    );
  }

  void generateWallet() {
    final wallet = EthPrivateKey.createRandom(Random.secure());
    final a = HEX.encode(wallet.privateKey);
    ref.watch(walletProvider.notifier).setWalletAddress(wallet.address.hex.toString());
    walletAddress = wallet.address.hex.toString();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Text(
              title,
              style: textStyle,
            ),
          ),
          Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    generateWallet();
                  },
                  child: const Text("Generate a wallet")),
              const SizedBox(
                height: 20,
              ),
              Text(
                ref.watch(walletProvider) ?? "",
                style: textStyle.copyWith(fontSize: 15),
              )
            ],
          ),
        ],
      ),
    );
  }
}
