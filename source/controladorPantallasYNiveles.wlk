import wollok.game.*
import teclado.*
import personajeprincipal.*
import ambiente.*
import comida.*
import pedidos.*
import puntaje.*


object pantallaInicio {
    const property position = game.at(0, 0)
    method image() = "menuInicio.png"
    method mostrarPantallaInicio() {
        keyboard.enter().onPressDo({juegoCocinero.iniciarJuego()})
    }
}

object pantallaSeleccionPersonaje {
  
}

object juegoCocinero { //ANTERIOR 'JUEGO' EN PROGRAM.WPGM
    method iniciarJuego() { // SE MANTIENE IGUAL PARA TODOS LOS NIVELES
        game.clear()
        game.removeVisual(pantallaInicio)
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
        game.addVisual(cajonDePapas)
        game.addVisual(cajonDePollo)
        game.addVisual(personajePrincipal)
        game.addVisual(plato1)
        game.addVisual(plato2)
        game.addVisual(puntaje)

        cajonDePollo.reponerStock()
        cajonDePapas.reponerStock()

        teclado.movimiento()
        teclado.agarrarOSoltarObjeto()
        teclado.realizarAccion()
        teclado.interactuarConCajon()
        game.onTick(100, "moverCocinero", { personajePrincipal.darPaso() }) 
        generadorDePedidos.empezar() //LINEA QUE PODRIA LLEGAR A CAMBIAR CON LA IMPLEMENTACION DE NIVELES
    }

}

