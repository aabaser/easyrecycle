import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Easy Recycle'**
  String get app_title;

  /// No description provided for @language_title.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get language_title;

  /// No description provided for @language_de.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get language_de;

  /// No description provided for @language_tr.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get language_tr;

  /// No description provided for @language_en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_en;

  /// No description provided for @language_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get language_continue;

  /// No description provided for @city_title.
  ///
  /// In en, this message translates to:
  /// **'Which city?'**
  String get city_title;

  /// No description provided for @city_search_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Search city (e.g. Berlin, Hannover)'**
  String get city_search_placeholder;

  /// No description provided for @city_helper.
  ///
  /// In en, this message translates to:
  /// **'Rules are city-specific.'**
  String get city_helper;

  /// No description provided for @city_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get city_save;

  /// No description provided for @scan_title.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan_title;

  /// No description provided for @scan_take_photo.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get scan_take_photo;

  /// No description provided for @scan_pick_gallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get scan_pick_gallery;

  /// No description provided for @scan_upload.
  ///
  /// In en, this message translates to:
  /// **'Upload image'**
  String get scan_upload;

  /// No description provided for @scan_text_placeholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. battery, cable, glass bottle'**
  String get scan_text_placeholder;

  /// No description provided for @result_recognized.
  ///
  /// In en, this message translates to:
  /// **'Recognized'**
  String get result_recognized;

  /// No description provided for @result_recognized_prefix.
  ///
  /// In en, this message translates to:
  /// **'Recognized:'**
  String get result_recognized_prefix;

  /// No description provided for @result_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get result_description;

  /// No description provided for @result_categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get result_categories;

  /// No description provided for @result_disposals.
  ///
  /// In en, this message translates to:
  /// **'Disposals (all)'**
  String get result_disposals;

  /// No description provided for @confidence_high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get confidence_high;

  /// No description provided for @confidence_medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get confidence_medium;

  /// No description provided for @confidence_low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get confidence_low;

  /// No description provided for @disposal_title_prefix.
  ///
  /// In en, this message translates to:
  /// **'Disposal'**
  String get disposal_title_prefix;

  /// No description provided for @show_steps.
  ///
  /// In en, this message translates to:
  /// **'Show instructions'**
  String get show_steps;

  /// No description provided for @description_more.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get description_more;

  /// No description provided for @description_less.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get description_less;

  /// No description provided for @details_show.
  ///
  /// In en, this message translates to:
  /// **'Show details'**
  String get details_show;

  /// No description provided for @details_hide.
  ///
  /// In en, this message translates to:
  /// **'Hide details'**
  String get details_hide;

  /// No description provided for @details_button.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details_button;

  /// No description provided for @feedback_prompt.
  ///
  /// In en, this message translates to:
  /// **'Is this correct?'**
  String get feedback_prompt;

  /// No description provided for @find_recycling_center.
  ///
  /// In en, this message translates to:
  /// **'Find recycling center'**
  String get find_recycling_center;

  /// No description provided for @info_title.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info_title;

  /// No description provided for @info_body.
  ///
  /// In en, this message translates to:
  /// **'This function is informational only for now.'**
  String get info_body;

  /// No description provided for @info_unavailable.
  ///
  /// In en, this message translates to:
  /// **'This function is not available yet.'**
  String get info_unavailable;

  /// No description provided for @info_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get info_ok;

  /// No description provided for @best_option_title.
  ///
  /// In en, this message translates to:
  /// **'Best option:'**
  String get best_option_title;

  /// No description provided for @other_options_title.
  ///
  /// In en, this message translates to:
  /// **'Other options'**
  String get other_options_title;

  /// No description provided for @action_details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get action_details;

  /// No description provided for @action_cta.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get action_cta;

  /// No description provided for @rescan.
  ///
  /// In en, this message translates to:
  /// **'Scan again'**
  String get rescan;

  /// No description provided for @no_match_title.
  ///
  /// In en, this message translates to:
  /// **'No match'**
  String get no_match_title;

  /// No description provided for @no_match_subtitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find a matching entry.'**
  String get no_match_subtitle;

  /// No description provided for @no_match_message.
  ///
  /// In en, this message translates to:
  /// **'The item could not be recognized.'**
  String get no_match_message;

  /// No description provided for @hint_text_mode_text.
  ///
  /// In en, this message translates to:
  /// **'Tip: Try a different spelling or a more general term.'**
  String get hint_text_mode_text;

  /// No description provided for @hint_text_mode_image.
  ///
  /// In en, this message translates to:
  /// **'Tip: More light, closer, calm background.'**
  String get hint_text_mode_image;

  /// No description provided for @hint_text_mode_unknown_1.
  ///
  /// In en, this message translates to:
  /// **'Tip: Check spelling or use a more general term.'**
  String get hint_text_mode_unknown_1;

  /// No description provided for @hint_text_mode_unknown_2.
  ///
  /// In en, this message translates to:
  /// **'Or: More light, closer, calm background.'**
  String get hint_text_mode_unknown_2;

  /// No description provided for @similar_suggestions.
  ///
  /// In en, this message translates to:
  /// **'Similar suggestions'**
  String get similar_suggestions;

  /// No description provided for @cta_search_adjust.
  ///
  /// In en, this message translates to:
  /// **'Adjust search'**
  String get cta_search_adjust;

  /// No description provided for @cta_retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get cta_retry;

  /// No description provided for @cta_enter_text.
  ///
  /// In en, this message translates to:
  /// **'Enter term'**
  String get cta_enter_text;

  /// No description provided for @cta_change_search.
  ///
  /// In en, this message translates to:
  /// **'Change search'**
  String get cta_change_search;

  /// No description provided for @warning_info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get warning_info;

  /// No description provided for @warning_warn.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning_warn;

  /// No description provided for @warning_danger.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning_danger;

  /// No description provided for @warning_battery.
  ///
  /// In en, this message translates to:
  /// **'Possible battery/electronics. Do not dispose in household trash.'**
  String get warning_battery;

  /// No description provided for @warning_electronics.
  ///
  /// In en, this message translates to:
  /// **'Electronics should not go into household trash.'**
  String get warning_electronics;

  /// No description provided for @item_battery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get item_battery;

  /// No description provided for @item_glass.
  ///
  /// In en, this message translates to:
  /// **'Glass bottle'**
  String get item_glass;

  /// No description provided for @item_cable.
  ///
  /// In en, this message translates to:
  /// **'Cable'**
  String get item_cable;

  /// No description provided for @item_plastic_packaging.
  ///
  /// In en, this message translates to:
  /// **'Plastic packaging'**
  String get item_plastic_packaging;

  /// No description provided for @action_donate_title.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get action_donate_title;

  /// No description provided for @action_sell_title.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get action_sell_title;

  /// No description provided for @action_repair_title.
  ///
  /// In en, this message translates to:
  /// **'Repair'**
  String get action_repair_title;

  /// No description provided for @action_reuse_title.
  ///
  /// In en, this message translates to:
  /// **'Reuse'**
  String get action_reuse_title;

  /// No description provided for @action_donate_desc.
  ///
  /// In en, this message translates to:
  /// **'Donate if in good condition.'**
  String get action_donate_desc;

  /// No description provided for @action_sell_desc.
  ///
  /// In en, this message translates to:
  /// **'Sell instead of throwing away.'**
  String get action_sell_desc;

  /// No description provided for @action_repair_desc.
  ///
  /// In en, this message translates to:
  /// **'Repair if possible.'**
  String get action_repair_desc;

  /// No description provided for @action_reuse_desc.
  ///
  /// In en, this message translates to:
  /// **'Use for a new purpose.'**
  String get action_reuse_desc;

  /// No description provided for @city_berlin.
  ///
  /// In en, this message translates to:
  /// **'Berlin'**
  String get city_berlin;

  /// No description provided for @city_hannover.
  ///
  /// In en, this message translates to:
  /// **'Hannover'**
  String get city_hannover;

  /// No description provided for @debug_json_title.
  ///
  /// In en, this message translates to:
  /// **'Analyze (Debug)'**
  String get debug_json_title;

  /// No description provided for @admin_title.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin_title;

  /// No description provided for @admin_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search by title or key'**
  String get admin_search_hint;

  /// No description provided for @admin_item_details.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get admin_item_details;

  /// No description provided for @admin_title_label.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get admin_title_label;

  /// No description provided for @admin_description_label.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get admin_description_label;

  /// No description provided for @admin_category_label.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get admin_category_label;

  /// No description provided for @admin_category_hint.
  ///
  /// In en, this message translates to:
  /// **'Codes, comma separated'**
  String get admin_category_hint;

  /// No description provided for @admin_disposal_label.
  ///
  /// In en, this message translates to:
  /// **'Disposals'**
  String get admin_disposal_label;

  /// No description provided for @admin_disposal_hint.
  ///
  /// In en, this message translates to:
  /// **'Codes, comma separated'**
  String get admin_disposal_hint;

  /// No description provided for @admin_warning_label.
  ///
  /// In en, this message translates to:
  /// **'Warnings'**
  String get admin_warning_label;

  /// No description provided for @admin_warning_hint.
  ///
  /// In en, this message translates to:
  /// **'Codes, comma separated'**
  String get admin_warning_hint;

  /// No description provided for @admin_active_label.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admin_active_label;

  /// No description provided for @admin_images_title.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get admin_images_title;

  /// No description provided for @admin_upload_image.
  ///
  /// In en, this message translates to:
  /// **'Upload image'**
  String get admin_upload_image;

  /// No description provided for @admin_remove_image.
  ///
  /// In en, this message translates to:
  /// **'Remove image'**
  String get admin_remove_image;

  /// No description provided for @admin_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get admin_save;

  /// No description provided for @admin_saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get admin_saving;

  /// No description provided for @admin_item_not_found.
  ///
  /// In en, this message translates to:
  /// **'Item not found.'**
  String get admin_item_not_found;

  /// No description provided for @admin_city_required.
  ///
  /// In en, this message translates to:
  /// **'Please select a city first.'**
  String get admin_city_required;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
