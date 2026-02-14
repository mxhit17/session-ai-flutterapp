import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:session.ai/core/auth/auth_notifier.dart';
import 'package:session.ai/features/auth/data/auth_repository.dart';
import 'package:session.ai/features/auth/presentation/register_user_view.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/utils/storage/preference_manager.dart';
import '../../../core/widgets/app_sign_in_button.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  final AuthRepository _authRepository = AuthRepository();

  final _prefs = sl<PreferencesManager>();

  void _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await _authRepository.signIn({
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
      });

      // 1️⃣ Save to storage (optional if your AuthNotifier handles it)
      await _prefs.setAccessToken(response.token);
      await _prefs.setUserRoles(response.user.roles);
      await _prefs.setUserId(response.user.id);
      await _prefs.setUserName(response.user.fullName);

      print("LOGIN CALLED");
      print(response.user.roles);
      print(identityHashCode(this));

      // 2️⃣ IMPORTANT: Update Riverpod state
      ref
          .read(authProvider.notifier)
          .login(response.token, response.user.roles);

      Navigator.of(context).pop();
      Navigator.of(context).pop();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Signed in successfully")));

      // 🚫 DO NOT Navigator.push here.
      // RootRouter will rebuild automatically.
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid credentials")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Color(0xFF0F172A),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Sign in to continue",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 32),

                    /// EMAIL
                    const Text(
                      "Email",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration("Enter your email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    /// PASSWORD
                    const Text(
                      "Password",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(
                        "Enter your password",
                      ).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white60,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    /// SIGN IN BUTTON
                    AppSignInButton(isLoading: _isLoading, onPressed: _signIn),

                    const SizedBox(height: 20),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Don't have an account? Register",
                          style: TextStyle(color: Color(0xFF3B82F6)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: const Color(0xFF111827),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:session.ai/api_service.dart';
// import 'package:session.ai/features/bottom_nav_bars/bottom_nav_bar_organizer.dart';
// import 'package:session.ai/features/auth/presentation/register_user_view.dart';
// import 'package:session.ai/features/bottom_nav_bars/bottom_nav_bar_speaker.dart';
// import 'package:session.ai/injection_container.dart';
// import 'package:session.ai/utils/storage/preference_manager.dart';

// class SignInScreen extends StatefulWidget {
//   const SignInScreen({super.key});

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final ApiService _apiService = ApiService();
//   final _prefs = sl<PreferencesManager>();

//   void _signIn() async {
//     if (_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Signing in...")));

//       try {
//         final response = await _apiService.signIn(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Welcome, ${response.user.name}")),
//         );

//         // Save user data to preferences
//         await _prefs.setAccessToken(response.accessToken);
//         await _prefs.setRefreshToken(response.refreshToken);
//         await _prefs.setUserType(response.user.role);
//         await _prefs.setUserId(response.user.id);
//         await _prefs.setUserName(response.user.name);

//         // Check user role and navigate accordingly
//         if (response.user.role.toLowerCase() == 'organiser') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const BottomNavBarOrganizer()),
//           );
//         } else if (response.user.role.toLowerCase() == 'speaker') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const BottomNavBarSpeaker()),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Unknown role. Please contact support."),
//             ),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(e.toString())));
//       }
//     }
//   }

//   void _goToRegister() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const RegisterScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Card(
//             elevation: 6,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       children: [
//                         const Text(
//                           "Sign In",
//                           style: TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Spacer(),
//                         InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => BottomNavBarOrganizer(),
//                               ),
//                             );
//                           },
//                           child: Row(
//                             children: [
//                               Text(
//                                 'Skip',
//                                 style: TextStyle(
//                                   color: Colors.blue,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Icon(
//                                 Icons.arrow_forward_ios,
//                                 color: Colors.blue,
//                                 size: 12,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),

//                     // Email Field
//                     TextFormField(
//                       controller: _emailController,
//                       decoration: const InputDecoration(
//                         labelText: "Email",
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.email),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Please enter your email";
//                         }
//                         if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                           return "Enter a valid email";
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     // Password Field
//                     TextFormField(
//                       controller: _passwordController,
//                       obscureText: true,
//                       decoration: const InputDecoration(
//                         labelText: "Password",
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.lock),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Please enter your password";
//                         }
//                         if (value.length < 6) {
//                           return "Password must be at least 6 characters";
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20),

//                     // Sign In Button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _signIn,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text(
//                           "Sign In",
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Register Option
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text("Don't have an account? "),
//                         GestureDetector(
//                           onTap: _goToRegister,
//                           child: const Text(
//                             "Register",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blue,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
