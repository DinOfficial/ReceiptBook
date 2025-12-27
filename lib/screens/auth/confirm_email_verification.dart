import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:receipt_book/screens/auth/log_in_screen.dart';
import 'package:receipt_book/widgets/welcome_app_bar.dart';

class ConfirmEmailVerification extends StatefulWidget {
  const ConfirmEmailVerification({super.key});

  static final String name = 'confirm-email-verify';

  @override
  State<ConfirmEmailVerification> createState() => _ConfirmEmailVerificationState();
}

class _ConfirmEmailVerificationState extends State<ConfirmEmailVerification> {
  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      appBar: WelcomeAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Text(
              'A verification emil has been sent to "$email"',
              style: GoogleFonts.akayaKanadaka(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xff2692ce),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(LoginScreen.name);
              },
              child: const Text("Back To login", style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
