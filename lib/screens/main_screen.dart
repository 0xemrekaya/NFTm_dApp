import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart';
import 'package:nftm_dapp/provider/wallet_provider.dart';
import 'package:web3dart/web3dart.dart';

import '../model/wallet_model.dart';
import 'nft_main_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  MainScreen({super.key});
  static String id = "Main Screen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final String title = "You don't have a wallet yet.";
  final String subtitle = "Create a Web3 wallet for App.";
  final String subtitle2 = "or import your wallet.";
  final rpcUrl = dotenv.env['SEPOLIA_RPC_URL'];
  late Client httpClient;
  late Web3Client ethClient;

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
    final privateKey = HEX.encode(wallet.privateKey);
    final walletNotifier = ref.read(walletProvider.notifier);
    walletNotifier.setWallet(WalletModel(walletAddress: wallet.address.hex.toString(), privateKey: privateKey));
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  title,
                  style: textStyle.headlineMedium,
                ),
                Text(
                  subtitle,
                  style: textStyle.headlineSmall,
                ),
                Text(
                  subtitle2,
                  style: textStyle.headlineSmall,
                ),
              ],
            ),
          ),
          Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    generateWallet();
                  },
                  child: const Text("Generate a web3 wallet")),
              SizedBox(
                height: deviceHeight / 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    generateWallet();
                  },
                  child: const Text("Import your web3 wallet")),
              SizedBox(
                height: deviceHeight / 30,
              ),
              copy(context, textStyle, ref.watch(walletProvider).walletAddress, "Wallet address"),
              SizedBox(
                height: deviceHeight / 50,
              ),
              copy(context, textStyle, ref.watch(walletProvider).privateKey, "Private key"),
            ],
          ),
          IconButton.filled(onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NftMainScreen()));
          }, icon: const Icon(Icons.navigate_next_rounded))
        ],
      ),
    );
  }

  Stack copy(BuildContext context, TextTheme textStyle, String copyText, String text) {
    final stars = '*' * (copyText.length);
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black12,
          ),
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              text == "Private key" ? stars : copyText,
              style: textStyle.labelLarge!,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: copyText));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$text copied to clipboard")),
              );
            },
            child: Text("Copy of $text"),
          ),
        ),
      ],
    );
  }
}
