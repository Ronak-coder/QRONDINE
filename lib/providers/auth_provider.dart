import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../config/constants.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _authToken;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  String? get authToken => _authToken;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null && _authToken != null;

  // Initialize - check for saved auth
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = StorageService.getString(AppConstants.authTokenKey);
      final userData = StorageService.getJson(AppConstants.userDataKey);

      if (token != null && userData != null) {
        _authToken = token;
        _user = User.fromJson(userData);
        ApiService.setAuthToken(token);
      }
    } catch (e) {
      _error = 'Failed to restore session';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.login(email, password);
      
      if (response['success'] == true) {
        final data = response['data'];
        _authToken = data['token'];
        _user = User.fromJson(data['user']);
        
        // Save to storage
        await StorageService.saveString(AppConstants.authTokenKey, _authToken!);
        await StorageService.saveJson(AppConstants.userDataKey, _user!.toJson());
        
        ApiService.setAuthToken(_authToken);
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _error = response['message'] ?? 'Login failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An error occurred during login';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign up
  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.signup(name, email, password);
      
      if (response['success'] == true) {
        final data = response['data'];
        _authToken = data['token'];
        _user = User.fromJson(data['user']);
        
        // Save to storage
        await StorageService.saveString(AppConstants.authTokenKey, _authToken!);
        await StorageService.saveJson(AppConstants.userDataKey, _user!.toJson());
        
        ApiService.setAuthToken(_authToken);
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _error = response['message'] ?? 'Sign up failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An error occurred during sign up';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _user = null;
    _authToken = null;
    _error = null;
    
    // Clear storage
    await StorageService.remove(AppConstants.authTokenKey);
    await StorageService.remove(AppConstants.userDataKey);
    
    ApiService.setAuthToken(null);
    
    notifyListeners();
  }

  // Update user
  void updateUser(User user) {
    _user = user;
    StorageService.saveJson(AppConstants.userDataKey, user.toJson());
    notifyListeners();
  }
}
