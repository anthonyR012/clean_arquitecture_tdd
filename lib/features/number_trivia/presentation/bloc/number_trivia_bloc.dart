import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_test/core/error/failures.dart';
import 'package:tdd_test/core/usecases/usecase.dart';

import './bloc.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForRandomNumber>(_getTriviaForRandomNumber);
    on<GetTriviaForConcreteNumber>(_getTriviaForConcreteNumber);
    on<GetAutomaticTrivia>(_getAutomaticTrivia);
  }

  _getTriviaForRandomNumber(
      GetTriviaForRandomNumber event, Emitter<NumberTriviaState> emit) async {
    try {
      emit(Loading());
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      emit(failureOrTrivia.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (trivia) => Loaded(trivia: trivia),
      ));
    } catch (e) {
      emit(Empty());
    }
  }

  _getTriviaForConcreteNumber(
      GetTriviaForConcreteNumber event, Emitter<NumberTriviaState> emit) async {
    try {
      emit(Loading());
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      final integer = inputEither.foldRight(0, (r, previous) => r);
      final failureOrTrivia =
          await getConcreteNumberTrivia(Params(number: integer));
      emit(failureOrTrivia.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (trivia) => Loaded(trivia: trivia),
      ));
    } catch (e) {
      emit(Empty());
    }
  }

  _getAutomaticTrivia(
      GetAutomaticTrivia event, Emitter<NumberTriviaState> emit) async {
    while(true){
      await Future.delayed(const Duration(seconds: 5));
      add(GetTriviaForRandomNumber());
    }
  }


  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure _:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }

}
