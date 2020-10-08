import 'animal.dart';

class Gato extends Animal {
  Gato(String nome, double peso) : super(nome, peso);
  bool estaAmigavel() {
    return true;
  }

  @override
  String toString() {
    return '{nome: ${this.nome} peso: ${this.peso}}';
  }
}
