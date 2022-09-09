import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewModel extends ChangeNotifier {
  int _age = 0;

  int get age => _age;

  Future<void> increment() async {
    _age++;
    final sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.setInt('age', _age);
    notifyListeners();
  }

  Future<void> decrementAge() async {
    _age = max(_age - 1, 0);
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    sharedPreferences.setInt('age', _age);
    notifyListeners();
  }

  void loadValue() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    _age = sharedPreferences.getInt('age') ?? 0;
  }

  ViewModel() {
    loadValue();
  }
}

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ViewModel>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              AgeTitle(),
              IncrementAge(),
              DecrementAge(),
            ],
          ),
        ),
      ),
    );
  }
}

class AgeTitle extends StatelessWidget {
  const AgeTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.select((ViewModel value) => value.age);
    return Text('$viewModel');
  }
}

class IncrementAge extends StatelessWidget {
  const IncrementAge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final incAge = context.read<ViewModel>();
    return ElevatedButton(onPressed: incAge.increment, child: const Text('+'));
  }
}

class DecrementAge extends StatelessWidget {
  const DecrementAge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final decAge = context.read<ViewModel>();
    return ElevatedButton(
        onPressed: decAge.decrementAge, child: const Text('+'));
  }
}
