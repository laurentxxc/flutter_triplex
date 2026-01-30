// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get localeLogo => '🇵🇹';

  @override
  String get localeDesc => 'Português';

  @override
  String get settingLanguageMenu => 'Idioma';

  @override
  String get settingsSoundMenu => 'Som/Efeitos';

  @override
  String get settingsTutorial => 'Tutorial';

  @override
  String get appTitle => 'Triplex';

  @override
  String get startButton => 'Iniciar';

  @override
  String get pauseButton => 'Pausa';

  @override
  String get resumeButton => 'Retomar';

  @override
  String get currentScore => 'Pontuação atual';

  @override
  String get timeLeft => 'Tempo restante';

  @override
  String get bestScore => 'Melhor pontuação';

  @override
  String get welcomeMessage =>
      '🎉 Bem-vindo ao Triplex 🎉\n\nNeste jogo, tem tempo limitado para encontrar tríos de peças correspondentes baseadas nos seus atributos.\nCada peça tem atributos diferentes (ex: representação, tamanho, cor, fundo).\n\nSelecione três peças para formar uma correspondência.\n\nTem uma correspondência válida se, para cada atributo, as três peças são ou todas iguais ou todas diferentes.\nO objetivo é encontrar o maior número possível de correspondências válidas antes do tempo acabar!\n\nBoa sorte e divirta-se! 🍀';

  @override
  String get pauseMessage =>
      'O jogo está em pausa.\n\nFaça uma pausa ☕️ e retome quando estiver pronto.';

  @override
  String get gameOverMessage =>
      'Jogo terminado! Tempo esgotado.\n\nTente bater a sua melhor pontuação da próxima vez.\n\n😜';

  @override
  String get gameOverMessageBestScore =>
      'Jogo terminado! Tempo esgotado.\n\nParabéns! Achieve a melhor pontuação desta vez.\n\n🎉';
}
