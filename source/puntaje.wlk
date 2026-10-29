import wollok.game.*
import pedidos.*

//PUNTAJE: CONTEO-SUMA-RESTA-CALCULAR FRENTE A PEDIDOS

class Puntaje{
    var property valor = 0
    method text() = "PUNTAJE: " + valor
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


object controladorDePartida {
    //NIVEL BASICON
    const puntosParaGanar = 750 // creo variables asi no hay num magicos (evaluar)
    const maxPedidosPerdidos = 5

    var pedidosPerdidos = 0
    var partidaTerminada = false
    var property partidaGanada = false

    method pedidoPerdido() {
        pedidosPerdidos += 1
    }

    method controlarProgresoPartida() {
        if(!partidaTerminada){
            if (pedidosPerdidos >= maxPedidosPerdidos)
                self.terminarPartida()
            else if (puntajeEnJuego.valor() >= puntosParaGanar){
                partidaGanada = true
                self.terminarPartida()}
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
        //aca iria una linea para preguntar si terminar (game.stop) o volver al menu...
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
object pantallaFinal {
    const property position = game.at(0, 0)
    /*
    method image(){
        if(controladorDePartida.partidaGanada()) return "" 
        else ""}
    FALTA LAS PANTALLASS, TERMINO DE DISEÑARLAS...*/

    //aca volveria a la pantalla de menu de seleccion de p
}
