
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_test/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_test/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_test/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository{
  
} 


void main(){
  late GetConcreteNumberTrivia useCase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
 setUp((){
   mockNumberTriviaRepository = MockNumberTriviaRepository();
   useCase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
 });
 const tNumber = 1;
 final tNumberTrivia = NumberTrivia(text: "Test", number:  tNumber);
  test(
  'should get trivia for the number from the repository',
  () async {
    // arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
    .thenAnswer((_) => Future.value(Right(tNumberTrivia)));

    // act
    final result = useCase.call(Params(number: tNumber )).then((value) {
      return value;
    });
    // assert
    expect(result, Right(tNumberTrivia));
    verify(await mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  },
  );
}
