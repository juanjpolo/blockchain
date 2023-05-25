import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/sign_in_bloc.dart';
import '../bloc/sign_in_events.dart';
import '../bloc/sign_in_state.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInBloc>(
      create: (_) => SignInBloc(SingInState(),
          sessionBloc: context.read(), authRepository: context.read()),
      child: Builder(builder: (context) {
        final signBloc = context.read<SignInBloc>();
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: BlocBuilder<SignInBloc, SingInState>(
                buildWhen: (previous, current) =>
                    previous.fetching != current.fetching,
                builder: (context, state) {
                  return Form(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormField(
                        onChanged: (text) =>
                            signBloc.add(SignInEmailChangedEvent(text)),
                        decoration: const InputDecoration(label: Text('Email')),
                        validator: (value) {
                          value = value?.trim() ?? '';
                          if (value.isEmpty) {
                            return 'invalid email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        onChanged: (text) =>
                            signBloc.add(SignInPasswordChangedEvent(text)),
                        decoration:
                            const InputDecoration(label: Text('Password')),
                        validator: (value) {
                          value = value?.trim() ?? '';
                          if (value.isEmpty) {
                            return 'invalid password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      BlocBuilder<SignInBloc, SingInState>(
                        buildWhen: (previous, current) =>
                            // ignore: unrelated_type_equality_checks
                            previous.termsAccepted != current.runtimeType,
                        builder: (context, state) {
                          return CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: const Text('Are u Okay with terms'),
                              value: state.termsAccepted,
                              onChanged: (checked) => signBloc.add(
                                  SignInTermsChangedEvent(checked ?? false)));
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Builder(builder: (context) {
                        return ElevatedButton(
                          onPressed: () => _submit(context),
                          child: const Text('Sign in'),
                        );
                      })
                    ],
                  ));
                },
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final SignInBloc bloc = context.read();
    final result = await bloc.signIn();
    if (context.mounted) {
      result.when(
        left: (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                failure.toString(),
              ),
            ),
          );
        },
        right: (_) {
          Navigator.pushReplacementNamed(
            context,
            '/',
          );
        },
      );
    }
  }

  String? _emailValidator(text) {
    text = text?.trim() ?? '';
    if (text.contains('@')) {
      return null;
    }
    return 'Invalid email';
  }

  String? _passwordValidator(text) {
    text = text?.trim() ?? '';
    if (text.isEmpty) {
      return 'Invalid password';
    }
    return null;
  }
}
