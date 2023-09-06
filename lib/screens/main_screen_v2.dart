import 'package:flutter/material.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:walletconnect_modal_flutter/walletconnect_modal_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late WalletConnectModalService service;

  @override
  void initState() {
    super.initState();
    serviceInit();
  }

  Future<void> serviceInit() async {
    service = WalletConnectModalService(
      projectId: "60e96cea968b0ee982d5c486bd88b29d",
      metadata: const PairingMetadata(
        name: 'nftm_dapp',
        description: 'Walcome to nftm_dapp',
        url: 'https://walletconnect.com/',
        icons: ['https://walletconnect.com/walletconnect-logo.png'],
        redirect: Redirect(
          native: 'flutterdapp://',
          universal: 'https://www.walletconnect.com',
        ),
      ),
    );
    await service.init();
  }
  late SessionData? session;
  Web3App? web3app;
  void den() async {
    web3app = await Web3App.createInstance(
      relayUrl: 'wss://relay.walletconnect.com', // The relay websocket URL, leave blank to use the default
      projectId: '60e96cea968b0ee982d5c486bd88b29d',
      metadata: const PairingMetadata(
        name: 'dApp (Requester)',
        description: 'A dapp that can request that transactions be signed',
        url: 'https://walletconnect.com',
        icons: ['https://avatars.githubusercontent.com/u/37784886'],
      ),
    );

    ConnectResponse resp = await web3app!.connect(requiredNamespaces: {
      'eip155': const RequiredNamespace(
        chains: ['eip155:1'], // Ethereum chain
        methods: ['eth_signTransaction'], // Requestable Methods
        events: ['eth_sendTransaction'], // Requestable Events
      ),
    });

    Uri? uri = resp.uri;
    print(uri);
    
    session = await resp.session.future;
  }

  void sign() async {
    final dynamic signResponse = await web3app!.request(
      topic: session!.topic,
      chainId: 'eip155:1',
      request: const SessionRequestParams(
        method: 'eth_signTransaction',
        params: 'json serializable parameters',
      ),
    );
    print(" AAAAAAAAAAA" + signResponse);
  }

  Future<void> connect() async {
    if (!service.isInitialized) {
      // Service must be initialized before calling this method.
      return;
    }
    try {
      await service.open(context: context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  connect();
                },
                child: Text("bağlan")),
            ElevatedButton(
                onPressed: () {
                  den();
                  sign();
                },
                child: Text("send")),
          ],
        )),
      ),
    );
  }
}
