// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../../domain/failures/http_request_failure.dart';

class HomeError extends StatelessWidget {
  final HttpRequestFailure failure;
  const HomeError({
    Key? key,
    required this.failure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final message = failure.maybeWhen(
      network: () => 'Check your internet connection',
      server: () => 'server',
      orElse: () => 'Local error',
    );
    return Center(
      child: Text(message),
    );
  }
}
