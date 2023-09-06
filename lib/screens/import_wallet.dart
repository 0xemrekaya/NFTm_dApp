import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nftm_dapp/provider/wallet_provider.dart';
import 'package:web3dart/web3dart.dart';

import '../model/wallet_model.dart';
import 'nft_main_screen.dart';

class ImportWallet extends ConsumerStatefulWidget {
  const ImportWallet({super.key});
  static String id = "Import Wallet";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImportWalletState();
}

class _ImportWalletState extends ConsumerState<ImportWallet> {
  final _privateKeyController = TextEditingController();
  bool isImported = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Your Wallet'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              'Enter your private key to import your wallet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueGrey[600],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _privateKeyController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText: 'Private Key',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: ElevatedButton(
                onPressed: isImported
                    ? null
                    : () {
                        sumbit();
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const NftMainScreen()));
                      },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(16.0)),
                ),
                child: const Text(
                  'Import Wallet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sumbit() {
    String privateKey = _privateKeyController.text;
    if (privateKey.isNotEmpty && privateKey.length >= 63) {
      EthPrivateKey ethPrivateKey = EthPrivateKey.fromHex(privateKey);
      final address = ethPrivateKey.address.toString();
      print(address);
      WalletModel newImportedWallet = WalletModel(walletAddress: address, privateKey: privateKey);
      final walletNotifier = ref.read(walletProvider.notifier);
      walletNotifier.setWallet(newImportedWallet);
      setState(() {
        isImported = true;
        _privateKeyController.clear();
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid private key'),
          content: const Text('Please enter a valid private key.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
