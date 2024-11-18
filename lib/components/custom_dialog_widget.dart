import 'package:flutter/material.dart';

class CustomDialogWidget {
  static Future<void> dialogLoading(
      {required String msg, required BuildContext context}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            contentPadding: const EdgeInsets.all(16),
            surfaceTintColor: Colors.black.withOpacity(0.5),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Colors.black,
                ),
                const SizedBox(height: 20),
                Text(msg,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ));
      },
    );
  }
}
