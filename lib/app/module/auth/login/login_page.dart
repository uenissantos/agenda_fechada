import 'package:agenda_fechada/app/auth_exception/auth_exception.dart';
import 'package:agenda_fechada/app/core/database/notifier/default_listiner_notifier.dart';
import 'package:agenda_fechada/app/module/auth/login/login_controller.dart';
import 'package:agenda_fechada/app/ui/logo.dart';
import 'package:agenda_fechada/app/ui/messages.dart';
import 'package:agenda_fechada/app/ui/text_Form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  final _emailFocus = FocusNode();
  String messageReset = '';
  final _emailEC = TextEditingController();
  var key = GlobalKey<FormState>();
  final _senhaEC = TextEditingController();
  void dispose() {
    DefaultListinerNotifier(changernotifier: context.read<LoginControlller>())
        .dispose();
  }

  void initState() {
    DefaultListinerNotifier(changernotifier: context.read<LoginControlller>())
        .listiner(
            context: context,
            everCallback: (notifier, listenerInstance) {
              if (notifier is LoginControlller) {
                if (notifier.hasInfo) {
                  Messages.of(context).ShowInfo(notifier.infoMessage!);
                }
              }
            },
            successVoidCallback: (notifier, listenerInstance) {
              
            });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LoginControlller>(context);
    return Scaffold(
      body: Container(
        child: LayoutBuilder(builder: (Context, Constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: Constraints.maxHeight,
                  minWidth: Constraints.minWidth),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Logo(),
                    Form(
                        key: key,
                        child: Column(
                          children: [
                            TexFormPersonalizado(
                                label: 'email',
                                focusNode: _emailFocus,
                                controller: _emailEC,
                                validator: Validatorless.multiple([
                                  Validatorless.email('email é obrigatorio'),
                                ])),
                            SizedBox(
                              height: 10,
                            ),
                            TexFormPersonalizado(
                              obscure: true,
                              label: 'senha',
                              controller: _senhaEC,
                              validator: Validatorless.multiple([
                                Validatorless.required('senha obrigatoria'),
                                Validatorless.min(
                                    8, 'sua senha conten no minimo 8')
                              ]),
                            )
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                              onPressed: () {
                                final email = _emailEC.text;

                                if (email.isNotEmpty) {
                                  context
                                      .read<LoginControlller>()
                                      .recoverPassword(email);
                                } else {
                                  Messages.of(context).ShowError(
                                      'o email tem que esta preenchido');
                                  _emailFocus.requestFocus();
                                }
                              },
                              child: Text(
                                'esqueci a senha ?',
                                style: TextStyle(color: Color(0xffDE8D7B)),
                              )),
                          ElevatedButton(
                              onPressed: () {
                                final email = _emailEC.text;
                                final password = _senhaEC.text;
                                final formValid =
                                    key.currentState?.validate() ?? false;
                                if (formValid) {
                                  context
                                      .read<LoginControlller>()
                                      .login(email, password);
                                }
                              },
                              child: Text('LOGAR'),
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xffb49fcc)))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      width: 2,
                                      color: Colors.grey.withAlpha(50)))),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: SignInButton(
                                  Buttons.Google,
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide.none),
                                  text: 'continue com google',
                                  onPressed: () {
                                    context
                                        .read<LoginControlller>()
                                        .googleLogin();
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'não ten conta ?',
                                    style: const TextStyle(
                                        color: Color(0xffb49fcc)),
                                  ),
                                  TextButton(
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/registro'),
                                      child: Text(
                                        'cadastre-se ',
                                        style: const TextStyle(
                                            color: Color(0xffDE8D7B)),
                                      ))
                                ],
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
