import pedidos.*


object nivel1 {
    var property puntosParaGanar = 750
    method nuevoPedido() {
        generadorDePedidos.pedir(1)  //Solo ojo de bife con huevo
    }
}
object nivel2 {
    var property puntosParaGanar = 850
    method nuevoPedido() {
        generadorDePedidos.pedir(0.randomUpTo(1).round()) //Puede salir ojo de bife y pollo con papas
    }
}
object nivel3 {
    var property puntosParaGanar = 1000
    method nuevoPedido() {
        generadorDePedidos.pedir(0.randomUpTo(2).round()) //Se agrega el fernet u otra cosa
    }
}