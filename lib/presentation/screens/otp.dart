import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:progress_soft/presentation/constants/colors.dart';
import 'package:progress_soft/presentation/constants/size.dart';
import 'package:progress_soft/presentation/screens/login_screen.dart';
import 'package:sms_autofill/sms_autofill.dart';

/// [OTPScreen] represent OTP screen
class OTPScreen extends StatefulWidget {
  /// [OTPScreen] consturctor.
  const OTPScreen({
    super.key,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String otpCode = '';

  @override
  void initState() {
    listen();
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    debugPrint('Unregistered Listener');
    super.dispose();
  }

  Future<void> listen() async {
    await SmsAutoFill().listenForCode();
  }

  String maskingSMSnumber(String smsnum) {
    final numSpace = smsnum.length - 4;
    var result = '';
    if (numSpace > 0) {
      result = smsnum.replaceRange(0, numSpace, '*' * numSpace);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    Text(
                      appLocalizations.enterVerCode,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      appLocalizations.enterThe6DigitNumber,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        maskingSMSnumber(
                          '333444444',
                        ),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PinFieldAutoFill(
                            autoFocus: true,
                            currentCode: otpCode,
                            decoration: BoxLooseDecoration(
                              radius: const Radius.circular(12),
                              strokeColorBuilder: const FixedColorBuilder(
                                greenColor,
                              ),
                            ),
                            onCodeChanged: (code) {
                              debugPrint('OnCodeChanged : $code');
                              otpCode = code.toString();

                              setState(() {});
                              if (otpCode.length == 6) {}
                            },
                            onCodeSubmitted: (val) {
                              debugPrint('OnCodeSubmitted : $val');
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 270),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(pt16),
          child: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                onPressed: otpCode.length == 6
                    ? () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute<dynamic>(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => route.isFirst,
                        );
                      }
                    : null,
                child: Text(
                  appLocalizations.confirm,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}