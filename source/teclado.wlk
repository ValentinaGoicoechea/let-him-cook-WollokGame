import personajeprincipal.*
import wollok.game.*
import controladorPantallasYNiveles.*
import selectorPersonajes.*
import direcciones.*

// MANEJO DEL TECLADO (MOVERSE-AGARRAR/SOLTAR-INICIAR-ACCIONAR)

object teclado{
    method movimiento() {
        self.movimientoTecla(keyboard.d(), derecha)
        self.movimientoTecla(keyboard.a(), izquierda)
        self.movimientoTecla(keyboard.w(), arriba)
        self.movimientoTecla(keyboard.s(), abajo)
    }

    method seleccion(){

    }

    method movimientoTecla(tecla, direccion) {
        tecla.onPressDo({personajePrincipal.direccion(direccion) 
                        personajePrincipal.ultimadireccion(direccion)})
        tecla.onReleaseDo({personajePrincipal.direccion(ninguna)})
    }

    method agarrarOSoltarObjeto(){
        keyboard.e().onPressDo({personajePrincipal.agarrarOSoltar()}) 
    }

    method realizarAccion() {
        keyboard.q().onPressDo({personajePrincipal.accionar()})
    }

    method interactuarConCajon() {
        keyboard.num1().onPressDo({personajePrincipal.accionarCajon()})
    }

    method moverEntrePersonajes(numero) { //para que es esto y por que es lo mismo que arriba???

        /*
        Implementacion con teclas y logica de movimiento de personaje
        keyboard.d().onPressDo({ selectorPersonajes.moverseA("derecha") })
        keyboard.a().onPressDo({ selectorPersonajes.moverseA("izquierda") })
        keyboard.w().onPressDo({ selectorPersonajes.moverseA("arriba") })
        keyboard.s().onPressDo({ selectorPersonajes.moverseA("abajo") })
        */

        //Implementacion con numeros para seleccionar personaje
        keyboard.1().onPressDo({selectorPersonajes.direccion(direccion)})
        
        
        
    }

    method iniciarJuego() { 
        keyboard.enter().onPressDo({pantallaInicio.saltarPantallaInicio()})
    }

   
}