import wollok.game.*
import pedidos.*
import niveles.*
import controladorPantallasYNiveles.*


//PUNTAJE: CONTEO-SUMA-RESTA-CALCULAR FRENTE A PEDIDOS

class Puntaje{
    var property valor = 0
    method text() = "PUNTAJE: " + valor
    method textColor() = "FFFFFF"
    method position()
}

object puntajeEnJuego inherits Puntaje{
    override method position() = game.at(1,5)

    method sumar(cantidad){ 
        valor += cantidad 
    }
    method restar(cantidad){ 
        valor = (valor - cantidad).max(0) // nunca puede ser menor a 0
    }

    method puntosPorEspera(pedido){
        if (pedido.prioridad() == 1) return 50 
        else if (pedido.prioridad() == 2) return 25 
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

class PedidosMalEntregados{ //terminar
    var position
    var numeroVida

    method image() = "imagenesFondo/vida.png"

}

const vida1 = new PedidosMalEntregados( //terminar
    position = game.at(3,2),
    numeroVida = 1
)


object controladorDePartida {
    //NIVEL BASICON
    var puntosParaGanar = 750 // creo variables asi no hay num magicos (evaluar)
    var maxPedidosPerdidos = 5

    var nivelActual = nivel1

    var pedidosPerdidos = 0
    var partidaTerminada = false
    var property partidaGanada = false

    method puntosSegunNivel() {
        puntosParaGanar = nivelActual.puntosParaGanar()
    }

    method pedidoPerdido() {
        pedidosPerdidos += 1
    }


    method controlarProgresoPartida() {
        if(!partidaTerminada){
            if (pedidosPerdidos >= maxPedidosPerdidos)
                self.terminarPartida()
            else if (puntajeEnJuego.valor() >= puntosParaGanar){
                partidaGanada = true
                self.continuarJuego() // si hay otro nivel o termina
            }
        }
    }

    method continuarJuego() {
        if (nivelActual.siguienteNivel() != null) {
            generadorDePedidos.terminar(nivelActual) 
            nivelActual = nivelActual.siguienteNivel()
            nivelActual.iniciar()
            puntajeEnJuego.valor(0)
        } else {
            self.terminarPartida()
        }
    }

    method terminarPartida() {
        partidaTerminada = true
        game.schedule(100, {
            game.clear()
            puntajeFinal.valor(puntajeEnJuego.valor())
            self.otorgarMensajeExtra()
            game.addVisual(pantallaFinal)
            game.addVisual(puntajeFinal)
        })
        pantallaFinal.ejecutarPantalla()
    }

    method otorgarMensajeExtra() {
        if(partidaGanada) {puntajeFinal.mensajeExtra("Felicidades!")}
        else {puntajeFinal.mensajeExtra("Casi...")}
    }
}

object puntajeFinal inherits Puntaje{
    var mensajeExtra = ""

    method mensajeExtra(mensj) {
      mensajeExtra = mensj
    }

    override method position() = game.at(2,10)
    
    override method text() {
        return mensajeExtra + super() //porfin encontre donde usar super !! :')
    }
}

