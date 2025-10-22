import 'package:flutter/material.dart';

class TodoWidget extends StatelessWidget {
  TodoWidget({required this.content, required this.isDone});

  String content;
  bool isDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Colors.black12), // 불투명도 12를 가진 black
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).dividerColor),
              color: isDone ? Theme.of(context).iconTheme.color : null,
            ),
            child: isDone
                ? Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(content),
          ), // 텍스트가 길어져서 넘어가지 않게 하기 위해 (부모위젯이 지금 없어서 그럼)
        ],
      ),
    );
  }
}
