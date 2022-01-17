import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/providers.dart';

class AccountDetails extends ConsumerWidget {
  const AccountDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataProvider);

    return data.when(
      data: (user) {
        return Text(user.displayName ?? 'Users name has not been set.');
      },
      error: (error, stackTrace) => Text('$error'),
      loading: () => const Text('waiting...'),
    );
  }
}
