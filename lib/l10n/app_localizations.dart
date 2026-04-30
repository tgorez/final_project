import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    )!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ru'),
    Locale('kk'),
  ];

  static final Map<String, Map<String, String>> _values = {
    'en': {
      'appName': 'Social Hub',
      'feed': 'Feed',
      'create': 'Create',
      'explore': 'Explore',
      'profile': 'Profile',
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'username': 'Username',
      'logout': 'Logout',
      'createPost': 'Create Post',
      'postHint': 'What is happening?',
      'post': 'Post',
      'likes': 'likes',
      'darkMode': 'Dark mode',
      'language': 'Language',
      'noPosts': 'No posts yet',
      'userPosts': 'Your posts',
    },
    'ru': {
      'appName': 'Social Hub',
      'feed': 'Лента',
      'create': 'Создать',
      'explore': 'Интересное',
      'profile': 'Профиль',
      'login': 'Войти',
      'register': 'Регистрация',
      'email': 'Почта',
      'password': 'Пароль',
      'username': 'Имя пользователя',
      'logout': 'Выйти',
      'createPost': 'Создать пост',
      'postHint': 'Что происходит?',
      'post': 'Опубликовать',
      'likes': 'лайков',
      'darkMode': 'Темная тема',
      'language': 'Язык',
      'noPosts': 'Постов пока нет',
      'userPosts': 'Ваши посты',
    },
    'kk': {
      'appName': 'Social Hub',
      'feed': 'Лента',
      'create': 'Жасау',
      'explore': 'Қызықты',
      'profile': 'Профиль',
      'login': 'Кіру',
      'register': 'Тіркелу',
      'email': 'Пошта',
      'password': 'Құпия сөз',
      'username': 'Пайдаланушы аты',
      'logout': 'Шығу',
      'createPost': 'Пост жасау',
      'postHint': 'Не болып жатыр?',
      'post': 'Жариялау',
      'likes': 'лайк',
      'darkMode': 'Қараңғы режим',
      'language': 'Тіл',
      'noPosts': 'Әзірге пост жоқ',
      'userPosts': 'Сіздің посттарыңыз',
    },
  };

  String text(String key) {
    return _values[locale.languageCode]?[key] ?? _values['en']![key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru', 'kk'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}