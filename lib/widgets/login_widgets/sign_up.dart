import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rt_gem/provider/email_sign_in.dart';
import 'package:rt_gem/theme.dart';
import 'package:rt_gem/utils/responsive.dart';
import 'package:rt_gem/widgets/snackbar.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodeName = FocusNode();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    focusNodePassword.dispose();
    focusNodeConfirmPassword.dispose();
    focusNodeEmail.dispose();
    focusNodeName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmailSignInProvider>(context);

    return Container(
      padding: const EdgeInsets.only(top: 23.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: 300.0,
                    height: 330.0,
                    child: ListView(
                      children: <Widget>[
                        buildUsernameField(),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        buildEmailField(),

                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        buildPasswordField(),

                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        buildConfirmPasswordField(),


                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 310.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: CustomTheme.loginGradientStart,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                      BoxShadow(
                        color: CustomTheme.loginGradientEnd,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                    ],
                    gradient: LinearGradient(
                        colors: <Color>[
                          CustomTheme.loginGradientEnd,
                          CustomTheme.loginGradientStart
                        ],
                        begin: FractionalOffset(0.2, 0.2),
                        end: FractionalOffset(1.0, 1.0),
                        stops: <double>[0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: CustomTheme.loginGradientEnd,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: 'WorkSansBold'),
                      ),
                    ),
                    onPressed: () {
                      submit();
                    }
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUsernameField(){
    final provider = Provider.of<EmailSignInProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(
          top: kIsWeb ? 20.0 : 0.0, bottom: 15.0, left: 25.0, right: 25.0),
      child: TextFormField(
        key: ValueKey('username'),
        focusNode: focusNodeName,
        controller: signupNameController,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        autocorrect: false,
        style: const TextStyle(
            fontFamily: 'WorkSansSemiBold',
            fontSize: 16.0,
            color: Colors.black),
        validator: (value) {
          if (value!.isEmpty || value.length < 4 || value.contains(' ')) {
            return 'Please enter at least 4 characters without space';
          } else {
            return null;
          }
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            FontAwesomeIcons.user,
            color: Colors.black,
          ),
          hintText: 'Name',
          hintStyle: TextStyle(
              fontFamily: 'WorkSansSemiBold', fontSize: 16.0),
        ),
        onFieldSubmitted: (_) => focusNodeEmail.requestFocus(),
        onSaved: (username) {
          provider.userName = username;
        },
      ),
    );
  }

  Widget buildEmailField(){
    final provider = Provider.of<EmailSignInProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(
          top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
      child: TextFormField(
        key: ValueKey('email'),
        focusNode: focusNodeEmail,
        controller: signupEmailController,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        validator: (value) {
          final pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
          final regExp = RegExp(pattern);

          if (!regExp.hasMatch(value!)) {
            return 'Enter a valid mail';
          } else {
            return null;
          }
        },
        style: const TextStyle(
            fontFamily: 'WorkSansSemiBold',
            fontSize: 16.0,
            color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            FontAwesomeIcons.envelope,
            color: Colors.black,
          ),
          hintText: 'Email Address',
          hintStyle: TextStyle(
              fontFamily: 'WorkSansSemiBold', fontSize: 16.0),
        ),
        onFieldSubmitted: (_) => focusNodePassword.requestFocus(),
        onSaved: (email) {
          provider.newUserEmail = email;
        },
      ),
    );
  }

  Widget buildPasswordField(){
    final provider = Provider.of<EmailSignInProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(
          top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
      child: TextFormField(
        key: ValueKey('password'),
        focusNode: focusNodePassword,
        controller: signupPasswordController,
        obscureText: _obscureTextPassword,
        autocorrect: false,
        validator: (value) {
          if (value!.isEmpty || value.length < 7) {
            return 'Password must be at least 7 characters long.';
          } else {
            return null;
          }
        },
        style: const TextStyle(
            fontFamily: 'WorkSansSemiBold',
            fontSize: 16.0,
            color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: const Icon(
            FontAwesomeIcons.lock,
            color: Colors.black,
          ),
          hintText: 'Password',
          hintStyle: const TextStyle(
              fontFamily: 'WorkSansSemiBold', fontSize: 16.0),
          suffixIcon: GestureDetector(
            onTap: _toggleSignup,
            child: Icon(
              _obscureTextPassword
                  ? FontAwesomeIcons.eye
                  : FontAwesomeIcons.eyeSlash,
              size: 15.0,
              color: Colors.black,
            ),
          ),
        ),
        onFieldSubmitted: (_) => focusNodeConfirmPassword.requestFocus(),
        onSaved: (password) {
          provider.newUserPassword = password;
        },
      ),
    );
  }

  Widget buildConfirmPasswordField(){
    return Padding(
      padding: const EdgeInsets.only(
          top: 15.0, bottom: 25.0, left: 25.0, right: 25.0),
      child: TextFormField(
        focusNode: focusNodeConfirmPassword,
        controller: signupConfirmPasswordController,
        obscureText: _obscureTextConfirmPassword,
        autocorrect: false,
        validator: (value) {
          if (signupConfirmPasswordController.text !=  signupPasswordController.text) {
            return 'Passwords must match.';
          } else {
            return null;
          }
        },
        style: const TextStyle(
            fontFamily: 'WorkSansSemiBold',
            fontSize: 16.0,
            color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: const Icon(
            FontAwesomeIcons.lock,
            color: Colors.black,
          ),
          hintText: 'Confirmation',
          hintStyle: const TextStyle(
              fontFamily: 'WorkSansSemiBold', fontSize: 16.0),
          suffixIcon: GestureDetector(
            onTap: _toggleSignupConfirm,
            child: Icon(
              _obscureTextConfirmPassword
                  ? FontAwesomeIcons.eye
                  : FontAwesomeIcons.eyeSlash,
              size: 15.0,
              color: Colors.black,
            ),
          ),
        ),
        textInputAction: TextInputAction.go,
      ),
    );
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }

  Future submit() async {
    final provider = Provider.of<EmailSignInProvider>(context, listen: false);

    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      final isSuccess = await provider.signup();

      if (isSuccess) {
        CustomSnackBar(context, const Text('Create User Success!'),Colors.green);
      } else {
        CustomSnackBar(context, const Text('An error occurred, please check your credentials!'),Colors.red);
      }
    } else{
      CustomSnackBar(context, const Text('Validation Error!'),Colors.red);
    }
  }

}
