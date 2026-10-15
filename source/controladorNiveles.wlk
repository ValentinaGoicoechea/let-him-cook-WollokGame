import wollok.game.*
import teclado.*
import personajeprincipal.*
import ambiente.*
import comida.*
import pedidos.*

/* object controladorNiveles {

    method iniciarNivel1() {
        game.title("LET HIM COOK") //a chequear si despues lo cambiamos
        game.boardGround("fondo.png")
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
        
        cajonDePollo.reponerStock()
        cajonDePapas.reponerStock()

        teclado.movimiento()
        teclado.agarrarOSoltarObjeto()
        teclado.realizarAccion()
        teclado.interactuarConCajon()
        game.onTick(100, "moverCocinero", { personajePrincipal.darPaso() }) //sirve para que pueda avanzar manteniendo presionado, pregunta cada 100ms a donde da un paso
        generadorDePedidos.empezar()
    }


} */

object pantallaInicio {
    method mostrarPantallaInicio() {
        game.clear()
        game.boardGround("menuInicio.png")   
        keyboard.enter().onPressDo({juegoCocinero.iniciarJuego()})
    }
}

object pantallaSeleccionPersonaje {
  
}

object juegoCocinero { //ANTERIOR 'JUEGO' EN PROGRAM.WPGM
    method iniciarJuego() { // SE MANTIENE IGUAL PARA TODOS LOS NIVELES
        game.clear()
        game.boardGround("fondo.png")
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