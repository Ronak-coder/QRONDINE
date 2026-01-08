import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user.dart';
import '../services/firebase_auth_service.dart';
import '../services/storage_service.dart';
import '../config/constants.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    // Listen to Firebase auth state changes
    _firebaseAuthService.authStateChanges.listen(_onAuthStateChanged);
  }

  // Initialize - check for saved auth and listen to Firebase auth state
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Check if user is already logged in via Firebase
      final firebaseUser = _firebaseAuthService.currentUser;
      
      if (firebaseUser != null) {
        // Load user data from storage or create from Firebase user
        final userData = StorageService.getJson(AppConstants.userDataKey);
        
        if (userData != null) {
          _user = User.fromJson(userData);
        } else {
          // Create user from Firebase data
          _user = _mapFirebaseUserToAppUser(firebaseUser);
          await StorageService.saveJson(AppConstants.userDataKey, _user!.toJson());
        }
      }
    } catch (e) {
      _error = 'Failed to restore session';
      if (kDebugMode) {
        print('Auth initialization error: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // Handle Firebase auth state changes
  void _onAuthStateChanged(firebase_auth.User? firebaseUser) {
    if (firebaseUser == null) {
      // User signed out
      _user = null;
      StorageService.remove(AppConstants.userDataKey);
    } else {
      // User signed in, update local user
      final userData = StorageService.getJson(AppConstants.userDataKey);
      if (userData != null) {
        _user = User.fromJson(userData);
      } else {
        _user = _mapFirebaseUserToAppUser(firebaseUser);
        StorageService.saveJson(AppConstants.userDataKey, _user!.toJson());
      }
    }
    notifyListeners();
  }

  // Login with Firebase
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _firebaseAuthService.signInWithEmailPassword(
        email: email,
        password: password,
      );

      if (result['success'] == true) {
        final firebaseUser = result['user'] as firebase_auth.User;
        _user = _mapFirebaseUserToAppUser(firebaseUser);
        
        // Save to storage
        await StorageService.saveJson(AppConstants.userDataKey, _user!.toJson());
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _error = result['message'] ?? 'Login failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An error occurred during login';
      if (kDebugMode) {
        print('Login error: $e');
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign up with Firebase
  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _firebaseAuthService.signUpWithEmailPassword(
        email: email,
        password: password,
        name: name,
      );

      if (result['success'] == true) {
        final firebaseUser = result['user'] as firebase_auth.User;
        _user = _mapFirebaseUserToAppUser(firebaseUser);
        
        // Save to storage
        await StorageService.saveJson(AppConstants.userDataKey, _user!.toJson());
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _error = result['message'] ?? 'Sign up failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An error occurred during sign up';
      if (kDebugMode) {
        print('Signup error: $e');
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout from Firebase
  Future<void> logout() async {
    _user = null;
    _error = null;
    
    // Clear storage
    await StorageService.remove(AppConstants.userDataKey);
    
    // Sign out from Firebase
    await _firebaseAuthService.signOut();
    
    notifyListeners();
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _firebaseAuthService.sendPasswordResetEmail(email);
      
      _error = result['success'] == true ? null : result['message'];
      _isLoading = false;
      notifyListeners();
      
      return result['success'] == true;
    } catch (e) {
      _error = 'An error occurred. Please try again.';
      if (kDebugMode) {
        print('Password reset error: $e');
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _firebaseAuthService.signInWithGoogle();

      if (result['success'] == true) {
        final firebaseUser = result['user'] as firebase_auth.User;
        _user = _mapFirebaseUserToAppUser(firebaseUser);
        
        // Save to storage
        await StorageService.saveJson(AppConstants.userDataKey, _user!.toJson());
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _error = result['message'] ?? 'Google sign in failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An error occurred during Google sign in';
      if (kDebugMode) {
        print('Google sign in error: $e');
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign in with Apple
  Future<bool> signInWithApple() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _firebaseAuthService.signInWithApple();

      if (result['success'] == true) {
        final firebaseUser = result['user'] as firebase_auth.User;
        _user = _mapFirebaseUserToAppUser(firebaseUser);
        
        // Save to storage
        await StorageService.saveJson(AppConstants.userDataKey, _user!.toJson());
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _error = result['message'] ?? 'Apple sign in failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An error occurred during Apple sign in';
      if (kDebugMode) {
        print('Apple sign in error: $e');
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update user
  void updateUser(User user) {
    _user = user;
    StorageService.saveJson(AppConstants.userDataKey, user.toJson());
    notifyListeners();
  }

  // Map Firebase User to App User model
  User _mapFirebaseUserToAppUser(firebase_auth.User firebaseUser) {
    return User(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? 'User',
      email: firebaseUser.email ?? '',
      phone: firebaseUser.phoneNumber ?? '',
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );
  }
}
