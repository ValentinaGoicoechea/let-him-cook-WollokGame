import source.estados.*
import wollok.game.*
import pedidos.*
import niveles.*
import controladorPantallasYNiveles.*
import vidas.*
import ambiente.*
import comida.*
import personajeprincipal.*



//PUNTAJE: CONTEO-SUMA-RESTA-CALCULAR FRENTE A PEDIDOS
//IMPLEMENTAR POLIMORFISMO DONDE ESTA MARCADO

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
        if(plato.elementosPlato().any{ingrediente => ingrediente.estado() == quemada}) { //VER COMO IMPLEMENTAR POLIMORFISMO ACA
            self.restar(250)
            return 0
        }
        return self.puntosAlEntregar(pedido)
    }
}


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
        vidas.perderVida()
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
            puntajeEnJuego.valor(0)
            self.partidaGanada(false)
            generadorDePedidos.terminar(nivelActual) 
            pedidosPerdidos = 0
            vidas.reiniciar()
            self.reiniciarCocina()
            nivelActual = nivelActual.siguienteNivel()
            nivelActual.iniciar()
        } else {
            self.terminarPartida()
        }
    }

    method terminarPartida() {
        partidaTerminada = true
        generadorDePedidos.terminar(nivelActual)
        vidas.limpiar()

        try { game.removeTickEvent("moverCocinero") } catch e {} //NUEVO
        try { game.removeTickEvent("controlarPartida") } catch e {}

        game.schedule(100, {
            game.clear()
            puntajeFinal.valor(puntajeEnJuego.valor())
            self.otorgarMensajeExtra()
            pantallaFinal.ejecutarPantalla()
            game.addVisual(puntajeFinal)
        })
    }

    method otorgarMensajeExtra() {
        if(partidaGanada) {puntajeFinal.mensajeExtra("Felicidades!")}
        else {puntajeFinal.mensajeExtra("Casi...")}
    }

    method reiniciarNivel() {
        nivelActual = nivel1
        pedidosPerdidos = 0
        vidas.reiniciar()
        self.reiniciarCocina()
        partidaTerminada = false
        partidaGanada = false
        puntajeEnJuego.valor(0)
    }

    method reiniciarCocina() {
        [plato1, plato2, plato3].forEach({ p => p.reiniciar() })
        [cajonDePapas, cajonDePollo, cajonDeHuevo, cajonDeBife].forEach({ c => c.reiniciarPorFinDeNivel() })
        [mesadaArmado1, mesadaArmado2, mesadaArmado3].forEach({ m => m.reiniciar() })
        personajePrincipal.reiniciar()
    }
}

object puntajeFinal inherits Puntaje{
    var mensajeExtra = ""

    method textColor() = "FFFFFF"

    method mensajeExtra(mensj) {
      mensajeExtra = mensj
    }

    override method position() = game.at(10,8)
    
    override method text() {
        return mensajeExtra + super() //porfin encontre donde usar super !! :')
    }
}

