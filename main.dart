import 'package:bloc/bloc.dart';

Stream<int> countStream(int max) async* {
  for(int i = 0; i < max; i++) {
    yield i;
  }
}

Future<int> sumStream(Stream<int> stream) async{
  int sum = 0;
  await for(int value in stream) {
    sum += value;
  }
  return sum;
}

class CounterCubit extends Cubit<int> {
  CounterCubit(): super(0);

  void increment() {
    emit(state + 1);
  }
  @override
  void onChange(Change<int> change) {
    print(change);
    super.onChange(change);
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}

void main() async {
  // Stream<int> stream = countStream(10);
  // int sum = await sumStream(stream);
  // print(sum);

  Bloc.observer = SimpleBlocObserver();
  final cubit = CounterCubit();
  // print(cubit.state);
  // cubit.increment();
  // print(cubit.state);
  // cubit.close();
  final subscription = cubit.stream.listen(print);
  cubit.increment();
  await Future.delayed(Duration.zero);
  await subscription.cancel();
  await cubit.close();

}