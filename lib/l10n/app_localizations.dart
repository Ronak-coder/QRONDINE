import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  // Helper method to access AppLocalizations from context
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Load the language JSON file from assets
  Future<bool> load() async {
    String jsonString = await rootBundle
        .loadString('lib/l10n/app_${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // Method to get translated string
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Convenience getters for common strings
  String get appName => translate('app_name');
  String get welcome => translate('welcome');
  String get login => translate('login');
  String get signup => translate('signup');
  String get email => translate('email');
  String get password => translate('password');
  String get confirmPassword => translate('confirm_password');
  String get fullName => translate('full_name');
  String get phone => translate('phone');
  String get forgotPassword => translate('forgot_password');
  String get dontHaveAccount => translate('dont_have_account');
  String get alreadyHaveAccount => translate('already_have_account');
  String get continueAsGuest => translate('continue_as_guest');
  String get or => translate('or');
  
  String get home => translate('home');
  String get categories => translate('categories');
  String get cart => translate('cart');
  String get profile => translate('profile');
  String get notifications => translate('notifications');
  
  String get search => translate('search');
  String get searchProducts => translate('search_products');
  String get filter => translate('filter');
  String get sort => translate('sort');
  
  String get featuredProducts => translate('featured_products');
  String get newArrivals => translate('new_arrivals');
  String get bestSellers => translate('best_sellers');
  String get specialOffers => translate('special_offers');
  String get viewAll => translate('view_all');
  
  String get productDetails => translate('product_details');
  String get description => translate('description');
  String get specifications => translate('specifications');
  String get reviews => translate('reviews');
  String get addToCart => translate('add_to_cart');
  String get buyNow => translate('buy_now');
  String get price => translate('price');
  String get quantity => translate('quantity');
  String get inStock => translate('in_stock');
  String get outOfStock => translate('out_of_stock');
  
  String get myCart => translate('my_cart');
  String get cartEmpty => translate('cart_empty');
  String get subtotal => translate('subtotal');
  String get shipping => translate('shipping');
  String get total => translate('total');
  String get proceedToCheckout => translate('proceed_to_checkout');
  String get remove => translate('remove');
  
  String get checkout => translate('checkout');
  String get shippingAddress => translate('shipping_address');
  String get paymentMethod => translate('payment_method');
  String get orderSummary => translate('order_summary');
  String get placeOrder => translate('place_order');
  String get cashOnDelivery => translate('cash_on_delivery');
  String get cardPayment => translate('card_payment');
  
  String get myOrders => translate('my_orders');
  String get orderHistory => translate('order_history');
  String get orderId => translate('order_id');
  String get orderDate => translate('order_date');
  String get orderStatus => translate('order_status');
  String get orderTotal => translate('order_total');
  String get trackOrder => translate('track_order');
  
  String get myProfile => translate('my_profile');
  String get editProfile => translate('edit_profile');
  String get settings => translate('settings');
  String get language => translate('language');
  String get changeLanguage => translate('change_language');
  String get english => translate('english');
  String get hindi => translate('hindi');
  String get theme => translate('theme');
  String get darkMode => translate('dark_mode');
  String get lightMode => translate('light_mode');
  String get logout => translate('logout');
  
  String get notificationsTitle => translate('notifications_title');
  String get markAllRead => translate('mark_all_read');
  String get clearAll => translate('clear_all');
  String get noNotifications => translate('no_notifications');
  
  String get save => translate('save');
  String get cancel => translate('cancel');
  String get ok => translate('ok');
  String get yes => translate('yes');
  String get no => translate('no');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get update => translate('update');
  String get submit => translate('submit');
  String get confirm => translate('confirm');
  
  String get error => translate('error');
  String get success => translate('success');
  String get warning => translate('warning');
  String get info => translate('info');
}

// LocalizationsDelegate for AppLocalizations
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Support English and Hindi
    return ['en', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
