import 'cachorro.dart';
import 'gato.dart';

void main() {
  Cachorro cachorro = Cachorro("Ada", 10.0, 4);
  cachorro.fazerSom();
  cachorro.comer();
  cachorro.brincar();

  Gato mia = Gato("Mia", 5);
  mia.comer();
  mia.estaAmigavel();
  mia.fazerSom();

  List<String> nomes = ['Renato', 'Assis', 'Samanta'];
  print(nomes);

  Map<int, Gato> g = Map();

  g[1] = mia;

  for (Gato f in g.values.toList()) {
    print(f);
  }
}
