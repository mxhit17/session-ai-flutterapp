import 'package:flutter/material.dart';
import 'package:session.ai/features/auth/data/auth_repository.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/utils/storage/preference_manager.dart';
import '../../../core/widgets/app_sign_in_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final String _selectedRole = "SPEAKER";
  final AuthRepository _authRepository = AuthRepository();

  final _prefs = sl<PreferencesManager>();

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await _authRepository.register({
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
        "role": _selectedRole, // example: "SPEAKER"
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration successful")));

      // Store token
      // Save user data to preferences
      await _prefs.setAccessToken(response.token);
      // await _prefs.setRefreshToken(response.refreshToken); // no refresh token in current api
      await _prefs.setUserRoles([response.user.role]);
      await _prefs.setUserId(response.user.id);
      await _prefs.setUserName(response.user.fullName);

      // Navigate
      // Navigator.pushReplacement(...);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration failed")));
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
            constraints: const BoxConstraints(maxWidth: 460),
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
                      "Create Account",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Join the AI-assisted session platform",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 32),

                    /// NAME
                    const Text(
                      "Full Name",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration("Enter your full name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

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
                        "Create a password",
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
                        if (value == null || value.length < 6) {
                          return "Minimum 6 characters required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    /// CONFIRM PASSWORD
                    const Text(
                      "Confirm Password",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration("Confirm password").copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white60,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    // const SizedBox(height: 20),

                    /// ROLE DROPDOWN
                    // const Text("Role", style: TextStyle(color: Colors.white70)),
                    // const SizedBox(height: 8),
                    // DropdownButtonFormField<String>(
                    //   value: _selectedRole,
                    //   dropdownColor: const Color(0xFF1F2937),
                    //   style: const TextStyle(color: Colors.white),
                    //   decoration: _inputDecoration("Select role"),
                    //   items: const [
                    //     DropdownMenuItem(
                    //       value: "SPEAKER",
                    //       child: Text("Speaker"),
                    //     ),
                    //     DropdownMenuItem(
                    //       value: "ORGANIZER",
                    //       child: Text("Organizer"),
                    //     ),
                    //     DropdownMenuItem(
                    //       value: "REVIEWER",
                    //       child: Text("Reviewer"),
                    //     ),
                    //   ],
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _selectedRole = value!;
                    //     });
                    //   },
                    // ),
                    const SizedBox(height: 32),

                    /// REGISTER BUTTON
                    AppSignInButton(
                      label: "Register",
                      isLoading: _isLoading,
                      onPressed: _register,
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Already have an account? Sign In",
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
// import 'package:session.ai/features/auth/presentation/sign_in_view.dart';
// import 'package:session.ai/features/bottom_nav_bars/bottom_nav_bar_organizer.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   final ApiService _apiService = ApiService();

//   String _role = "Organiser"; // default role

//   bool _isLoading = false;

//   Future<void> _submit() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Registering...")));

//       try {
//         final response = await _apiService.register(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//           name: _nameController.text.trim(),
//           role: _role.toLowerCase(),
//         );

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               "Welcome, ${response.user.name}! Please verify your email.",
//             ),
//           ),
//         );

//         // Navigate to home or sign-in screen
//         // Navigator.pushReplacement(
//         //   context,
//         //   MaterialPageRoute(builder: (_) => const SignInScreen()),
//         // );
//       } catch (e) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Error: $e")));
//       } finally {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: const Text("Register")),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Card(
//             elevation: 6,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     Row(
//                       // mainAxisAlignment: MainAxisAlignment.end,
//                       // crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         IconButton(
//                           onPressed: () async {
//                             Navigator.pop(context);
//                           },
//                           icon: Icon(Icons.arrow_back_ios),
//                         ),
//                         const Text(
//                           "Create Account",
//                           style: TextStyle(
//                             fontSize: 26,
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

//                     // Name Field
//                     TextFormField(
//                       controller: _nameController,
//                       decoration: const InputDecoration(
//                         labelText: "Name",
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.person),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Please enter your name";
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),

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

//                     // Role Selection
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Select Role:",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: RadioListTile<String>(
//                                 value: "Organiser",
//                                 groupValue: _role,
//                                 title: const Text("Organiser"),
//                                 onChanged: (value) {
//                                   setState(() => _role = value!);
//                                 },
//                               ),
//                             ),
//                             Expanded(
//                               child: RadioListTile<String>(
//                                 value: "Speaker",
//                                 groupValue: _role,
//                                 title: const Text("Speaker"),
//                                 onChanged: (value) {
//                                   setState(() => _role = value!);
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),

//                     // Submit Button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _submit,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text(
//                           "Register",
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ),
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
