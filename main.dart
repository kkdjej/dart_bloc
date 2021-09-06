import 'package:bloc/bloc.dart';

Stream<int> countStream(int max) async* {
  for (int i = 0; i < max; i++) {
    yield i;
  }
}

Future<int> sumStream(Stream<int> stream) async {
  int sum = 0;
  await for (int value in stream) {
    sum += value;
  }
  return sum;
}

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() {
    addError(Exception("increment error!"), StackTrace.current);
    emit(state + 1);
  }

  @override
  void onChange(Change<int> change) {
    print(change);
    super.onChange(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace starckTrace) {
    print('${bloc.runtimeType} $error $starckTrace');
    super.onError(bloc, error, starckTrace);
  }
}

enum CounterEvent { increment }

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0);

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.increment:
        yield state + 1;
        break;
    }
  }

  @override
  void onChange(Change<int> change) {
    print(change);
    super.onChange(change);
  }

  @override
  void onTransition(Transition<CounterEvent, int> transition) {
    super.onTransition(transition);
    print(transition);
  }
}

void main() async {
  // Stream<int> stream = countStream(10);
  // int sum = await sumStream(stream);
  // print(sum);

  // Bloc.observer = SimpleBlocObserver();
  // final cubit = CounterCubit();
  // print(cubit.state);
  // cubit.increment();
  // print(cubit.state);
  // cubit.close();
  // final subscription = cubit.stream.listen(print);
  // cubit.increment();
  // await Future.delayed(Duration.zero);
  // await subscription.cancel();
  // await cubit.close();

  final bloc = CounterBloc();
  // print(bloc.state);
  // bloc.add(CounterEvent.increment);
  // await Future.delayed(Duration.zero);
  // print(bloc.state);
  // await bloc.close();

  final subscription = bloc.stream.listen(print);
  bloc.add(CounterEvent.increment);
  await Future.delayed(Duration.zero);
  await subscription.cancel();
  await bloc.close();
}
