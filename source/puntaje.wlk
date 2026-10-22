import wollok.game.*
import pedidos.*

object puntaje{
    var property valor = 0

    method sumar(cantidad){ 
        valor += cantidad 
    }
    method restar(cantidad){ 
        valor = (valor - cantidad).max(0) // nunca puede ser menor a 0
    }

    method text() = "PUNTAJE: " + valor
    method position() = game.at(1,5)

    method puntosPorEspera(pedido){
        if (pedido.estado() == "NUEVO") return 50 
        else if (pedido.estado() == "ESPERA1") return 25 
        else return 0
    }

    method puntosAlEntregar(pedido) = 200 + self.puntosPorEspera(pedido)

    method asignarPuntos(pedido, plato){
        if(plato.elementosPlato().any{ingrediente => ingrediente.modificado() == "quemado"}) {
            self.restar(250)
            return 0
        }
        return self.puntosAlEntregar(pedido)
    }
}
