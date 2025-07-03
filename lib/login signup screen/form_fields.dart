import 'package:flutter/material.dart';

class FullNameField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLogin;

  const FullNameField({
    super.key,
    required this.controller,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Full Name',
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.person, color: Colors.white70),
      ),
      validator: (value) {
        if (!isLogin && (value == null || value.isEmpty)) {
          return 'Please enter your full name';
        }
        return null;
      },
    );
  }
}

class AddressField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLogin;

  const AddressField({
    super.key,
    required this.controller,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Address',
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(
          Icons.location_on_outlined,
          color: Colors.white70,
        ),
      ),
      validator: (value) {
        if (!isLogin && (value == null || value.isEmpty)) {
          return 'Please enter your address';
        }
        return null;
      },
    );
  }
}

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLogin;

  const EmailField({
    super.key,
    required this.controller,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final bool isLogin;

  const PasswordField({
    super.key,
    required this.controller,
    this.labelText,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      obscureText: true,
      decoration: InputDecoration(
        hintText: labelText ?? 'Password',
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (!isLogin && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}