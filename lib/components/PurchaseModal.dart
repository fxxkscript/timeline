import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class PurchaseButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  PurchaseButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        onPressed: onPressed,
        child: Container(
            height: 44,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 65, 61, 62),
                  Color.fromARGB(255, 27, 25, 26)
                ])),
            child: Center(
                child: Text(text,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 252, 234, 184))))));
  }
}

showPurchaseModal(
    context, String placeholder, String buttonText, Function confirm) {
  final textController = TextEditingController();

  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final onButtonTap = () async {
          if (textController.text.isEmpty) {
            return;
          }
          String msg;
          try {
            await confirm(textController.text);
            msg = '激活成功';
            Navigator.pop(context);
          } catch (e) {
            msg = e.toString();
          }
          showToast(msg, textPadding: EdgeInsets.all(15));
        };
        return SingleChildScrollView(
            child: Container(
                decoration: BoxDecoration(color: Colors.white),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                  padding: const EdgeInsets.all(64.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: textController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: placeholder,
                            fillColor: Color(0xFFF6F6F6),
                            filled: true),
                      ),
                      Container(height: 24),
                      PurchaseButton(buttonText, onButtonTap),
                    ],
                  ),
                )));
      });
}
