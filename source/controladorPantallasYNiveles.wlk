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

class Pantalla{
    const property position = game.at(0, 0)
    const property image

    method ejecutarPantalla() {
        game.clear()
        game.addVisual(self)
        keyboard.enter().onPressDo({
            self.pasarASiguiente()
        })
    }

    method pasarASiguiente(){
      //ABSTRACTO: depende de cada pantalla
    }

}
object pantallaInicio inherits Pantalla(
    image = "imagenesFondos/menuInicio.png"
    ){
    override method pasarASiguiente(){
        pantallaTeclas.ejecutarPantalla()
    }
}

object pantallaTeclas inherits Pantalla(
    image = "imagenesFondos/juegoReglas.png"
    ){
    override method pasarASiguiente(){
        pantallaEstaciones.ejecutarPantalla()
    }
    
}

object pantallaEstaciones inherits Pantalla(
    image = "imagenesFondos/juegoEstaciones.png"
    ){
    override method pasarASiguiente(){
        pantallaSeleccionPersonaje.ejecutarPantalla()
    }
    
}
object pantallaSeleccionPersonaje inherits Pantalla(
    image = "imagenesFondos/seleccionDePersonajes.png"
    ){
    override method ejecutarPantalla() {
        super()  
        game.addVisual(selectorPersonajes)
        game.addVisual(ropaCocinero)
        game.addVisual(ropaOtro)
        teclado.seleccion()
    }

}

object juegoCocinero { //ANTERIOR 'JUEGO' EN PROGRAM.WPGM

    var nivel = nivel1

    method asignarNivel(nuevoNivel) {
        nivel = nuevoNivel
    }

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
        game.addVisual(cajonDePapas)
        game.addVisual(cajonDePollo)
        game.addVisual(cajonDeHuevo)
        game.addVisual(cajonDeBife)
        game.addVisual(personajePrincipal)
        game.addVisual(plato1)
        game.addVisual(plato2)
        game.addVisual(plato3)
        game.addVisual(puntajeEnJuego)

        cajonDePollo.reponerStock()
        cajonDePapas.reponerStock()
        cajonDeHuevo.reponerStock()
        cajonDeBife.reponerStock()

        teclado.movimiento()
        teclado.agarrarOSoltarObjeto()
        teclado.realizarAccion()
        teclado.interactuarConCajon()
        game.onTick(100, "moverCocinero", { personajePrincipal.darPaso() }) 


        controladorDePartida.puntosSegun(nivel)
        generadorDePedidos.empezar(nivel) //LINEA QUE PODRIA LLEGAR A CAMBIAR CON LA IMPLEMENTACION DE NIVELES


        game.onTick(200, "controlarPartida", {controladorDePartida.controlarProgresoPartida()})
    }
}

