import 'package:flutter/material.dart';
import 'signup_screen.dart';
import '../services/backend_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskMaster', style: TextStyle(fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.white)),
        backgroundColor: Colors.teal, // Updated color for a modern look
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildUsernameTextField(),
              const SizedBox(height: 20.0),
              _buildPasswordTextField(),
              const SizedBox(height: 20.0),
              _buildLoginButton(),
              const SizedBox(height: 10.0),
              if (_errorMessage != null) _buildErrorMessage(),
              const SizedBox(height: 20.0),
              _buildSignUpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameTextField() {
    return TextFormField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: 'Username',
        labelStyle: const TextStyle(fontFamily: 'Roboto'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(fontFamily: 'Roboto'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal, // Teal background for a vibrant look
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
      ),
      child: const Text(
        'LOGIN',
        style: TextStyle(
          color: Colors.white, // Set text color to white for better visibility
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        _errorMessage!,
        style: const TextStyle(color: Colors.red, fontFamily: 'Roboto'),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return OutlinedButton(
      onPressed: _navigateToSignUpScreen,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.teal, // Text color
        side: const BorderSide(color: Colors.teal), // Border color
      ),
      child: const Text(
        'New User? Sign up!',
        style: TextStyle(fontFamily: 'Roboto'),
      ),
    );
  }

  void _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showErrorMessage("Username and password are mandatory.");
      return;
    }

    try {
      final String? token = await BackendService.login(username, password);
      if (token != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showErrorMessage("Invalid username or password.");
      }
    } catch (error) {
      _showErrorMessage("Invalid username or password.");
    }
  }

  void _showErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  void _navigateToSignUpScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }
}