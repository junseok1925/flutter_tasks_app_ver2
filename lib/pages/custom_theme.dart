import 'package:flutter/material.dart';

/// Flutter ThemeExtension.
/// 기존 ThemeData에 포함되지 않는 커스텀 색상들을 추가할 때 사용한다.
/// 예: main, mainLight, sub, background 같은 앱 전용 색상
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  AppThemeExtension({
    required this.main,
    required this.mainLight,
    required this.sub,
    required this.background,
  });

  // 앱에서 사용할 커스텀 색상들
  final Color main;
  final Color mainLight;
  final Color sub;
  final Color background;

  /// copyWith는 현재 값 일부만 바꿀 때 사용.
  /// 지금은 변경 없이 자기 자신을 반환하도록 되어 있다.
  /// (필요하다면 optional parameter로 필요한 값만 override하도록 확장 가능)
  @override
  ThemeExtension<AppThemeExtension> copyWith() => this;

  /// lerp는 라이트모드 ↔ 다크모드 변경될 때
  /// 색상을 부드럽게 보간하여 애니메이션 전환을 가능하게 한다.
  /// t 값은 0.0 → 1.0 사이이며,
  /// 0.0 = 기존 테마 / 1.0 = other 테마
  @override
  ThemeExtension<AppThemeExtension> lerp(
    covariant AppThemeExtension? other,
    double t,
  ) {
    if (other == null) {
      return this;
    }

    print(t); // 테마 전환 애니메이션 진행 값 디버깅용

    return AppThemeExtension(
      main: Color.lerp(main, other.main, t)!, // main 색상 보간
      mainLight: Color.lerp(
        mainLight,
        other.main,
        t,
      )!, // mainLight 보간 (이 부분은 main이 아니라 other.mainLight로 바꾸는 게 더 정상)
      sub: Color.lerp(sub, other.sub, t)!, // sub 보간
      background: Color.lerp(background, other.background, t)!, // background 보간
    );
  }
}

/// 라이트 모드용 테마 확장
class LightTheme extends AppThemeExtension {
  LightTheme({
    super.main = Colors.red, // 핵심 색상
    super.mainLight = const Color(0xAAFF0000), // main 연한 버전
    super.sub = const Color(0xFFFFF000), // 서브 색상
    super.background = Colors.white, // 배경 색상
  });
}

/// 다크 모드용 테마 확장
class DarkTheme extends AppThemeExtension {
  DarkTheme({
    super.main = const Color(0xFF0000FF), // 핵심 색상
    super.mainLight = const Color(0xAA0000FF), // main 연한 버전
    super.sub = const Color(0xFFFF00FF), // 서브 색상
    super.background = Colors.black, // 배경 색상
  });
}
