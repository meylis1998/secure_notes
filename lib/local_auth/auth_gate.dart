import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AuthGate extends StatefulWidget {
  final Widget child;
  const AuthGate({super.key, required this.child});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> with WidgetsBindingObserver {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _checking = true, _authorized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _authenticate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_authorized) {
      _authenticate();
    }
  }

  Future<void> _authenticate() async {
    setState(() {
      _checking = true;
    });

    final canCheckBiometrics = await _auth.canCheckBiometrics;
    final isSupported = await _auth.isDeviceSupported();
    final bioList = await _auth.getAvailableBiometrics();
    debugPrint(
      'Biometric? $canCheckBiometrics, Supported? $isSupported, List: $bioList',
    );

    if (!canCheckBiometrics && !isSupported) {
      _finishAuth(success: true);
      return;
    }

    bool didAuth = false;
    try {
      didAuth = await _auth.authenticate(
        localizedReason: 'Unlock Secure Notes',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      debugPrint('Auth error: $e');
    }

    _finishAuth(success: didAuth);
  }

  void _finishAuth({required bool success}) {
    setState(() {
      _authorized = success;
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_authorized) {
      return widget.child;
    }

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _authenticate,
          child: const Text('Unlock Secure Notes'),
        ),
      ),
    );
  }
}
