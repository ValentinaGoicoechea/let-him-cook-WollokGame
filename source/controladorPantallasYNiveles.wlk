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

object controladorPantallas {
    var pantallaActual = null

    method configurarEnter() {
        keyboard.enter().onPressDo({
            self.avanzarPantalla()})
    }

    method cambiarPantalla(nuevaPantalla) {
        pantallaActual = nuevaPantalla
        nuevaPantalla.ejecutarPantalla()
        self.configurarEnter() //Porque game.clear() elimina los eventos de teclado
    }

    method avanzarPantalla() {
        if (pantallaActual != null) {
            pantallaActual.pasarASiguiente()
        }
    }

    method entrarAlJuego() {
        if (selectorPersonajes.personajeActual() != null) { 
            pantallaActual = null
        }
    }
}

class Pantalla{
    const property position = game.at(0, 0)
    const property image

    method ejecutarPantalla() {
        game.clear()
        game.addVisual(self)
    }

    method pasarASiguiente(){
      //ABSTRACTO: depende de cada pantalla
    }

}
object pantallaInicio inherits Pantalla(
    image = "imagenesFondos/menuInicio.png"){
    override method pasarASiguiente(){
        //pantallaHistoria.ejecutarPantalla()
        controladorPantallas.cambiarPantalla(pantallaHistoria)
    }
}

object pantallaHistoria inherits Pantalla(
    image = "imagenesFondos/juegoHistoria.png"
    ){
    override method pasarASiguiente(){
        controladorPantallas.cambiarPantalla(pantallaEstaciones)
    }
}

object pantallaTeclas inherits Pantalla(
    image = "imagenesFondos/juegoReglas.png"
    ){
    override method image(){
        if (configuracionPartida.esMultijugador()) return "imagenesFondos/juegoReglas2.png"
        else return "imagenesFondos/juegoReglas.png"
        
    }
    override method pasarASiguiente(){
        controladorPantallas.cambiarPantalla(pantallaSeleccionPersonaje)
    }
    
}

object pantallaEstaciones inherits Pantalla(
    image = "imagenesFondos/juegoEstaciones.png"
    ){
    override method pasarASiguiente(){
        controladorPantallas.cambiarPantalla(pantallaModoJuego)
    }
    
}

object pantallaModoJuego inherits Pantalla(
    image = "imagenesFondos/pantallaModoJuego.png"
    ){
    override method ejecutarPantalla() {
        super()
        keyboard.num1().onPressDo({configuracionPartida.actualizarJugadores(1)})
        keyboard.num2().onPressDo({configuracionPartida.actualizarJugadores(2)})
    }

    override method pasarASiguiente() {
        controladorPantallas.cambiarPantalla(pantallaTeclas)
    }
}

object pantallaSeleccionPersonaje inherits Pantalla(
    image = "imagenesFondos/seleccionDePersonajes.png"
    ){
    override method image(){
        if (configuracionPartida.esMultijugador()){
            var indice = selectorPersonajes.numJugador() + 1
            return "imagenesFondos/seleccionDeJugador"+ indice + ".png"
        } else{
            return "imagenesFondos/seleccionDePersonajes.png"
        }
    }
    override method ejecutarPantalla() {
        super()  
        selectorPersonajes.reiniciar()
        game.addVisual(selectorPersonajes)
        teclado.seleccion()
    }

    override method pasarASiguiente() {
        selectorPersonajes.confirmarSeleccion()
    }

}

object pantallaFinal inherits Pantalla (
    image = "imagenesEstaciones/vacio.png"
    ){
    override method image(){
        if (controladorDePartida.partidaGanada()) return "imagenesFondos/finalGanaste.png"
        else return "imagenesFondos/finalPerdiste.png"
    }
    override method ejecutarPantalla() {
        super()  
        keyboard.z().onPressDo({
            game.stop()})
        
    }
    override method pasarASiguiente(){
        //pantallaSeleccionPersonaje.ejecutarPantalla() //seria en la de nivel
        controladorPantallas.cambiarPantalla(pantallaSeleccionPersonaje)
    }
}

class PantallaNivel inherits Pantalla{
    method mostrarInfoNivel() {
        game.addVisual(self)
        game.schedule(3500, { game.removeVisual(self) })
    }
}

const pantallaNivel1 = new PantallaNivel(
    image = "imagenesFondos/nivelUno.png"
)

const pantallaNivel2 = new PantallaNivel(
    image = "imagenesFondos/nivelDos.png"
)

const pantallaNivel3 = new PantallaNivel(
    image =  "imagenesFondos/nivelTres.png" 
)
       
object juegoCocinero { 

    var nivel = nivel3 //cambiar

    method iniciarJuego() { 
        try { game.removeTickEvent("mover1") } catch e {}
        try { game.removeTickEvent("mover2") } catch e {}
        try { game.removeTickEvent("controlarPartida") } catch e {}
        try { game.removeVisual(pantallaSeleccionPersonaje) } catch e {}
        try { game.removeVisual(selectorPersonajes) } catch e {}
    
        
        controladorDePartida.reiniciarNivel()
        game.addVisual(fondoJuego) 
        game.addVisual(centenas)
        game.addVisual(decenas)
        game.addVisual(unidades)
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
        game.addVisual(mesaFernet1)
        game.addVisual(mesaFernet2)
        game.addVisual(mesaFernet3)

        configuracionPartida.jugadoresActivos().forEach({jugador=>
            game.addVisual(jugador)
            jugador.reiniciar()
            game.onTick(100, "mover" + jugador.numeroPersonaje(),{jugador.darPaso()})
        })

        game.addVisual(plato1)
        game.addVisual(plato2)
        game.addVisual(plato3)
        game.addVisual(vaso1)
        game.addVisual(vaso2)
        game.addVisual(vaso3)
        game.addVisual(puntajeEnJuego)

        nivel.iniciar()
        teclado.movimiento()
        teclado.agarrarOSoltarObjeto()
        teclado.realizarAccion()

        game.onTick(200, "controlarPartida", {controladorDePartida.controlarProgresoPartida()})
        
    }
}


