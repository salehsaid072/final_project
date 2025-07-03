import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'reset_password_dialog.dart';
import 'type_select.dart';
import 'form_fields.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final AuthService authService;
  final VoidCallback onSwitchMode;

  const AuthForm({
    super.key,
    required this.isLogin,
    required this.authService,
    required this.onSwitchMode,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedRole = 'employee';
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        if (widget.isLogin) {
          await _login();
        } else {
          await _signUp();
        }
      } catch (e) {
        _showError(e);
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _login() async {
    try {
      await widget.authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      // Get current user profile after login
      final user = await widget.authService.getCurrentUser();
      
      // Redirect based on user type
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          user.userType == 'buyer' ? '/buyer_home' : '/farmer_home',
          (route) => false,
        );
      }
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signUp() async {
    try {
      await widget.authService.signUpWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _firstNameController.text.trim(),
        address: _locationController.text.trim(),
        userType: _selectedRole,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent. Please check your inbox.'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Get current user profile after signup
        final user = await widget.authService.getCurrentUser();
        
        // Redirect based on user type
        Navigator.pushNamedAndRemoveUntil(
          context,
          user.userType == 'buyer' ? '/buyer_home' : '/farmer_home',
          (route) => false,
        );
      }
    } catch (e) {
      _showError(e);
    }
  }

  void _showError(dynamic error) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (!widget.isLogin) ...[
            FullNameField(
              controller: _firstNameController,
              isLogin: widget.isLogin,
            ),
            const SizedBox(height: 16),
            AddressField(
              controller: _locationController,
              isLogin: widget.isLogin,
            ),
            const SizedBox(height: 16),
          ],
          EmailField(controller: _emailController, isLogin: widget.isLogin),
          const SizedBox(height: 16),
          PasswordField(
            controller: _passwordController,
            isLogin: widget.isLogin,
          ),
          if (widget.isLogin) _buildForgotPassword(),
          if (!widget.isLogin) ...[
            const SizedBox(height: 16),
            RoleSelection(
              selectedRole: _selectedRole,
              onRoleChanged: (role) => setState(() => _selectedRole = role),
            ),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 24),
          _buildSubmitButton(),
          const SizedBox(height: 16),
          _buildSwitchModeButton(),
        ],
      ),
    );
  }

  Widget _buildForgotPassword() => Align(
    alignment: Alignment.centerRight,
    child: TextButton(
      onPressed:
          () => showDialog(
            context: context,
            builder: (context) => const PasswordResetDialog(),
          ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.only(right: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Text(
        'Forgot Password?',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 14,
          decoration: TextDecoration.none,
        ),
      ),
    ),
  );

  Widget _buildSubmitButton() => ElevatedButton(
    onPressed: _isLoading ? null : _submitForm,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      minimumSize: const Size(double.infinity, 50),
    ),
    child:
        _isLoading
            ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
            : Text(
              widget.isLogin ? 'Login' : 'Sign Up',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
  );

  Widget _buildSwitchModeButton() => TextButton(
    onPressed: widget.onSwitchMode,
    child: Text(
      widget.isLogin
          ? 'Don\'t have an account? Sign Up'
          : 'Already have an account? Login',
      style: const TextStyle(color: Colors.white, fontSize: 16),
    ),
  );

}