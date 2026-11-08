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
        /*keyboard.enter().onPressDo({
            self.pasarASiguiente()
        })*/
    }

    method pasarASiguiente(){
      //ABSTRACTO: depende de cada pantalla
    }

}
object pantallaInicio inherits Pantalla(
    image = "imagenesFondos/menuInicio.png"
){
    override method pasarASiguiente(){
        //pantallaHistoria.ejecutarPantalla()
        controladorPantallas.cambiarPantalla(pantallaHistoria)
    }
}

object pantallaHistoria inherits Pantalla(
    image = "imagenesFondos/juegoHistoria.png"
    ){
    override method pasarASiguiente(){
        //pantallaTeclas.ejecutarPantalla()
        controladorPantallas.cambiarPantalla(pantallaTeclas)
    }
}

object pantallaTeclas inherits Pantalla(
    image = "imagenesFondos/juegoReglas.png"
    ){
    override method pasarASiguiente(){
        //pantallaEstaciones.ejecutarPantalla()
        controladorPantallas.cambiarPantalla(pantallaEstaciones)
    }
    
}

object pantallaEstaciones inherits Pantalla(
    image = "imagenesFondos/juegoEstaciones.png"
    ){
    override method pasarASiguiente(){
        //pantallaSeleccionPersonaje.ejecutarPantalla()
        controladorPantallas.cambiarPantalla(pantallaSeleccionPersonaje)
    }
    
}
object pantallaSeleccionPersonaje inherits Pantalla(
    image = "imagenesFondos/seleccionDePersonajes.png"
    ){
    override method ejecutarPantalla() {
        super()  
        game.addVisual(selectorPersonajes)
        teclado.seleccion()
    }

    override method pasarASiguiente() {
        controladorPantallas.entrarAlJuego()
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

    var nivel = nivel1

    method iniciarJuego() { 
        try { game.removeTickEvent("moverCocinero") } catch e {}
        try { game.removeTickEvent("controlarPartida") } catch e {}
        try { game.removeVisual(pantallaSeleccionPersonaje) } catch e {}
        try { game.removeVisual(selectorPersonajes) } catch e {}
    
        //[cajonDePapas, cajonDePollo, cajonDeHuevo, cajonDeBife].forEach({cajon => cajon.reiniciarPorFinDeNivel()})
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
        game.addVisual(personajePrincipal)
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
        personajePrincipal.reiniciar()
        
        game.onTick(100, "moverCocinero", { personajePrincipal.darPaso() }) 
        game.onTick(200, "controlarPartida", {controladorDePartida.controlarProgresoPartida()})
        //}
    }
}


