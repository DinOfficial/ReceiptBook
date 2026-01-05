import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceSettingsProvider extends ChangeNotifier {
  static const String _templateKey = 'invoice_template';

  // Available templates
  static const String TEMPLATE_CLASSIC = 'classic';
  static const String TEMPLATE_MODERN = 'modern';
  static const String TEMPLATE_MINIMAL = 'minimal';
  static const String TEMPLATE_PROFESSIONAL = 'professional';

  String _selectedTemplate = TEMPLATE_CLASSIC;

  String get selectedTemplate => _selectedTemplate;

  // Payment Methods
  static const String _paymentMethodsKey = 'payment_methods';
  List<String> _paymentMethods = [
    'Bank Transfer',
    'Deposit',
    'Mobile Banking',
    'Card Payment',
    'Others',
  ];

  List<String> get paymentMethods => _paymentMethods;

  InvoiceSettingsProvider() {
    _loadTemplate();
    _loadPaymentMethods();
  }

  Future<void> _loadTemplate() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedTemplate = prefs.getString(_templateKey) ?? TEMPLATE_CLASSIC;
    notifyListeners();
  }

  Future<void> _loadPaymentMethods() async {
    final prefs = await SharedPreferences.getInstance();
    _paymentMethods =
        prefs.getStringList(_paymentMethodsKey) ?? _paymentMethods;
    notifyListeners();
  }

  Future<void> addPaymentMethod(String method) async {
    if (!_paymentMethods.contains(method)) {
      _paymentMethods.add(method);
      notifyListeners();
      _savePaymentMethods();
    }
  }

  Future<void> removePaymentMethod(String method) async {
    _paymentMethods.remove(method);
    notifyListeners();
    _savePaymentMethods();
  }

  Future<void> _savePaymentMethods() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_paymentMethodsKey, _paymentMethods);
  }

  Future<void> setTemplate(String template) async {
    _selectedTemplate = template;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_templateKey, template);
  }

  String getTemplateName(String template) {
    switch (template) {
      case TEMPLATE_CLASSIC:
        return 'Classic';
      case TEMPLATE_MODERN:
        return 'Modern';
      case TEMPLATE_MINIMAL:
        return 'Minimal';
      case TEMPLATE_PROFESSIONAL:
        return 'Professional';
      default:
        return 'Classic';
    }
  }

  String getTemplateDescription(String template) {
    switch (template) {
      case TEMPLATE_CLASSIC:
        return 'Traditional invoice layout with clean lines';
      case TEMPLATE_MODERN:
        return 'Contemporary design with bold colors';
      case TEMPLATE_MINIMAL:
        return 'Simple and elegant minimal design';
      case TEMPLATE_PROFESSIONAL:
        return 'Corporate-style professional template';
      default:
        return '';
    }
  }
}
