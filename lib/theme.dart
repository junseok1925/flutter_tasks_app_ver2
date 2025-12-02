import 'package:flutter/material.dart';
import 'package:flutter_tasks_app_ver2/custom_theme.dart';

/// 라이트 / 다크 테마 각각 ThemeData 형태로 생성
final lightTheme = _theme(Brightness.light, AppThemeExtension.light);
final darkTheme = _theme(Brightness.dark, AppThemeExtension.dark);

/// ThemeData 생성 함수
/// brightness와 AppThemeExtension(커스텀 색상 세트)을 받아
/// 실제 ThemeData 객체로 변환한다.
ThemeData _theme(Brightness brightness, AppThemeExtension ext) {
  return ThemeData(
    brightness: brightness, // 라이트/다크 모드 지정
    useMaterial3: true, // Material 3 적용
    // Scaffold 배경색에 커스텀 테마의 background 사용
    scaffoldBackgroundColor: ext.background,

    // ColorScheme 생성: seedColor 기반으로 전체 색상 자동 생성
    colorScheme: ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: ext.main,
    ),

    // ThemeExtension 등록
    // AppThemeExtension을 theme.extension<AppThemeExtension>()로 접근 가능
    extensions: <ThemeExtension<dynamic>>[ext],
  );
}

/// BuildContext 확장
/// context.theme, context.appColor 같은 단축 접근자를 제공한다.
extension BuildContextExtension on BuildContext {
  // Theme.of(context) → context.theme
  ThemeData get theme => Theme.of(this);

  // ThemeExtension 불러오기 → context.appColor
  // '!': ThemeExtension이 반드시 존재한다고 명시(위에서 extensions에 넣었으므로 안전)
  AppThemeExtension get appColor => theme.extension<AppThemeExtension>()!;
}
