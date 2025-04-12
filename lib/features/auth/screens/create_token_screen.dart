import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/features/home/dashboard_screen.dart';
import 'package:peopleapp_flutter/features/auth/screens/widgets/bottomsheets/auth_bottomseets.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/core/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:toastification/toastification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:developer' as dev;
import '../../../utils/crypto/helpers.dart';
import '../../../utils/dart_defines.dart';
import '../../../utils/deep_link_handler.dart';
import '../providers/auth_provider.dart';

class CreateTokenScreen extends StatefulWidget {
  const CreateTokenScreen({super.key});

  @override
  State<CreateTokenScreen> createState() => _CreateTokenScreenState();
}

class _CreateTokenScreenState extends State<CreateTokenScreen> {
  final TextEditingController _tokenNameController = TextEditingController();
  ReownAppKit? _appKit;
  ReownAppKitModal? _appKitModal;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeService();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AuthBottomSheets.showSocialConnectionsBottomSheet(context, onDone: () {
        Navigator.pop(context);
      });
    });
  }
  String get _flavor {
    String flavor = '-${const String.fromEnvironment('FLUTTER_APP_FLAVOR')}';
    return flavor.replaceAll('-production', '');
  }

  String _universalLink() {
    Uri link = Uri.parse('https://appkit-lab.reown.com/flutter_appkit');
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
  Future<void> _initializeService() async {
    final prefs = await SharedPreferences.getInstance();
    final linkModeEnabled = prefs.getBool('appkit_sample_linkmode') ?? false;
    final socialsEnabled = prefs.getBool('appkit_sample_socials') ?? true;

    _appKit = ReownAppKit(
      core: ReownCore(
        projectId: DartDefines.projectId,
        logLevel: LogLevel.all,
      ),
      metadata: _pairingMetadata(linkModeEnabled),
    );

    // Register event handlers
    _appKit!.core.relayClient.onRelayClientError.subscribe(_relayClientError);
    _appKit!.core.relayClient.onRelayClientConnect.subscribe(_setState);
    _appKit!.core.relayClient.onRelayClientDisconnect.subscribe(_setState);
    _appKit!.core.relayClient.onRelayClientMessage.subscribe(_onRelayMessage);

    _appKit!.onSessionPing.subscribe(_onSessionPing);
    _appKit!.onSessionEvent.subscribe(_onSessionEvent);
    _appKit!.onSessionUpdate.subscribe(_onSessionUpdate);
    _appKit!.onSessionConnect.subscribe(_onSessionConnect);
    _appKit!.onSessionAuthResponse.subscribe(_onSessionAuthResponse);

    _addOrRemoveNetworks(linkModeEnabled);

    _appKitModal = ReownAppKitModal(
      logLevel: LogLevel.all,
      context: context,
      appKit: _appKit,
      enableAnalytics: true,
      siweConfig: _siweConfig(linkModeEnabled),
      featuresConfig: socialsEnabled ? _featuresConfig() : null,
      optionalNamespaces: _updatedNamespaces(),
      featuredWalletIds: _featuredWalletIds(),
      getBalanceFallback: () async {
        return 0.0;
      },
    );


    _appKitModal!.appKit!.core.addLogListener(_logListener);

    _appKitModal!.onModalConnect.subscribe(_onModalConnect);
    _appKitModal!.onModalUpdate.subscribe(_onModalUpdate);
    _appKitModal!.onModalNetworkChange.subscribe(_onModalNetworkChange);
    _appKitModal!.onModalDisconnect.subscribe(_onModalDisconnect);
    _appKitModal!.onModalError.subscribe(_onModalError);

    await _appKitModal!.init();
    await _registerEventHandlers();
    DeepLinkHandler.init(_appKitModal!);
    DeepLinkHandler.checkInitialLink();
    setState(() {});
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
    final onLine = _appKit!.core.connectivity.isOnline.value;
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
        _appKit!.registerEventHandler(
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

  void _setState(_) => setState(() {});

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
      final url = _appKitModal!.appKit!.metadata.url;
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
      final chainId = _appKitModal!.selectedChain!.chainId;
      final namespace = NamespaceUtils.getNamespaceFromChain(chainId);
      final address = _appKitModal!.session!.getAddress(namespace)!;
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
        final payloadString = await _appKit!.core.crypto.decode(
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
    setState(() {});
  }

  void _onModalUpdate(ModalConnect? event) {
    debugPrint('[CreateToken] _onModalUpdate ${event?.session.toJson()}');
    setState(() {});
  }

  void _onModalNetworkChange(ModalNetworkChange? event) {
    debugPrint('[CreateToken] _onModalNetworkChange ${event?.toString()}');
    setState(() {});
  }

  void _onModalDisconnect(ModalDisconnect? event) {
    debugPrint('[CreateToken] _onModalDisconnect ${event?.toString()}');
    setState(() {});
  }

  void _onModalError(ModalError? event) {
    debugPrint('[CreateToken] _onModalError ${event?.toString()}');
    if ((event?.message ?? '').contains('Coinbase Wallet Error')) {
      _appKitModal!.disconnect();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _tokenNameController.dispose();

    if (_appKitModal != null && _appKit != null) {
      _appKitModal!.appKit!.core.removeLogListener(_logListener);

      _appKit!.core.relayClient.onRelayClientError.unsubscribe(_relayClientError);
      _appKit!.core.relayClient.onRelayClientConnect.unsubscribe(_setState);
      _appKit!.core.relayClient.onRelayClientDisconnect.unsubscribe(_setState);
      _appKit!.core.relayClient.onRelayClientMessage.unsubscribe(_onRelayMessage);

      _appKit!.onSessionPing.unsubscribe(_onSessionPing);
      _appKit!.onSessionEvent.unsubscribe(_onSessionEvent);
      _appKit!.onSessionUpdate.unsubscribe(_onSessionUpdate);
      _appKit!.onSessionConnect.subscribe(_onSessionConnect);
      _appKit!.onSessionAuthResponse.subscribe(_onSessionAuthResponse);

      _appKitModal!.onModalConnect.unsubscribe(_onModalConnect);
      _appKitModal!.onModalUpdate.unsubscribe(_onModalUpdate);
      _appKitModal!.onModalNetworkChange.unsubscribe(_onModalNetworkChange);
      _appKitModal!.onModalDisconnect.unsubscribe(_onModalDisconnect);
      _appKitModal!.onModalError.unsubscribe(_onModalError);
    }

    super.dispose();
  }

  _connectWallet() async {
    if (_appKitModal == null) {
      toastification.show(
        type: ToastificationType.error,
        title: const Text('ReownAppKit not initialized'),
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        alignment: Alignment.bottomCenter,
      );
      return;
    }

    // Check if session exists first
    if (_appKitModal!.session == null) {
      // Show a message to connect wallet first
      toastification.show(
        type: ToastificationType.error,
        title: const Text('Please connect your wallet first'),
        context: context,
        autoCloseDuration: Duration(seconds: 2),
        alignment: Alignment.bottomCenter,
      );
      _appKitModal!.openModalView(const ReownAppKitModalAllWalletsPage());
    } else {
      _createToken();
    }
  }

  Future<void> _createToken() async {
    if (_tokenNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a token name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Here you would typically make an API call to create the token
      // For now we'll just simulate success
      await Future.delayed(const Duration(seconds: 2));

      _showSuccessDialog();
    } catch (e) {
      print('❌ Error in token creation: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating token: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile =
        Provider.of<AuthProvider>(context, listen: false).userProfile;
    return Scaffold(
      backgroundColor: ColorConstants.darkBackground,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 64,
                bottom: 246,
                left: 24,
                right: 24,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Create\nYour Token',
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Choose a unique, catchy token name (max 6 words) that represents you or your brand. Once set, it cannot be changed.',
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorConstants.greyText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 38),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/default_user.png'),
                  ),
                  const SizedBox(height: 36),
                  Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 96),
                      child: TextField(
                        controller: _tokenNameController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorConstants.secondaryBackground,
                          hintText: '\$people',
                          hintStyle: const TextStyle(
                            color: ColorConstants.greyText,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _bottom(),
          ],
        ),
      ),
    );
  }

  _bottom() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: _isLoading
          ? const CircularProgressIndicator(
        color: ColorConstants.primaryPurple,
      )
          : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_appKitModal != null) ...[
            AppKitModalConnectButton(
              appKit: _appKitModal!,
              custom: SizedBox.shrink(),
            ),
            AppKitModalAccountButton(
              appKit: _appKitModal!,
              context: context,
              appKitModal: _appKitModal!,
              custom: SizedBox.shrink(),
            ),
          ],
          PrimaryButton(
            text: 'Create Token',
            isPrimary: true,
            onPressed: () {
              _connectWallet();
            },
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Skip',
            isPrimary: false,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardScreen()));
            },
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorConstants.modalBackground,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/ic_success_modal.png',
                    height: 120,
                  ),
                  const Text(
                    'Success!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Your token has been created successfully.',
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorConstants.greyText,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'Continue',
                    isPrimary: true,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DashboardScreen()));
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}