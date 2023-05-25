import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../domain/models/crypto/crypto.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';

class HomeLoaded extends StatelessWidget {
  const HomeLoaded({super.key, required this.cryptos});
  final List<Crypto> cryptos;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(6),
      itemBuilder: (_, index) {
        final crypto = cryptos[index];
        debugPrint(crypto.symbol);
        return ClipRRect(
          clipBehavior: Clip.hardEdge,
          child: Dismissible(
            background: Container(color: Colors.red),
            key: Key(crypto.id),
            onDismissed: (_) =>
                context.read<HomeBloc>().add(DeleteEvent(crypto)),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                leading: SvgPicture.asset('assets/icons/${crypto.symbol}.svg'),
                title: Text(crypto.id),
                subtitle: Text(crypto.symbol),
                trailing: Text(crypto.price.toStringAsFixed(2)),
              ),
            ),
          ),
        );
      },
      itemCount: cryptos.length,
    );
  }
}
