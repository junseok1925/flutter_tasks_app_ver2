import 'package:flutter/material.dart';

class TodoWidget extends StatelessWidget {
  const TodoWidget({
    super.key,
    required this.content,
    required this.isDone,
    required this.onToggle,
  });

  final String content;
  final bool isDone;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          /// 체크박스 영역
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).dividerColor),
                color: isDone ? Theme.of(context).iconTheme.color : null,
              ),
              child: isDone
                  ? Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ),

          SizedBox(width: 20),

          /// 제목 영역
          Expanded(child: Text(content)),
        ],
      ),
    );
  }
}
