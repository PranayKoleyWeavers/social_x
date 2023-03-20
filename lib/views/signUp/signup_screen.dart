import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_x/constants/appcolor.dart';
import 'package:social_x/constants/images.dart';
import 'package:social_x/services/app_service.dart';
import 'package:social_x/services/app_service.dart';
import 'package:social_x/views/home/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLogIn = true;
  bool isSignUp = false;
  bool checkBox = false;
  bool isRegister = false;
  bool isSignIn = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Country? _selectedCountry;

  //PASSWORD VALIDATION FUNCTION
  final RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");

  final RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  //PASSWORD VALIDATION
  bool validateEmail(String pass) {
    String email = pass.trim();
    if (emailValid.hasMatch(email)) {
      return true;
    } else {
      return false;
    }
  }

  //PASSWORD VALIDATION
  bool validatePassword(String pass) {
    String password = pass.trim();
    if (passValid.hasMatch(password)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    initCountry();
  }

  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    super.dispose();
  }

  void initCountry() async {
    final country = await getDefaultCountry(context);
    setState(() {
      _selectedCountry = country;
    });
  }

  void _showCountryPicker() async {
    final country = await showCountryPickerSheet(
      heightFactor: 0.8,
      cancelWidget: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(
                right: 15,
                top: 10,
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
      context,
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Scaffold(
        backgroundColor: AppColor.grey,
        //****APPBAR */
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.redTheme,
          title: const Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 22,
              ),
              text: 'Social ',
              children: [
                TextSpan(
                  text: 'X',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                )
              ],
            ),
          ),
        ),

        //****BODY */
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              fillOverscroll: true,
              hasScrollBody: false,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        border: Border.all(color: AppColor.redTheme, width: 1),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //****LOGIN HEADDING */
                          GestureDetector(
                            onTap: () {
                              isLogIn = true;
                              isSignUp = false;
                              setState(() {});
                            },
                            child: Container(
                              height: 50,
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 1,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                                color: isLogIn
                                    ? AppColor.redTheme
                                    : AppColor.white,
                              ),
                              child: Center(
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    color: isLogIn
                                        ? AppColor.white
                                        : AppColor.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // //****SIGNUP HEADDING */
                          GestureDetector(
                            onTap: () {
                              isSignUp = true;
                              isLogIn = false;
                              setState(() {});
                            },
                            child: Container(
                              height: 50,
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 1,
                              decoration: BoxDecoration(
                                // border: Border(
                                //   bottom: BorderSide(color: AppColor.redTheme),
                                // ),
                                color: isSignUp
                                    ? AppColor.redTheme
                                    : AppColor.white,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                    color: isSignUp
                                        ? AppColor.white
                                        : AppColor.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    isLogIn || !isRegister
                        ? logInContainer()
                        : signUpContainer(),
                    Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          isLogIn
                              ? await AuthService().logInOperation(
                                  context: context,
                                  password: passwordController.text,
                                  email: emailController.text)
                              : await AuthService().signUpOperation(
                                  context: context,
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                        }
                        if (!mounted) return;
                        emailController.clear();
                        passwordController.clear();
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColor.redTheme,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            isLogIn ? 'LOGIN' : 'REGISTER',
                            style: TextStyle(
                              color: AppColor.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget logInContainer() {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(30),
        ),
        // margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),

            //****SIGNIN YOUR ACCOUNT TEXT */
            Text(
              'SignIn into your\n Account',
              style: TextStyle(
                fontSize: 22,
                color: AppColor.redTheme,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            const Text(
              'Email',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //****EMAIL FIELD */
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter email';
                } else {
                  bool result = validateEmail(value);
                  if (result) {
                    // create account event
                    return null;
                  } else {
                    return "Invalid email ID";
                  }
                }
              },
              controller: emailController,
              decoration: InputDecoration(
                suffixIconConstraints: const BoxConstraints(maxHeight: 25),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                // border: InputBorder.none,
                hintText: '  johndoe@gmail.com',
                hintStyle: const TextStyle(
                  fontSize: 20,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    transform: Matrix4.translationValues(1.0, -2.0, 0.0),
                    child: Icon(
                      size: 25,
                      Icons.email,
                      color: AppColor.redTheme,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Password',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //****PASSWORD FIELD */
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter password';
                } else {
                  bool result = validatePassword(value);
                  if (result) {
                    // create account event
                    return null;
                  } else {
                    return "Should contain Capital, small letter, Number & Special character";
                  }
                }
              },
              controller: passwordController,
              decoration: InputDecoration(
                suffixIconConstraints: const BoxConstraints(maxHeight: 25),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                // border: InputBorder.none,
                hintText: '  Password',
                hintStyle: const TextStyle(
                  fontSize: 20,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    transform: Matrix4.translationValues(1.0, -2.0, 0.0),
                    child: Icon(
                      size: 25,
                      Icons.lock_outline,
                      color: AppColor.redTheme,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //****FORGOT PASS */
            Align(
              alignment: Alignment.topRight,
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColor.redTheme,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            //****LOGIN WITH TEXT */
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Login with',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColor.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //***GOOGLE ICON */
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      border: Border.all(color: AppColor.black, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.asset(
                      StringImage.googleIcon,
                      height: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),

                  //***FACEBOOK ICON */
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 8, 94, 165),
                      border: Border.all(color: AppColor.black, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.asset(
                      StringImage.fbIcon,
                      height: 20,
                      color: AppColor.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text.rich(
                TextSpan(text: 'Don\'t have an Account?', children: [
                  TextSpan(
                    text: ' Register Now',
                    style: TextStyle(
                      color: AppColor.redTheme,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        isSignUp = true;
                        isRegister = true;
                        isLogIn = false;

                        setState(() {});
                      },
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget signUpContainer() {
    return Expanded(
      child: Container(
        // height: 500,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(30),
        ),
        // margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),

            //****SIGNIN YOUR ACCOUNT TEXT */
            Text(
              'Create an\nAccount',
              style: TextStyle(
                fontSize: 22,
                color: AppColor.redTheme,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //****NAME TEXT */
            const Text(
              'Name',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //****NAME FIELD */
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                suffixIconConstraints: const BoxConstraints(maxHeight: 25),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                // border: InputBorder.none,
                hintText: '  John doe',
                hintStyle: const TextStyle(
                  fontSize: 20,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    transform: Matrix4.translationValues(1.0, -2.0, 0.0),
                    child: Icon(
                      size: 25,
                      Icons.person,
                      color: AppColor.redTheme,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            const SizedBox(
              height: 10,
            ),
            const Text(
              'Email',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //****EMAIL FIELD */
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter email';
                } else {
                  bool result = validateEmail(value);
                  if (result) {
                    // create account event
                    return null;
                  } else {
                    return "Invalid email ID";
                  }
                }
              },
              controller: emailController,
              decoration: InputDecoration(
                suffixIconConstraints: const BoxConstraints(maxHeight: 25),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                // border: InputBorder.none,
                hintText: '  johndoe@gmail.com',
                hintStyle: const TextStyle(
                  fontSize: 20,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    transform: Matrix4.translationValues(1.0, -2.0, 0.0),
                    child: Icon(
                      size: 25,
                      Icons.email,
                      color: AppColor.redTheme,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            const Text(
              'Contact no',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //****PHONE FIELD */
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _showCountryPicker();
                  },
                  child: Row(
                    children: [
                      _selectedCountry == null
                          ? const SizedBox()
                          : Image.asset(
                              _selectedCountry!.flag,
                              package: countryCodePackageName,
                              width: 20,
                              height: 20,
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        _selectedCountry == null
                            ? ''
                            : _selectedCountry!.countryCode,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 16,
                              color: AppColor.black,
                            ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        _selectedCountry == null
                            ? ''
                            : _selectedCountry!.callingCode,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 16,
                              color: AppColor.black,
                            ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Image.asset(
                          StringImage.dropdown,
                          height: 10,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),

                //****PHONE FIELD */
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      suffixIconConstraints:
                          const BoxConstraints(maxHeight: 25),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      // border: InputBorder.none,
                      hintText: '  9876543210',
                      hintStyle: const TextStyle(
                        fontSize: 20,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Container(
                          transform: Matrix4.translationValues(1.0, -2.0, 0.0),
                          child: Icon(
                            size: 25,
                            Icons.phone,
                            color: AppColor.redTheme,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Password',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //****PASSWORD FIELD */
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter password';
                } else {
                  bool result = validatePassword(value);
                  if (result) {
                    // create account event
                    return null;
                  } else {
                    return "Should contain Capital, small letter, Number & Special character";
                  }
                }
              },
              controller: passwordController,
              decoration: InputDecoration(
                suffixIconConstraints: const BoxConstraints(maxHeight: 25),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                // border: InputBorder.none,
                hintText: '  ********',
                hintStyle: const TextStyle(
                  fontSize: 20,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    transform: Matrix4.translationValues(1.0, -2.0, 0.0),
                    child: Icon(
                      size: 25,
                      Icons.lock_outline,
                      color: AppColor.redTheme,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: AppColor.redTheme, // Your color
                    ),
                    child: Checkbox(
                      activeColor: AppColor.redTheme,
                      value: checkBox,
                      onChanged: (value) {
                        setState(() {
                          checkBox = !checkBox;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text.rich(
                    TextSpan(text: 'I agree with', children: [
                      TextSpan(
                        text: ' term & condition',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: AppColor.redTheme,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ]),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text.rich(
                TextSpan(text: 'Already have an Account ?', children: [
                  TextSpan(
                    text: ' Sign In!',
                    style: TextStyle(
                      color: AppColor.redTheme,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        isSignUp = false;
                        isRegister = false;
                        isLogIn = true;

                        setState(() {});
                      },
                  )
                ]),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
