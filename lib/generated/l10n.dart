// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Sign up`
  String get signup {
    return Intl.message(
      'Sign up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get Login {
    return Intl.message(
      'Log in',
      name: 'Login',
      desc: '',
      args: [],
    );
  }

  /// `Guest`
  String get Guest {
    return Intl.message(
      'Guest',
      name: 'Guest',
      desc: '',
      args: [],
    );
  }

  /// `change Language`
  String get changeLanguageButton {
    return Intl.message(
      'change Language',
      name: 'changeLanguageButton',
      desc: '',
      args: [],
    );
  }

  /// `HomePage`
  String get homePage {
    return Intl.message(
      'HomePage',
      name: 'homePage',
      desc: '',
      args: [],
    );
  }

  /// `What is the event...`
  String get Writeyourpost {
    return Intl.message(
      'What is the event...',
      name: 'Writeyourpost',
      desc: '',
      args: [],
    );
  }

  /// `language`
  String get language {
    return Intl.message(
      'language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get home {
    return Intl.message(
      '',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `person`
  String get person {
    return Intl.message(
      'person',
      name: 'person',
      desc: '',
      args: [],
    );
  }

  /// `No new notifications .`
  String get Noewnotifications {
    return Intl.message(
      'No new notifications .',
      name: 'Noewnotifications',
      desc: '',
      args: [],
    );
  }

  /// `Create a post`
  String get Createapost {
    return Intl.message(
      'Create a post',
      name: 'Createapost',
      desc: '',
      args: [],
    );
  }

  /// ` ? Text`
  String get Text {
    return Intl.message(
      ' ? Text',
      name: 'Text',
      desc: '',
      args: [],
    );
  }

  /// `Add a location (optional)`
  String get Addalocation {
    return Intl.message(
      'Add a location (optional)',
      name: 'Addalocation',
      desc: '',
      args: [],
    );
  }

  /// `time and date for the event (optional)`
  String get Timeanddate {
    return Intl.message(
      'time and date for the event (optional)',
      name: 'Timeanddate',
      desc: '',
      args: [],
    );
  }

  /// `Share the post`
  String get Sharethepost {
    return Intl.message(
      'Share the post',
      name: 'Sharethepost',
      desc: '',
      args: [],
    );
  }

  /// `Add photo/video`
  String get Addphotovideo {
    return Intl.message(
      'Add photo/video',
      name: 'Addphotovideo',
      desc: '',
      args: [],
    );
  }

  /// `picture selection`
  String get Chooseapictur {
    return Intl.message(
      'picture selection',
      name: 'Chooseapictur',
      desc: '',
      args: [],
    );
  }

  /// `Video selection`
  String get Videoselection {
    return Intl.message(
      'Video selection',
      name: 'Videoselection',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
