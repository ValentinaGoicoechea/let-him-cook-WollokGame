import musica.*
import selectorPersonajes.*
import estados.*
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
class DigitoPuntaje{
    var property position
    var property digito = 0 //Inicialmente
    method image() = "numeros/" + digito.toString() + ".png"
    method permiteApoyar() = false
}
const centenas = new DigitoPuntaje(position = game.at(4,0))
const decenas = new DigitoPuntaje(position = game.at(5,0))
const unidades = new DigitoPuntaje(position = game.at(6,0))

object puntajeEnJuego {
    var property valor = 0
    method image() = "imagenesFondos/PUNTOS.png"
    method permiteApoyar() = false

    var posicion = game.at(5, 1)
    method position() = posicion //encapsulamiento!!

    method ubicarEnJuego() {
        posicion = game.at(4, 1)
        centenas.position(game.at(4, 0))
        decenas.position(game.at(5, 0))
        unidades.position(game.at(6, 0))
    }

    method ubicarEnPantallaFinal() {
        posicion = game.at(16, 8)
        centenas.position(game.at(16, 7))
        decenas.position(game.at(17, 7))
        unidades.position(game.at(18, 7))
    }
    method sumar(cantidad){ 
        valor += cantidad 
        self.actualizarVisuales()
    }
    method restar(cantidad){ 
        valor = (valor - cantidad).max(0) // nunca puede ser menor a 0
        self.actualizarVisuales()
    }

    method actualizarVisuales(){
        unidades.digito(valor % 10) //saca el resto de dividir por 10
        decenas.digito((valor.div(10)) % 10)
        centenas.digito((valor.div(100)) % 10)
    }

    method puntosPorEspera(pedido){
        if (pedido.prioridad() == 1) return 50 
        else if (pedido.prioridad() == 2) return 25 
        else return 0
    }

    method puntosAlEntregar(pedido) = 200 + self.puntosPorEspera(pedido)

    method asignarPuntos(pedido, plato){
        /*if(plato.elementosPlato().any{ingrediente => ingrediente.estado() == quemada}) { //VER COMO IMPLEMENTAR POLIMORFISMO ACA
            self.restar(250)
            return 0
        }*/
        if (plato.tieneAlgunElementoQuemado()) { 
            self.restar(250)
            return 0
        }
        return self.puntosAlEntregar(pedido)
    }
}


object controladorDePartida {
    //NIVEL BASICON
    var puntosParaGanar = 750 // creo variables asi no hay num magicos (evaluar)
    var maxPedidosPerdidos = 1
    const digitos = [centenas, decenas, unidades]

    var property nivelActual = nivel1

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
            puntajeEnJuego.actualizarVisuales()
            self.partidaGanada(false)
            generadorDePedidos.terminar(nivelActual) 
            pedidosPerdidos = 0
            self.reiniciarCocina()



            nivelActual = nivelActual.siguienteNivel()
            nivelActual.iniciar()
        } else {
            self.terminarPartida()
        }
    }

    method terminarPartida() {
        if (!partidaTerminada) {
            partidaTerminada = true
            generadorDePedidos.terminar(nivelActual)
            musicaDeFondo.pararMusica()
            vidas.limpiar()

            try { game.removeTickEvent("moverCocinero") } catch e {}
            try { game.removeTickEvent("controlarPartida") } catch e {}

            controladorPantallas.cambiarPantalla(pantallaFinal) //Para que no se vea el puntaje en las nuevas pantallas
        /*
            game.schedule(100, 
                
                controladorPantallas.cambiarPantalla(pantallaFinal)
                //puntajeEnJuego.ubicarEnPantallaFinal()
                //game.addVisual(puntajeEnJuego)               
                //digitos.forEach({digito => game.addVisual(digito) }) 
            )
        */
        }

    }

    method reiniciarNivel() {
        nivelActual = nivel1
        pedidosPerdidos = 0
        vidas.reiniciar()
        self.reiniciarCocina()
        partidaTerminada = false
        partidaGanada = false
        puntajeEnJuego.valor(0)
        puntajeEnJuego.ubicarEnJuego()
        puntajeEnJuego.actualizarVisuales()
        //musicaDeFondo.pararMusica()
        musicaDeFondo.cambiarMusica(game.sound("musica/musicaJuegoPrincipal.wav"))
        musicaDeFondo.iniciarMusica()
    }

    method reiniciarCocina() {
        [plato1, plato2, plato3, vaso1, vaso2, vaso3].forEach({ p => p.reiniciar() })
        [cajonDePapas, cajonDePollo, cajonDeHuevo, cajonDeBife].forEach({ c => c.reiniciarPorFinDeNivel() })
        [mesadaArmado1, mesadaArmado2, mesadaArmado3].forEach({ m => m.reiniciar() })
    }
}



