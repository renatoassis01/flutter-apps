import 'animal.dart';

class Cachorro extends Animal {
  int fofura;
  Cachorro(String nome, double peso, this.fofura) : super(nome, peso);

  @override
  void fazerSom() {
    print('${nome} au au au');
  }

  void brincar() {
    fofura += 10;
    print('Fofura do $nome aumentou para $fofura');
  }
}
