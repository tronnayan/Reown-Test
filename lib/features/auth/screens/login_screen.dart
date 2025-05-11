import 'package:flutter/material.dart';
import 'package:peopleapp_flutter/core/constants/image_constants.dart';
import 'package:peopleapp_flutter/features/auth/providers/authentication_provider.dart';
import 'package:peopleapp_flutter/core/routes/app_path_constants.dart';
import 'package:peopleapp_flutter/core/routes/app_routes.dart';
import 'package:peopleapp_flutter/core/constants/color_constants.dart';
import 'package:peopleapp_flutter/core/widgets/custom_button.dart';
import 'package:peopleapp_flutter/features/auth/screens/widgets/form_feilds.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.darkBackground,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Consumer<AuthenticationProvider>(
            builder: (context, authProvider, child) {
          return Stack(
            children: [
              _bottomButton(context: context, authProvider: authProvider),
              _mainContent(context: context, authProvider: authProvider),
            ],
          );
        }),
      ),
    );
  }

  _mainContent(
      {required BuildContext context,
      required AuthenticationProvider authProvider}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        CustomButton.backButton(context),
        Image.asset(
          ImageConstants.peopleLogo,
          width: 200,
          height: 100,
        ),
        const SizedBox(height: 40),
        const Text(
          'Login ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 42,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Join your community of creators and investors',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 32),
        FormFields(
          controller: _emailController,
          label: 'Email',
          hintText: 'Enter your email',
          enabled: true,
          onChanged: (value) {},
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: () => {
            NavigationService.navigateTo(context, RouteConstants.signupScreen)
          },
          child: const Text(
            'Don\'t have an account? Sign up',
            style: TextStyle(
              color: ColorConstants.primaryPurple,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: ColorConstants.primaryPurple,
            ),
          ),
        ),
      ],
    );
  }

  _bottomButton({
    required BuildContext context,
    required AuthenticationProvider authProvider,
  }) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            text: 'Send OTP',
            onPressed: () => authProvider.sentOtp(
              email: _emailController.text,
              context: context,
            ),
            isLoading: authProvider.isLoading,
            isPrimary: true,
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Terms of Use',
                style: TextStyle(
                  color: ColorConstants.greyText,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 16),
              Text(
                'Privacy Policy',
                style: TextStyle(
                  color: ColorConstants.greyText,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}














































// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:peopleapp_flutter/features/auth/models/auth_response.dart';
// import 'package:peopleapp_flutter/features/auth/create_token_screen.dart';
// import 'package:peopleapp_flutter/features/core/dashboard_screen.dart';
// import 'package:peopleapp_flutter/utils/constants.dart';
// import 'package:peopleapp_flutter/utils/reown/style_constants.dart';
// import 'package:peopleapp_flutter/widgets/common/custom_button.dart';
// import 'package:provider/provider.dart';
// import 'package:peopleapp_flutter/features/auth/providers/auth_provider.dart';
// import 'package:peopleapp_flutter/services/privy_service.dart';
// import 'package:reown_appkit/reown_appkit.dart';

// import '../../../constants/api_routes.dart'; 
// import '../../../services/api_service.dart'; 

// class LoginPage extends StatefulWidget {
//   final ReownAppKitModal? appKitModal;
//   const LoginPage({super.key, required this.appKitModal});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _privyService = PrivyService();

//   final _apiService = ApiService();
//   final _emailController = TextEditingController();
//   final _otpController = TextEditingController();
//   bool _showLoginForm = false;
//   bool _showOtpField = false;
//   bool _isLoading = false;
//   String? _errorMessage;

//   final List<ReownAppKitModalNetworkInfo> _selectedChains = [];
//   bool _shouldDismissQrCode = true;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.appKitModal != null) {
//       widget.appKitModal!.onModalConnect.subscribe(_onModalConnect);
//       widget.appKitModal!.onModalUpdate.subscribe(_onModalUpdate);
//       widget.appKitModal!.onModalNetworkChange.subscribe(_onModalNetworkChange);
//       widget.appKitModal!.onModalDisconnect.subscribe(_onModalDisconnect);
//       widget.appKitModal!.onModalError.subscribe(_onModalError);
//       //
//       widget.appKitModal!.appKit!.onSessionConnect.subscribe(
//         _onSessionConnect,
//       );
//       widget.appKitModal!.appKit!.onSessionAuthResponse.subscribe(
//         _onSessionAuthResponse,
//       );
//       widget.appKitModal!.onModalDisconnect.subscribe(
//         _onModalDisconnect,
//       );
//     }
//   }

//   Future<void> _connectWallet() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//     if (widget.appKitModal!.isConnected) {
//       _apiCall(connectedAddress!);
//     } else {
//       widget.appKitModal!
//           .openModalView(const ReownAppKitModalAllWalletsPage())
//           .onError((e, stackTrace) {
//         setState(() {
//           _isLoading = false;
//           _errorMessage = null;
//         });
//       }).then((va) {
//         print('🟣 LoginScreen: Connected address: $connectedAddress');
//         if (connectedAddress != null) {
//           _apiCall(connectedAddress!);
//         } else {
//           setState(() {
//             _isLoading = false;
//             _errorMessage = 'Failed to connect wallet';
//           });
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       onPopInvokedWithResult: (didPop, result) async {
//         SystemNavigator.pop(); // This will close the app
//       },
//       child: Scaffold(
//         backgroundColor: ColorConstants.darkBackground,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(right: 56, top: 20),
//                   child: Image.asset(
//                     'assets/images/coin_image.png',
//                   ),
//                 ),
//                 const Text(
//                   'Tokenize\nYour Influence.',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 42,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 16),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24),
//                   child: Text(
//                     'Transform social influence into tokens, and let your fans invest, trade, and grow with you.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.8),
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 48),
//                 if (!_showLoginForm) ...[
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24),
//                     child: Column(
//                       children: [
//                         if (widget.appKitModal != null)
//                           Visibility(
//                             visible: false,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 AppKitModalNetworkSelectButton(
//                                   appKit: widget.appKitModal!,
//                                   size: BaseButtonSize.small,
//                                 ),
//                                 const SizedBox.square(dimension: 8.0),
//                                 AppKitModalConnectButton(
//                                   appKit: widget.appKitModal!,
//                                   size: BaseButtonSize.big,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         const SizedBox(height: StyleConstants.linear8),
//                         CustomButton(
//                           text: 'Connect Wallet',
//                           onPressed: _connectWallet, // Use Reown connect method
//                           isPrimary: true,
//                           isLoading: _isLoading,
//                         ),
//                         const SizedBox(height: 16),
//                         CustomButton(
//                           text: 'Login with Email',
//                           onPressed: _isLoading
//                               ? () {}
//                               : () {
//                                   setState(() => _showLoginForm = true);
//                                   // NavigationService.navigateTo(
//                                   //     context, AppRoutes.createToken);
//                                 },
//                           isPrimary: false,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ] else ...[
//                   AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     margin: const EdgeInsets.symmetric(horizontal: 24),
//                     child: Column(
//                       children: [
//                         TextField(
//                           controller: _emailController,
//                           decoration: InputDecoration(
//                             labelText: 'Email',
//                             hintText: 'Enter your email',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             enabled: !_isLoading && !_showOtpField,
//                             fillColor:
//                                 ColorConstants.darkBackground.withOpacity(0.5),
//                             filled: true,
//                           ),
//                           keyboardType: TextInputType.emailAddress,
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                         if (_showOtpField) ...[
//                           const SizedBox(height: 16),
//                           TextField(
//                             controller: _otpController,
//                             decoration: InputDecoration(
//                               labelText: 'OTP',
//                               hintText: 'Enter OTP from email',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               enabled: !_isLoading,
//                               fillColor:
//                                   ColorConstants.darkBackground.withOpacity(0.5),
//                               filled: true,
//                             ),
//                             keyboardType: TextInputType.number,
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ],
//                         if (_errorMessage != null)
//                           Padding(
//                             padding: const EdgeInsets.only(top: 8),
//                             child: Text(
//                               _errorMessage!,
//                               style: const TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                         const SizedBox(height: 24),
//                         if (_isLoading)
//                           const CircularProgressIndicator(
//                             color: ColorConstants.primaryPurple,
//                           )
//                         else
//                           CustomButton(
//                             text: _showOtpField ? 'Verify OTP' : 'Send OTP',
//                             onPressed: _showOtpField ? _verifyOtp : _sendOtp,
//                             isPrimary: true,
//                           ),
//                         const SizedBox(height: 16),
//                         TextButton(
//                           onPressed: () =>
//                               setState(() => _showLoginForm = false),
//                           child: const Text(
//                             'Back to login options',
//                             style: TextStyle(
//                               color: ColorConstants.primaryPurple,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//                 const SizedBox(height: 24),
//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Terms of Use',
//                       style: TextStyle(
//                         color: ColorConstants.greyText,
//                         fontSize: 14,
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     Text(
//                       'Privacy Policy',
//                       style: TextStyle(
//                         color: ColorConstants.greyText,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   _apiCall(walletAddress) async {
//     final response = await _apiService.post(
//       ApiRoutes.login,
//       data: {
//         'auth_type': 1,
//         'wallet_address': walletAddress,
//         'wallet_type': 'reown',
//       },
//     );
//     print('📱 ReownService: Login API Response: ${response.data}');
//     if (response.statusCode == 200) {
//       final authResponse = AuthResponse.fromJson(response.data['data']);
//       print('🟣 LoginScreen: Auth response: ${authResponse.toJson()}');
//       if (mounted) {
//         context.read<AuthProvider>().updateAuthState(authResponse);
//         Navigator.push(
//             context,
//             !authResponse.accountCreated
//                 ? MaterialPageRoute(
//                     builder: (context) =>
//                         CreateTokenScreen(appKitModal: widget.appKitModal!))
//                 : MaterialPageRoute(
//                     builder: (context) => const DashboardScreen()));
//       }
//     } else {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = null;
//       });
//       throw Exception('Login failed: ${response.data['message']}');
//     }
//   }

//   Future<void> _sendOtp() async {
//     final email = _emailController.text.trim();
//     if (email.isEmpty || !email.contains('@')) {
//       setState(() => _errorMessage = 'Please enter a valid email address');
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final result = await _privyService.sendEmailOtp(email);
//       if (result['success']) {
//         setState(() {
//           _showOtpField = true;
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _verifyOtp() async {
//     final email = _emailController.text.trim();
//     final otp = _otpController.text.trim();

//     if (otp.isEmpty) {
//       setState(() => _errorMessage = 'Please enter the OTP');
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final authResponse = await _privyService.verifyEmailOtp(email, otp);

//       if (mounted) {
//         context.read<AuthProvider>().updateAuthState(authResponse);
//         // NavigationService.navigateTo(
//         //   context: context,
//         //   widget: authResponse.accountCreated
//         //       ? CreateTokenScreen(appKitModal: widget.appKitModal!)
//         //       : const DashboardScreen(),
//         // );
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   void _onSessionAuthResponse(SessionAuthResponse? response) {
//     if (response?.session != null) {
//       setState(() => _selectedChains.clear());
//     }
//   }

//   void _onModalConnect(ModalConnect? event) async {
//     setState(() {});
//   }

//   void _onModalUpdate(ModalConnect? event) {
//     setState(() {});
//   }

//   void _onModalNetworkChange(ModalNetworkChange? event) {
//     setState(() {});
//   }

//   void _onModalDisconnect(ModalDisconnect? event) {
//     setState(() {});
//   }

//   void _onModalError(ModalError? event) {
//     setState(() {});
//   }

//   void _onSessionConnect(SessionConnect? event) async {
//     if (event == null) return;

//     setState(() => _selectedChains.clear());

//     if (_shouldDismissQrCode && Navigator.canPop(context)) {
//       _shouldDismissQrCode = false;
//       Navigator.pop(context);
//     }
//   }

//   String? get connectedAddress {
//     if (widget.appKitModal!.isConnected &&
//         widget.appKitModal!.session != null) {
//       final chainId = widget.appKitModal!.selectedChain?.chainId ?? '1';
//       final ns = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);

//       return widget.appKitModal!.session!.getAddress(ns);
//     }
//     print(
//         '🟣 LoginScreen: Connected address: $connectedAddress ${widget.appKitModal!.session} ${widget.appKitModal!.isConnected}');
//     return null;
//   }
// }
