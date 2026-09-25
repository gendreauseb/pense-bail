// Point d'entrée du design system : un seul import dans les écrans.
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Theme;

import 'app_colors.dart';
import 'app_text_styles.dart';

export 'app_colors.dart';
export 'app_dimensions.dart';
export 'app_icons.dart';
export 'app_text_styles.dart';
export 'app_theme.dart';

extension DesignContexte on BuildContext {
  AppColors get couleurs => Theme.of(this).extension<AppColors>()!;
  AppTextStyles get textes => Theme.of(this).extension<AppTextStyles>()!;
}
