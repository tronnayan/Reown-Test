import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/features/auth/models/user_wallet_model.dart';
import 'package:peopleapp_flutter/features/auth/service/user_wallet_data_service.dart';
import 'package:peopleapp_flutter/features/main/screens/main_screen.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:reown_appkit/solana/solana_web3/solana_web3.dart' as solana;
import 'package:toastification/toastification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:developer' as dev;
import '../../../core/services/reown/utils/crypto/helpers.dart';
import '../../../core/services/reown/utils/dart_defines.dart';
import '../../../core/services/reown/utils/deep_link_handler.dart';

enum ConnectionStatus { disconnected, connecting, connected, expired }

class ReownProvider extends ChangeNotifier {
  final TextEditingController tokenNameController = TextEditingController();
  ReownAppKit? appKit;
  ReownAppKitModal? appKitModal;
  String walletAddress = '';
  double walletBalance = 0.0;
  bool isWalletConnected = false;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  bool get isModalSession => _getModalSession();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Add connection status
  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;
  ConnectionStatus get connectionStatus => _connectionStatus;

  String get _flavor {
    String flavor = '-${const String.fromEnvironment('FLUTTER_APP_FLAVOR')}';
    return flavor.replaceAll('-production', '');
  }

  bool isSessionValid() {
    if (appKitModal?.session == null) return false;
    // Add any additional session validation logic here
    return true;
  }

  String _universalLink() {
    Uri link = Uri.parse('https://appkit-lab.reown.com/flutterappKit');
    if (_flavor.isNotEmpty || kDebugMode) {
      return link.replace(path: '${link.path}_internal').toString();
    }
    return link.toString();
  }

  Redirect _constructRedirect(bool linkModeEnabled) {
    return Redirect(
      native: 'wcflutterdapp$_flavor://',
      universal: _universalLink(),
      // enable linkMode on Wallet so Dapps can use relay-less connection
      // universal: value must be set on cloud config as well
      linkMode: linkModeEnabled,
    );
  }

  PairingMetadata _pairingMetadata(bool linkModeEnabled) {
    return PairingMetadata(
      name: 'Reown\'s AppKit',
      description: 'Reown\'s sample dApp with Flutter SDK',
      url: _universalLink(),
      icons: [
        'https://raw.githubusercontent.com/reown-com/reown_flutter/refs/heads/develop/assets/appkit-icon$_flavor.png',
      ],
      redirect: _constructRedirect(linkModeEnabled),
    );
  }

  Future<void> initializeService(BuildContext context) async {
    print('isSessionValid: ${isSessionValid()}');
    setIsLoading(true);
    final prefs = await SharedPreferences.getInstance();
    final linkModeEnabled = prefs.getBool('appkit_sample_linkmode') ?? false;
    final socialsEnabled = prefs.getBool('appkit_sample_socials') ?? true;

    appKit = ReownAppKit(
      core: ReownCore(
        projectId: DartDefines.projectId,
        logLevel: LogLevel.all,
      ),
      metadata: _pairingMetadata(linkModeEnabled),
    );

    // Register event handlers
    appKit!.core.relayClient.onRelayClientError.subscribe(_relayClientError);
    appKit!.core.relayClient.onRelayClientConnect.subscribe(_setState);
    appKit!.core.relayClient.onRelayClientDisconnect.subscribe(_setState);
    appKit!.core.relayClient.onRelayClientMessage.subscribe(_onRelayMessage);

    appKit!.onSessionPing.subscribe(_onSessionPing);
    appKit!.onSessionEvent.subscribe(_onSessionEvent);
    appKit!.onSessionUpdate.subscribe(_onSessionUpdate);
    appKit!.onSessionConnect.subscribe(_onSessionConnect);
    appKit!.onSessionAuthResponse.subscribe(_onSessionAuthResponse);

    _addOrRemoveNetworks(linkModeEnabled);

    appKitModal = ReownAppKitModal(
      logLevel: LogLevel.all,
      context: context,
      appKit: appKit,
      enableAnalytics: true,
      siweConfig: _siweConfig(linkModeEnabled),
      featuresConfig: socialsEnabled ? _featuresConfig() : null,
      optionalNamespaces: _updatedNamespaces(),
      featuredWalletIds: _featuredWalletIds(),
      getBalanceFallback: () async {
        return 0.0;
      },
    );

    appKitModal!.appKit!.core.addLogListener(_logListener);

    appKitModal!.onModalConnect.subscribe(_onModalConnect);
    appKitModal!.onModalUpdate.subscribe(_onModalUpdate);
    appKitModal!.onModalNetworkChange.subscribe(_onModalNetworkChange);
    appKitModal!.onModalDisconnect.subscribe(_onModalDisconnect);
    appKitModal!.onModalError.subscribe(_onModalError);

    await appKitModal!.init();
    await _registerEventHandlers();
    DeepLinkHandler.init(appKitModal!);
    DeepLinkHandler.checkInitialLink();
    setIsLoading(false);
    notifyListeners();
  }

  void _logListener(String event) {
    debugPrint('[AppKit] $event');
  }

  void _addOrRemoveNetworks(bool linkMode) {
    ReownAppKitModalNetworks.addSupportedNetworks('eip155', [
      ReownAppKitModalNetworkInfo(
        name: 'Base Sepolia',
        chainId: '84531',
        currency: 'SEP',
        rpcUrl: 'https://sepolia.base.org',
        explorerUrl: 'https://sepolia.basescan.org/',
        isTestNetwork: true,
      ),
    ]);
    ReownAppKitModalNetworks.addSupportedNetworks('solana', [
      ReownAppKitModalNetworkInfo(
        name: 'Solana Mainnet',
        chainId: 'solana:4sGjMW1sUnHzSxGspuhpqLDx6wiyjNtZ',
        chainIcon: 'https://cryptologos.cc/logos/solana-sol-logo.png',
        currency: 'SOL',
        rpcUrl: 'https://api.mainnet-beta.solana.com',
        explorerUrl: 'https://explorer.solana.com',
      ),
      ReownAppKitModalNetworkInfo(
        name: 'Solana Devnet',
        chainId: 'solana:8E9rvCKLFQia2Y35HXjjpWzj8weVo44K',
        chainIcon: 'https://cryptologos.cc/logos/solana-sol-logo.png',
        currency: 'SOL',
        rpcUrl: 'https://api.devnet.solana.com',
        explorerUrl: 'https://explorer.solana.com/?cluster=devnet',
        isTestNetwork: true,
      ),
    ]);

    if (!linkMode) {
      ReownAppKitModalNetworks.addSupportedNetworks('polkadot', [
        ReownAppKitModalNetworkInfo(
          name: 'Polkadot',
          chainId: '91b171bb158e2d3848fa23a9f1c25182',
          chainIcon: 'https://cryptologos.cc/logos/polkadot-new-dot-logo.png',
          currency: 'DOT',
          rpcUrl: 'https://rpc.polkadot.io',
          explorerUrl: 'https://polkadot.subscan.io',
        ),
        ReownAppKitModalNetworkInfo(
          name: 'Westend',
          chainId: 'e143f23803ac50e8f6f8e62695d1ce9e',
          currency: 'DOT',
          rpcUrl: 'https://westend-rpc.polkadot.io',
          explorerUrl: 'https://westend.subscan.io',
          isTestNetwork: true,
        ),
      ]);
      ReownAppKitModalNetworks.addSupportedNetworks('tron', [
        ReownAppKitModalNetworkInfo(
          name: 'Tron',
          chainId: '0x2b6653dc',
          chainIcon: 'https://cryptologos.cc/logos/tron-trx-logo.png',
          currency: 'TRX',
          rpcUrl: 'https://api.trongrid.io',
          explorerUrl: 'https://tronscan.org',
        ),
        ReownAppKitModalNetworkInfo(
          name: 'Tron testnet',
          chainId: '0xcd8690dc',
          chainIcon: 'https://cryptologos.cc/logos/tron-trx-logo.png',
          currency: 'TRX',
          rpcUrl: 'https://nile.trongrid.io',
          explorerUrl: 'https://test.tronscan.org',
          isTestNetwork: true,
        ),
      ]);
      ReownAppKitModalNetworks.addSupportedNetworks('mvx', [
        ReownAppKitModalNetworkInfo(
          name: 'MultiversX',
          chainId: '1',
          currency: 'EGLD',
          rpcUrl: 'https://api.multiversx.com',
          explorerUrl: 'https://explorer.multiversx.com',
          chainIcon: 'https://avatars.githubusercontent.com/u/114073177',
        ),
      ]);
    } else {
      ReownAppKitModalNetworks.removeSupportedNetworks('solana');
    }
  }

  Map<String, RequiredNamespace>? _updatedNamespaces() {
    Map<String, RequiredNamespace>? namespaces = {};

    final evmChains = ReownAppKitModalNetworks.getAllSupportedNetworks(
      namespace: 'eip155',
    );
    if (evmChains.isNotEmpty) {
      namespaces['eip155'] = RequiredNamespace(
        chains: evmChains.map((c) => c.chainId).toList(),
        methods: getChainMethods('eip155'),
        events: getChainEvents('eip155'),
      );
    }

    final solanaChains = ReownAppKitModalNetworks.getAllSupportedNetworks(
      namespace: 'solana',
    );
    if (solanaChains.isNotEmpty) {
      namespaces['solana'] = RequiredNamespace(
        chains: solanaChains.map((c) => c.chainId).toList(),
        methods: getChainMethods('solana'),
        events: getChainEvents('solana'),
      );
    }

    final polkadotChains = ReownAppKitModalNetworks.getAllSupportedNetworks(
      namespace: 'polkadot',
    );
    if (polkadotChains.isNotEmpty) {
      namespaces['polkadot'] = RequiredNamespace(
        chains: polkadotChains.map((c) => c.chainId).toList(),
        methods: getChainMethods('polkadot'),
        events: getChainEvents('polkadot'),
      );
    }

    final tronChains = ReownAppKitModalNetworks.getAllSupportedNetworks(
      namespace: 'tron',
    );
    if (tronChains.isNotEmpty) {
      namespaces['tron'] = RequiredNamespace(
        chains: tronChains.map((c) => c.chainId).toList(),
        methods: getChainMethods('tron'),
        events: getChainEvents('tron'),
      );
    }

    final mvxChains = ReownAppKitModalNetworks.getAllSupportedNetworks(
      namespace: 'mvx',
    );
    if (mvxChains.isNotEmpty) {
      namespaces['mvx'] = RequiredNamespace(
        chains: mvxChains.map((c) => c.chainId).toList(),
        methods: getChainMethods('mvx'),
        events: getChainEvents('mvx'),
      );
    }

    return namespaces;
  }

  Future<void> _registerEventHandlers() async {
    final onLine = appKit!.core.connectivity.isOnline.value;
    if (!onLine) {
      await Future.delayed(const Duration(milliseconds: 500));
      _registerEventHandlers();
      return;
    }

    // Loop through all the chain data
    final allChains = ReownAppKitModalNetworks.getAllSupportedNetworks();
    for (final chain in allChains) {
      // Loop through the events for that chain
      final namespace = NamespaceUtils.getNamespaceFromChain(
        chain.chainId,
      );
      for (final event in getChainEvents(namespace)) {
        appKit!.registerEventHandler(
          chainId: chain.chainId,
          event: event,
        );
      }
    }
  }

  void _onSessionConnect(SessionConnect? event) {
    dev.log(
      '[CreateToken] _onSessionConnect ${jsonEncode(event?.session.toJson())}',
    );
  }

  void _onSessionAuthResponse(SessionAuthResponse? response) {
    debugPrint('[CreateToken] _onSessionAuthResponse $response');
  }

  void _relayClientError(ErrorEvent? event) {
    debugPrint('[CreateToken] _relayClientError ${event?.error}');
    _setState('');
  }

  void _setState(_) => notifyListeners();

  FeaturesConfig? _featuresConfig() {
    return FeaturesConfig(
      email: true,
      socials: [
        AppKitSocialOption.Farcaster,
        AppKitSocialOption.X,
        AppKitSocialOption.Apple,
        AppKitSocialOption.Discord,
      ],
      showMainWallets: true,
    );
  }

  Set<String>? _featuredWalletIds() {
    return {
      'a797aa35c0fadbfc1a53e7f675162ed5226968b44a19ee3d24385c64d1d3c393', // Phantom
      'fd20dc426fb37566d803205b19bbc1d4096b248ac04548e3cfb6b3a38bd033aa', // Coinbase
      '18450873727504ae9315a084fa7624b5297d2fe5880f0982979c17345a138277', // Kraken Wallet
      'c57ca95b47569778a828d19178114f4db188b89b763c899ba0be274e97267d96', // Metamask
      '1ae92b26df02f0abca6304df07debccd18262fdf5fe82daa81593582dac9a369', // Rainbow
      'c03dfee351b6fcc421b4494ea33b9d4b92a984f87aa76d1663bb28705e95034a', // Uniswap
      '38f5d18bd8522c244bdd70cb4a68e0e718865155811c043f052fb9f1c51de662', // Bitget
    };
  }

  SIWEConfig _siweConfig(bool enabled) => SIWEConfig(
        getNonce: () async {
          return SIWEUtils.generateNonce();
        },
        getMessageParams: () async {
          debugPrint('[SIWEConfig] getMessageParams()');
          final url = appKitModal!.appKit!.metadata.url;
          final uri = Uri.parse(url);
          return SIWEMessageArgs(
            domain: uri.authority,
            uri: 'https://${uri.authority}/login',
            statement: 'Welcome to PeopleApp.',
            methods: MethodsConstants.allMethods,
          );
        },
        createMessage: (SIWECreateMessageArgs args) {
          debugPrint('[SIWEConfig] createMessage()');
          return SIWEUtils.formatMessage(args);
        },
        verifyMessage: (SIWEVerifyMessageArgs args) async {
          debugPrint('[SIWEConfig] verifyMessage()');
          final chainId = SIWEUtils.getChainIdFromMessage(args.message);
          final address = SIWEUtils.getAddressFromMessage(args.message);
          final cacaoSignature = args.cacao != null
              ? args.cacao!.s
              : CacaoSignature(
                  t: CacaoSignature.EIP191,
                  s: args.signature,
                );
          return await SIWEUtils.verifySignature(
            address,
            args.message,
            cacaoSignature,
            chainId,
            '07369924ad001504888aad7a8a9e8bcd', // Your project ID
          );
        },
        getSession: () async {
          final chainId = appKitModal!.selectedChain!.chainId;
          final namespace = NamespaceUtils.getNamespaceFromChain(chainId);
          final address = appKitModal!.session!.getAddress(namespace)!;
          return SIWESession(address: address, chains: [chainId]);
        },
        onSignIn: (SIWESession session) {
          debugPrint('[SIWEConfig] onSignIn()');
        },
        signOut: () async {
          return true;
        },
        onSignOut: () {
          debugPrint('[SIWEConfig] onSignOut()');
        },
        enabled: enabled,
        signOutOnDisconnect: true,
        signOutOnAccountChange: false,
        signOutOnNetworkChange: false,
      );

  void _onSessionPing(SessionPing? args) {
    debugPrint('[CreateToken] _onSessionPing $args');
  }

  void _onSessionEvent(SessionEvent? args) {
    debugPrint('[CreateToken] _onSessionEvent $args');
  }

  void _onSessionUpdate(SessionUpdate? args) {
    debugPrint('[CreateToken] _onSessionUpdate $args');
  }

  void _onRelayMessage(MessageEvent? args) async {
    if (args != null) {
      try {
        final payloadString = await appKit!.core.crypto.decode(
          args.topic,
          args.message,
        );
        final data = jsonDecode(payloadString ?? '{}') as Map<String, dynamic>;
        debugPrint('[CreateToken] _onRelayMessage data $data');
      } catch (e) {
        debugPrint('[CreateToken] _onRelayMessage error $e');
      }
    }
  }

  void _onModalConnect(ModalConnect? event) async {
    debugPrint('[CreateToken] _onModalConnect ${event?.session.toJson()}');

    // Get wallet address and balance
    if (appKitModal?.session != null && appKitModal?.selectedChain != null) {
      final chainId = appKitModal!.selectedChain!.chainId;
      final namespace = NamespaceUtils.getNamespaceFromChain(chainId);
      final address = appKitModal!.session!.getAddress(namespace);
      _connectionStatus = ConnectionStatus.connected;
      walletAddress = address ?? '';
      isWalletConnected = true;

      notifyListeners();

      // Try to get balance if possible
      try {
        // Using the proper way to fetch balance based on the chain
        if (address != null) {
          await fetchWalletBalance(address, chainId, namespace);
        }
      } catch (e) {
        debugPrint('[CreateToken] Error getting balance: $e');
      }
    }

    notifyListeners();
  }

  // Method to fetch wallet balance based on blockchain
  Future<void> fetchWalletBalance(
      String address, String chainId, String namespace) async {
    try {
      double balance = 0.0;

      if (namespace == 'solana') {
        print('chainId: $chainId');
        print('[CreateToken] Fetching Solana balance for address: $address');
        // For Solana chains
        final cluster = solana.Cluster.https(
          Uri.parse(appKitModal!.selectedChain!.rpcUrl).authority,
        );
        final connection = solana.Connection(cluster);

        // Get the SOL balance
        final lamports =
            await connection.getBalance(solana.Pubkey.fromBase58(address));
        // Convert lamports to SOL (1 SOL = 1,000,000,000 lamports)
        balance = lamports.toDouble() / 1000000000;

        debugPrint(
            '[CreateToken] Solana balance in lamports: $lamports, in SOL: $balance');
      } else if (namespace == 'eip155') {
        // For EVM chains, you could use Web3 to get the balance
        debugPrint('[CreateToken] EVM chain balance not implemented yet');
        balance = 0.0; // Placeholder
      } else {
        // Default fallback
        debugPrint(
            '[CreateToken] Balance not implemented for namespace: $namespace');
        balance = 0.0;
      }

      walletBalance = balance;
      notifyListeners();
    } catch (e) {
      debugPrint('[CreateToken] Error in _fetchWalletBalance: $e');
      // Set default value in case of error
      walletBalance = 0.0;
      notifyListeners();
    }
  }

  void _onModalUpdate(ModalConnect? event) {
    debugPrint('[CreateToken] _onModalUpdate ${event?.session.toJson()}');
    notifyListeners();
  }

  void _onModalNetworkChange(ModalNetworkChange? event) {
    debugPrint('[CreateToken] _onModalNetworkChange ${event?.toString()}');
    notifyListeners();
  }

  void _onModalDisconnect(ModalDisconnect? event) {
    debugPrint('[CreateToken] _onModalDisconnect ${event?.toString()}');
    _connectionStatus = ConnectionStatus.disconnected;
    isWalletConnected = false;
    walletAddress = '';
    HiveService.clearWalletData();
    notifyListeners();
  }

  void _onModalError(ModalError? event) {
    debugPrint('[CreateToken] _onModalError ${event?.toString()}');
    if ((event?.message ?? '').contains('Coinbase Wallet Error')) {
      _connectionStatus = ConnectionStatus.disconnected;
      appKitModal!.disconnect();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    print('dispose called on reown provider');
    tokenNameController.dispose();

    if (appKitModal != null && appKit != null) {
      appKitModal!.appKit!.core.removeLogListener(_logListener);

      appKit!.core.relayClient.onRelayClientError
          .unsubscribe(_relayClientError);
      appKit!.core.relayClient.onRelayClientConnect.unsubscribe(_setState);
      appKit!.core.relayClient.onRelayClientDisconnect.unsubscribe(_setState);
      appKit!.core.relayClient.onRelayClientMessage
          .unsubscribe(_onRelayMessage);

      appKit!.onSessionPing.unsubscribe(_onSessionPing);
      appKit!.onSessionEvent.unsubscribe(_onSessionEvent);
      appKit!.onSessionUpdate.unsubscribe(_onSessionUpdate);
      appKit!.onSessionConnect.subscribe(_onSessionConnect);
      appKit!.onSessionAuthResponse.subscribe(_onSessionAuthResponse);

      appKitModal!.onModalConnect.unsubscribe(_onModalConnect);
      appKitModal!.onModalUpdate.unsubscribe(_onModalUpdate);
      appKitModal!.onModalNetworkChange.unsubscribe(_onModalNetworkChange);
      appKitModal!.onModalDisconnect.unsubscribe(_onModalDisconnect);
      appKitModal!.onModalError.unsubscribe(_onModalError);
    }

    super.dispose();
  }

  Future<void> connectWallet(BuildContext context) async {
    setIsLoading(true);

    if (tokenNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a token name'),
          backgroundColor: Colors.red,
        ),
      );
      setIsLoading(false);
      return;
    }

    if (appKitModal == null) {
      // initializeService(context);
      toastification.show(
        type: ToastificationType.error,
        title: const Text('ReownAppKit not initialized'),
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        alignment: Alignment.bottomCenter,
      );
      setIsLoading(false);
      return;
    }

    if (appKitModal!.session == null) {
      toastification.show(
        type: ToastificationType.error,
        title: const Text('Please connect your wallet first'),
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        alignment: Alignment.bottomCenter,
      );

      appKitModal!
          .openModalView(const ReownAppKitModalAllWalletsPage())
          .then((value) {
        _createToken(context);
      }).onError((error, stackTrace) {
        setIsLoading(false);
        print('❌ Error in connectWallet: $error');
      });
    } else {
      _createToken(context);
    }
  }

  Future<void> _createToken(BuildContext context) async {
    try {
      final chainId = appKitModal!.selectedChain!.chainId;
      final namespace = NamespaceUtils.getNamespaceFromChain(chainId);
      print('reownProvider entered name: $namespace');

      if (appKitModal?.session != null && appKitModal?.selectedChain != null) {
        final walletData = WalletData(
          walletAddress: walletAddress,
          walletBalance: walletBalance,
          chainId: chainId,
          chainName: appKitModal!.selectedChain!.name,
          currency: appKitModal!.selectedChain!.currency ?? '',
          tokenName: tokenNameController.text,
        );

        try {
          await HiveService.saveWalletData(walletData);
          print('🟢 Wallet data stored successfully');
        } catch (e) {
          print('❌ Error storing wallet data: $e');
          // Continue with navigation even if storage fails
        }
      }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen(
                    appKitModal: appKitModal,
                  )));

      // if (namespace == 'solana') {
      //   final address = appKitModal!.session!.getAddress(namespace);

      //   if (address != null) {

      //     final params = await getParams(
      //       'solana_signAndSendTransaction',
      //       address,
      //       appKitModal!.selectedChain!,
      //     );

      //     if (params != null) {
      //       final sessionTopic = appKitModal!.session!.topic;

      //       final result = await appKitModal!.request(
      //         topic: sessionTopic,
      //         chainId: chainId,
      //         request: params,
      //       );

      //       if (result != null) {
      //         debugPrint('[CreateToken] Transaction result: $result');
      //         _showSuccessDialog();
      //       } else {
      //         throw Exception('Transaction failed');
      //       }
      //     } else {
      //       throw Exception('Failed to build transaction parameters');
      //     }
      //   } else {
      //     throw Exception('No wallet address found');
      //   }
      // } else {
      //   // For demonstration purposes, we'll still show success for non-Solana chains
      //   await Future.delayed(const Duration(seconds: 2));
      //   _showSuccessDialog();
      // }
    } catch (e) {
      print('❌ Error in token creation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating token: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setIsLoading(false);
    }
  }

  Future<void> _handleReconnection(BuildContext context) async {
    try {
      _connectionStatus = ConnectionStatus.connecting;
      notifyListeners();

      // Reset the session
      await appKitModal?.disconnect();

      // Reinitialize if needed
      if (!_isInitialized) {
        await initializeService(context);
      }

      // Open modal for reconnection
      await appKitModal!.openModalView(const ReownAppKitModalAllWalletsPage());
    } catch (e) {
      _connectionStatus = ConnectionStatus.disconnected;
      notifyListeners();
      throw ReownAppKitModalException('Failed to reconnect: ${e.toString()}');
    }
  }

  bool _getModalSession() {
    if (appKitModal?.session != null) {
      return true;
    }
    return false;
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Add session expiry handler
  void _handleSessionExpiry() {
    _connectionStatus = ConnectionStatus.expired;
    isWalletConnected = false;
    notifyListeners();
  }

  void _registerAppKitEventHandlers() {
    appKit!.core.relayClient.onRelayClientError.subscribe(_relayClientError);
    appKit!.core.relayClient.onRelayClientConnect.subscribe(_setState);
    appKit!.core.relayClient.onRelayClientDisconnect.subscribe(_setState);
    appKit!.core.relayClient.onRelayClientMessage.subscribe(_onRelayMessage);

    appKit!.onSessionPing.subscribe(_onSessionPing);
    appKit!.onSessionEvent.subscribe(_onSessionEvent);
    appKit!.onSessionUpdate.subscribe(_onSessionUpdate);
    appKit!.onSessionConnect.subscribe(_onSessionConnect);
    appKit!.onSessionAuthResponse.subscribe(_onSessionAuthResponse);
  }

  void _registerModalEventHandlers() {
    appKitModal!.appKit!.core.addLogListener(_logListener);
    appKitModal!.onModalConnect.subscribe(_onModalConnect);
    appKitModal!.onModalUpdate.subscribe(_onModalUpdate);
    appKitModal!.onModalNetworkChange.subscribe(_onModalNetworkChange);
    appKitModal!.onModalDisconnect.subscribe(_onModalDisconnect);
    appKitModal!.onModalError.subscribe(_onModalError);
  }
}
