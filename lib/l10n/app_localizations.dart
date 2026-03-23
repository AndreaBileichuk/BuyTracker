import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('en'),
    Locale('uk'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In uk, this message translates to:
  /// **'Buy Tracker'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування'**
  String get settings;

  /// No description provided for @themeLight.
  ///
  /// In uk, this message translates to:
  /// **'Світла (Класика)'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In uk, this message translates to:
  /// **'Темна (Класика)'**
  String get themeDark;

  /// No description provided for @themeEmerald.
  ///
  /// In uk, this message translates to:
  /// **'Смарагд'**
  String get themeEmerald;

  /// No description provided for @themeSunset.
  ///
  /// In uk, this message translates to:
  /// **'Захід сонця'**
  String get themeSunset;

  /// No description provided for @appearance.
  ///
  /// In uk, this message translates to:
  /// **'Оформлення додатку'**
  String get appearance;

  /// No description provided for @language.
  ///
  /// In uk, this message translates to:
  /// **'Мова'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In uk, this message translates to:
  /// **'Вийти'**
  String get logout;

  /// No description provided for @reminders.
  ///
  /// In uk, this message translates to:
  /// **'Нагадування'**
  String get reminders;

  /// No description provided for @noReminders.
  ///
  /// In uk, this message translates to:
  /// **'У вас немає запланованих нагадувань'**
  String get noReminders;

  /// No description provided for @login.
  ///
  /// In uk, this message translates to:
  /// **'Вхід'**
  String get login;

  /// No description provided for @register.
  ///
  /// In uk, this message translates to:
  /// **'Реєстрація'**
  String get register;

  /// No description provided for @email.
  ///
  /// In uk, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In uk, this message translates to:
  /// **'Пароль'**
  String get password;

  /// No description provided for @termsOfUse.
  ///
  /// In uk, this message translates to:
  /// **'Умовами використання'**
  String get termsOfUse;

  /// No description provided for @privacyPolicy.
  ///
  /// In uk, this message translates to:
  /// **'Політикою конфіденційності'**
  String get privacyPolicy;

  /// No description provided for @forgotPassword.
  ///
  /// In uk, this message translates to:
  /// **'Забули пароль?'**
  String get forgotPassword;

  /// No description provided for @createList.
  ///
  /// In uk, this message translates to:
  /// **'Створити список'**
  String get createList;

  /// No description provided for @listName.
  ///
  /// In uk, this message translates to:
  /// **'Назва списку'**
  String get listName;

  /// No description provided for @items.
  ///
  /// In uk, this message translates to:
  /// **'Товари'**
  String get items;

  /// No description provided for @notesHint.
  ///
  /// In uk, this message translates to:
  /// **'Додайте нотатки до списку...'**
  String get notesHint;

  /// No description provided for @add.
  ///
  /// In uk, this message translates to:
  /// **'Додати'**
  String get add;

  /// No description provided for @save.
  ///
  /// In uk, this message translates to:
  /// **'Зберегти'**
  String get save;

  /// No description provided for @statistics.
  ///
  /// In uk, this message translates to:
  /// **'Статистика'**
  String get statistics;

  /// No description provided for @home.
  ///
  /// In uk, this message translates to:
  /// **'Головна'**
  String get home;

  /// No description provided for @lists.
  ///
  /// In uk, this message translates to:
  /// **'Списки'**
  String get lists;

  /// No description provided for @profile.
  ///
  /// In uk, this message translates to:
  /// **'Профіль'**
  String get profile;

  /// No description provided for @totalSpent.
  ///
  /// In uk, this message translates to:
  /// **'Всього витрачено'**
  String get totalSpent;

  /// No description provided for @activeLists.
  ///
  /// In uk, this message translates to:
  /// **'Активних списків'**
  String get activeLists;

  /// No description provided for @purchasedItems.
  ///
  /// In uk, this message translates to:
  /// **'Куплених товарів'**
  String get purchasedItems;

  /// No description provided for @startShopping.
  ///
  /// In uk, this message translates to:
  /// **'Почати покупки'**
  String get startShopping;

  /// No description provided for @myLists.
  ///
  /// In uk, this message translates to:
  /// **'Мої списки'**
  String get myLists;

  /// No description provided for @recentActivity.
  ///
  /// In uk, this message translates to:
  /// **'Недавня активність'**
  String get recentActivity;

  /// No description provided for @noActivity.
  ///
  /// In uk, this message translates to:
  /// **'Поки немає активності'**
  String get noActivity;

  /// No description provided for @viewAll.
  ///
  /// In uk, this message translates to:
  /// **'Всі'**
  String get viewAll;

  /// No description provided for @edit.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати'**
  String get edit;

  /// No description provided for @share.
  ///
  /// In uk, this message translates to:
  /// **'Поділитися'**
  String get share;

  /// No description provided for @delete.
  ///
  /// In uk, this message translates to:
  /// **'Видалити'**
  String get delete;

  /// No description provided for @areYouSure.
  ///
  /// In uk, this message translates to:
  /// **'Ви впевнені?'**
  String get areYouSure;

  /// No description provided for @yes.
  ///
  /// In uk, this message translates to:
  /// **'Так'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In uk, this message translates to:
  /// **'Ні'**
  String get no;

  /// No description provided for @cancel.
  ///
  /// In uk, this message translates to:
  /// **'Скасувати'**
  String get cancel;

  /// No description provided for @error.
  ///
  /// In uk, this message translates to:
  /// **'Помилка'**
  String get error;

  /// No description provided for @yourShoppingAssistant.
  ///
  /// In uk, this message translates to:
  /// **'Твій помічник у покупках'**
  String get yourShoppingAssistant;

  /// No description provided for @emailHint.
  ///
  /// In uk, this message translates to:
  /// **'your@email.com'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In uk, this message translates to:
  /// **'••••••••'**
  String get passwordHint;

  /// No description provided for @invalidCredential.
  ///
  /// In uk, this message translates to:
  /// **'Пароль або пошта неправильні'**
  String get invalidCredential;

  /// No description provided for @userNotFound.
  ///
  /// In uk, this message translates to:
  /// **'Користувача з такою адресою не знайдено'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In uk, this message translates to:
  /// **'Невірний пароль'**
  String get wrongPassword;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In uk, this message translates to:
  /// **'Невірний формат email'**
  String get invalidEmailFormat;

  /// No description provided for @userDisabled.
  ///
  /// In uk, this message translates to:
  /// **'Цей обліковий запис вимкнено'**
  String get userDisabled;

  /// No description provided for @tooManyRequests.
  ///
  /// In uk, this message translates to:
  /// **'Забагато спроб. Спробуйте пізніше'**
  String get tooManyRequests;

  /// No description provided for @networkRequestFailed.
  ///
  /// In uk, this message translates to:
  /// **'Помилка мережі. Перевірте з\'єднання'**
  String get networkRequestFailed;

  /// No description provided for @loginError.
  ///
  /// In uk, this message translates to:
  /// **'Помилка входу: '**
  String get loginError;

  /// No description provided for @enterEmailToReset.
  ///
  /// In uk, this message translates to:
  /// **'Введіть email для відновлення'**
  String get enterEmailToReset;

  /// No description provided for @failedToSendResetEmail.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося надіслати лист: '**
  String get failedToSendResetEmail;

  /// No description provided for @nameLabel.
  ///
  /// In uk, this message translates to:
  /// **'Ім\'я'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In uk, this message translates to:
  /// **'Ваше ім\'я'**
  String get nameHint;

  /// No description provided for @passwordMinHint.
  ///
  /// In uk, this message translates to:
  /// **'Мінімум 8 символів'**
  String get passwordMinHint;

  /// No description provided for @confirmPassword.
  ///
  /// In uk, this message translates to:
  /// **'Підтвердження пароля'**
  String get confirmPassword;

  /// No description provided for @repeatPasswordHint.
  ///
  /// In uk, this message translates to:
  /// **'Повторіть пароль'**
  String get repeatPasswordHint;

  /// No description provided for @iAgreeWith.
  ///
  /// In uk, this message translates to:
  /// **'Я погоджуюся з '**
  String get iAgreeWith;

  /// No description provided for @andLabel.
  ///
  /// In uk, this message translates to:
  /// **' та '**
  String get andLabel;

  /// No description provided for @signUp.
  ///
  /// In uk, this message translates to:
  /// **'Зареєструватись'**
  String get signUp;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In uk, this message translates to:
  /// **'Вже маєте акаунт?'**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In uk, this message translates to:
  /// **'Увійти'**
  String get signIn;

  /// No description provided for @nameCannotBeEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Ім\'я не може бути порожнім'**
  String get nameCannotBeEmpty;

  /// No description provided for @nameMinLength.
  ///
  /// In uk, this message translates to:
  /// **'Ім\'я має містити мінімум 2 символи'**
  String get nameMinLength;

  /// No description provided for @emailCannotBeEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Email не може бути порожнім'**
  String get emailCannotBeEmpty;

  /// No description provided for @passwordCannotBeEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Пароль не може бути порожнім'**
  String get passwordCannotBeEmpty;

  /// No description provided for @passwordMinLength.
  ///
  /// In uk, this message translates to:
  /// **'Пароль має містити мінімум 8 символів'**
  String get passwordMinLength;

  /// No description provided for @passwordMustContainLetters.
  ///
  /// In uk, this message translates to:
  /// **'Пароль має містити літери'**
  String get passwordMustContainLetters;

  /// No description provided for @passwordMustContainNumbers.
  ///
  /// In uk, this message translates to:
  /// **'Пароль має містити цифри'**
  String get passwordMustContainNumbers;

  /// No description provided for @confirmPasswordEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Підтвердіть пароль'**
  String get confirmPasswordEmpty;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In uk, this message translates to:
  /// **'Паролі не збігаються'**
  String get passwordsDoNotMatch;

  /// No description provided for @mustAgreeToTerms.
  ///
  /// In uk, this message translates to:
  /// **'Ви маєте погодитись з умовами використання'**
  String get mustAgreeToTerms;

  /// No description provided for @weakPassword.
  ///
  /// In uk, this message translates to:
  /// **'Пароль занадто слабкий'**
  String get weakPassword;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In uk, this message translates to:
  /// **'Ця електронна адреса вже використовується'**
  String get emailAlreadyInUse;

  /// No description provided for @operationNotAllowed.
  ///
  /// In uk, this message translates to:
  /// **'Реєстрацію через Email/Password не активовано'**
  String get operationNotAllowed;

  /// No description provided for @registerError.
  ///
  /// In uk, this message translates to:
  /// **'Помилка реєстрації: '**
  String get registerError;

  /// No description provided for @generalErrorPrefix.
  ///
  /// In uk, this message translates to:
  /// **'Виникла помилка: '**
  String get generalErrorPrefix;

  /// No description provided for @helloGlimpse.
  ///
  /// In uk, this message translates to:
  /// **'Привіт! 👋'**
  String get helloGlimpse;

  /// No description provided for @recentLists.
  ///
  /// In uk, this message translates to:
  /// **'Останні списки'**
  String get recentLists;

  /// No description provided for @noListsHere.
  ///
  /// In uk, this message translates to:
  /// **'Тут будуть ваші списки покупок'**
  String get noListsHere;

  /// No description provided for @errorOccurred.
  ///
  /// In uk, this message translates to:
  /// **'Помилка: '**
  String get errorOccurred;

  /// No description provided for @allLists.
  ///
  /// In uk, this message translates to:
  /// **'Всі списки'**
  String get allLists;

  /// No description provided for @yourShoppingLists.
  ///
  /// In uk, this message translates to:
  /// **'Ваші списки покупок'**
  String get yourShoppingLists;

  /// No description provided for @searchList.
  ///
  /// In uk, this message translates to:
  /// **'Шукати список...'**
  String get searchList;

  /// No description provided for @oopsSomethingWentWrong.
  ///
  /// In uk, this message translates to:
  /// **'Ой, щось пішло не так!'**
  String get oopsSomethingWentWrong;

  /// No description provided for @tryAgain.
  ///
  /// In uk, this message translates to:
  /// **'Спробувати ще раз'**
  String get tryAgain;

  /// No description provided for @noListsFoundCreateFirst.
  ///
  /// In uk, this message translates to:
  /// **'Списки не знайдено.\nСтворіть свій перший список!'**
  String get noListsFoundCreateFirst;

  /// No description provided for @enterListNameWarning.
  ///
  /// In uk, this message translates to:
  /// **'Введіть назву списку'**
  String get enterListNameWarning;

  /// No description provided for @creationError.
  ///
  /// In uk, this message translates to:
  /// **'Помилка створення: '**
  String get creationError;

  /// No description provided for @listNameHintExample.
  ///
  /// In uk, this message translates to:
  /// **'Наприклад: Продукти на тиждень'**
  String get listNameHintExample;

  /// No description provided for @chooseIcon.
  ///
  /// In uk, this message translates to:
  /// **'Виберіть іконку'**
  String get chooseIcon;

  /// No description provided for @notesOptional.
  ///
  /// In uk, this message translates to:
  /// **'Нотатки (необов\'язково)'**
  String get notesOptional;

  /// No description provided for @itemNameHint.
  ///
  /// In uk, this message translates to:
  /// **'Назва товару'**
  String get itemNameHint;

  /// No description provided for @quantityHint.
  ///
  /// In uk, this message translates to:
  /// **'Кількість'**
  String get quantityHint;

  /// No description provided for @pcs.
  ///
  /// In uk, this message translates to:
  /// **'шт'**
  String get pcs;

  /// No description provided for @createdAt.
  ///
  /// In uk, this message translates to:
  /// **'Створено: '**
  String get createdAt;

  /// No description provided for @purchased.
  ///
  /// In uk, this message translates to:
  /// **'Куплено'**
  String get purchased;

  /// No description provided for @spent.
  ///
  /// In uk, this message translates to:
  /// **'Витрачено'**
  String get spent;

  /// No description provided for @progress.
  ///
  /// In uk, this message translates to:
  /// **'Прогрес'**
  String get progress;

  /// No description provided for @remindBtn.
  ///
  /// In uk, this message translates to:
  /// **'Нагадати'**
  String get remindBtn;

  /// No description provided for @listEmptyAddSomething.
  ///
  /// In uk, this message translates to:
  /// **'Список порожній. Додайте щось!'**
  String get listEmptyAddSomething;

  /// No description provided for @priceLabel.
  ///
  /// In uk, this message translates to:
  /// **'Ціна: '**
  String get priceLabel;

  /// No description provided for @howMuchDidItCost.
  ///
  /// In uk, this message translates to:
  /// **'Скільки коштував\n'**
  String get howMuchDidItCost;

  /// No description provided for @enterAmount.
  ///
  /// In uk, this message translates to:
  /// **'Введіть суму'**
  String get enterAmount;

  /// No description provided for @confirm.
  ///
  /// In uk, this message translates to:
  /// **'Підтвердити'**
  String get confirm;

  /// No description provided for @addItemTitle.
  ///
  /// In uk, this message translates to:
  /// **'Додати товар'**
  String get addItemTitle;

  /// No description provided for @qtyShort.
  ///
  /// In uk, this message translates to:
  /// **'К-сть'**
  String get qtyShort;

  /// No description provided for @editItemTitle.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати товар'**
  String get editItemTitle;

  /// No description provided for @listNotFound.
  ///
  /// In uk, this message translates to:
  /// **'Список не знайдено'**
  String get listNotFound;

  /// No description provided for @editListTitle.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати список'**
  String get editListTitle;

  /// No description provided for @saveChanges.
  ///
  /// In uk, this message translates to:
  /// **'Зберегти зміни'**
  String get saveChanges;

  /// No description provided for @deleteListBtn.
  ///
  /// In uk, this message translates to:
  /// **'Видалити список'**
  String get deleteListBtn;

  /// No description provided for @shareJoinMessage.
  ///
  /// In uk, this message translates to:
  /// **'Приєднуйся до мого списку покупок в BuyTracker! \n'**
  String get shareJoinMessage;

  /// No description provided for @shareListDescription.
  ///
  /// In uk, this message translates to:
  /// **'Надішліть це посилання, щоб редагувати список разом з друзями.'**
  String get shareListDescription;

  /// No description provided for @linkTitle.
  ///
  /// In uk, this message translates to:
  /// **'Посилання'**
  String get linkTitle;

  /// No description provided for @linkCopiedMsg.
  ///
  /// In uk, this message translates to:
  /// **'Посилання скопійовано!'**
  String get linkCopiedMsg;

  /// No description provided for @sendInviteBtn.
  ///
  /// In uk, this message translates to:
  /// **'Надіслати запрошення'**
  String get sendInviteBtn;

  /// No description provided for @profileInfo.
  ///
  /// In uk, this message translates to:
  /// **'Інформація'**
  String get profileInfo;

  /// No description provided for @profileName.
  ///
  /// In uk, this message translates to:
  /// **'Ім\'я'**
  String get profileName;

  /// No description provided for @profileRegDate.
  ///
  /// In uk, this message translates to:
  /// **'Дата реєстрації'**
  String get profileRegDate;

  /// No description provided for @profileUnknownDate.
  ///
  /// In uk, this message translates to:
  /// **'Невідома'**
  String get profileUnknownDate;

  /// No description provided for @profileActions.
  ///
  /// In uk, this message translates to:
  /// **'Дії'**
  String get profileActions;

  /// No description provided for @profileReminders.
  ///
  /// In uk, this message translates to:
  /// **'Нагадування'**
  String get profileReminders;

  /// No description provided for @profileSettings.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування'**
  String get profileSettings;

  /// No description provided for @profileLogout.
  ///
  /// In uk, this message translates to:
  /// **'Вийти'**
  String get profileLogout;

  /// No description provided for @costAnalytics.
  ///
  /// In uk, this message translates to:
  /// **'Аналітика витрат'**
  String get costAnalytics;

  /// No description provided for @changeBtn.
  ///
  /// In uk, this message translates to:
  /// **'Змінити'**
  String get changeBtn;

  /// No description provided for @totalExpenses.
  ///
  /// In uk, this message translates to:
  /// **'Загальні витрати'**
  String get totalExpenses;

  /// No description provided for @noDataForPeriod.
  ///
  /// In uk, this message translates to:
  /// **'Немає даних за цей період'**
  String get noDataForPeriod;

  /// No description provided for @listsCreated.
  ///
  /// In uk, this message translates to:
  /// **'Створено списків'**
  String get listsCreated;

  /// No description provided for @itemsBought.
  ///
  /// In uk, this message translates to:
  /// **'Куплено товарів'**
  String get itemsBought;

  /// No description provided for @periodFrom.
  ///
  /// In uk, this message translates to:
  /// **'з '**
  String get periodFrom;

  /// No description provided for @periodTo.
  ///
  /// In uk, this message translates to:
  /// **' по '**
  String get periodTo;

  /// No description provided for @createReminder.
  ///
  /// In uk, this message translates to:
  /// **'Створити нагадування'**
  String get createReminder;

  /// No description provided for @shoppingListLabel.
  ///
  /// In uk, this message translates to:
  /// **'Список покупок'**
  String get shoppingListLabel;

  /// No description provided for @reminderTextLabel.
  ///
  /// In uk, this message translates to:
  /// **'Текст нагадування'**
  String get reminderTextLabel;

  /// No description provided for @scheduledFor.
  ///
  /// In uk, this message translates to:
  /// **'Заплановано на: '**
  String get scheduledFor;

  /// No description provided for @timeNotSelected.
  ///
  /// In uk, this message translates to:
  /// **'Час не вибрано'**
  String get timeNotSelected;

  /// No description provided for @selectTimeBtn.
  ///
  /// In uk, this message translates to:
  /// **'Вибрати час'**
  String get selectTimeBtn;

  /// No description provided for @enterTextTimeList.
  ///
  /// In uk, this message translates to:
  /// **'Введіть текст, оберіть час і список'**
  String get enterTextTimeList;

  /// No description provided for @timeMustBeFuture.
  ///
  /// In uk, this message translates to:
  /// **'Час нагадування має бути в майбутньому'**
  String get timeMustBeFuture;

  /// No description provided for @reminderPrefix.
  ///
  /// In uk, this message translates to:
  /// **'Нагадування: '**
  String get reminderPrefix;

  /// No description provided for @updatedAt.
  ///
  /// In uk, this message translates to:
  /// **'Оновлено '**
  String get updatedAt;

  /// No description provided for @itemsOfTotal.
  ///
  /// In uk, this message translates to:
  /// **'{purchased} з {total} товарів'**
  String itemsOfTotal(String purchased, String total);

  /// No description provided for @currencyLabel.
  ///
  /// In uk, this message translates to:
  /// **'грн'**
  String get currencyLabel;

  /// No description provided for @unitPcs.
  ///
  /// In uk, this message translates to:
  /// **'шт'**
  String get unitPcs;

  /// No description provided for @unitKg.
  ///
  /// In uk, this message translates to:
  /// **'кг'**
  String get unitKg;

  /// No description provided for @unitG.
  ///
  /// In uk, this message translates to:
  /// **'г'**
  String get unitG;

  /// No description provided for @unitL.
  ///
  /// In uk, this message translates to:
  /// **'л'**
  String get unitL;

  /// No description provided for @unitMl.
  ///
  /// In uk, this message translates to:
  /// **'мл'**
  String get unitMl;

  /// No description provided for @unitPack.
  ///
  /// In uk, this message translates to:
  /// **'уп'**
  String get unitPack;

  /// No description provided for @unitCan.
  ///
  /// In uk, this message translates to:
  /// **'бан'**
  String get unitCan;

  /// No description provided for @creationErrorMsg.
  ///
  /// In uk, this message translates to:
  /// **'Помилка створення: '**
  String get creationErrorMsg;

  /// No description provided for @shoppingRemindersChannel.
  ///
  /// In uk, this message translates to:
  /// **'Нагадування про покупки'**
  String get shoppingRemindersChannel;

  /// No description provided for @shoppingRemindersDesc.
  ///
  /// In uk, this message translates to:
  /// **'Сповіщення для нагадування про списки покупок'**
  String get shoppingRemindersDesc;

  /// No description provided for @langUkrainian.
  ///
  /// In uk, this message translates to:
  /// **'Українська 🇺🇦'**
  String get langUkrainian;

  /// No description provided for @langEnglish.
  ///
  /// In uk, this message translates to:
  /// **'English 🇬🇧'**
  String get langEnglish;
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
      <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
