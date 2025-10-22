// floatingActionBTN_widget.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloatingActionBTNWidget extends StatelessWidget {
  VoidCallback onCreate;
  TextEditingController controller = TextEditingController();

  FloatingActionBTNWidget({required this.onCreate, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: CircleBorder(),
      child: Icon(CupertinoIcons.add),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    onSubmitted: (title) {
                      onCreate();
                      Navigator.pop(context);
                    },
                    decoration: InputDecoration(
                      hintText: "새 할 일",
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.short_text_rounded, size: 30),
                      SizedBox(width: 20),
                      Icon(Icons.star_border, size: 30),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          onCreate();
                          Navigator.pop(context);
                        },
                        child: Text(
                          '저장',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
