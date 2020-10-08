abstract class Animal {
  String nome;
  double peso;

  void fazerSom() {
    print('${nome} fazer som!');
  }

  void comer() {
    print('$nome comeu!');
  }

  Animal(this.nome, this.peso);
}
