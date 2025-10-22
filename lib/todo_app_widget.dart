import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class addTodoWidget extends StatelessWidget {
  String titleText = '준석`s Todo';
  VoidCallback onCreate;
  TextEditingController controller = TextEditingController();

  addTodoWidget({required this.onCreate, required this.controller});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 400,
      height: 300,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        spacing: 10,
        children: [
          GestureDetector(
            onTap: () {
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
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
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
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
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
            child: Icon(
              CupertinoIcons.add_circled_solid,
              size: 100,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '아직 할 일이 없음',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            '할 일을 추가하고 $titleText에서\n할 일을 추적하세요.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
