import wollok.game.*
import teclado.*
import personajeprincipal.*
import ambiente.*
import comida.*
import pedidos.*
import puntaje.*
import selectorPersonajes.*
import niveles.*

//CAMBIO DE PANTALLAS (INICIO, MENU DE PERSONAJES, NIVELES)

object pantallaInicio {
    const property position = game.at(0, 0)
    method image() = "imagenesFondos/menuInicio.png"

    method saltarPantallaInicio() {
        keyboard.enter().onPressDo({
            pantallaSeleccionPersonaje.iniciarSeleccionPersonajes() //funcionando
        })
    }
}

object pantallaSeleccionPersonaje {
    var property position = game.at(10, 5)
    method image() = "imagenesFondos/fondoSeleccionPersonajes.png"

    method iniciarSeleccionPersonajes() {
        game.clear()
        game.addVisual(self)
        game.addVisual(selectorPersonajes)
        game.addVisual(ropaCocinero) //PRUEBA
        game.addVisual(ropaOtro) //PRUEBA
        teclado.seleccion()
       
    }

}

object juegoCocinero { //ANTERIOR 'JUEGO' EN PROGRAM.WPGM

    var nivel = nivel1

    method iniciarJuego() { // SE MANTIENE IGUAL PARA TODOS LOS NIVELES
        game.clear()
        game.removeVisual(pantallaSeleccionPersonaje)
        game.addVisual(horno1)
        game.addVisual(horno2)
        game.addVisual(mesadaEntrega1)
        game.addVisual(mesadaEntrega2)
        game.addVisual(mesadaEntrega3)
        game.addVisual(mesadaArmado1)
        game.addVisual(mesadaArmado2)
        game.addVisual(mesadaArmado3)
        game.addVisual(tablaDeCortar)
        game.addVisual(basura)
        game.addVisual(bacha)
        game.addVisual(personajePrincipal)
        game.addVisual(plato1)
        game.addVisual(plato2)
        game.addVisual(plato3)
        game.addVisual(puntajeEnJuego)

        nivel.iniciar()

        teclado.movimiento()
        teclado.agarrarOSoltarObjeto()
        teclado.realizarAccion()
        teclado.interactuarConCajon()
        game.onTick(100, "moverCocinero", { personajePrincipal.darPaso() }) 
        game.onTick(200, "controlarPartida", {controladorDePartida.controlarProgresoPartida()})
    }
}

