import source.pedidos.*
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
        self.moverEntrePersonajes(keyboard.num1(),1)
        self.moverEntrePersonajes(keyboard.num2(), 2)
        //por ahora solo 2 personajes
    }

    method movimientoTecla(tecla, direccion) {
        tecla.onPressDo({personajePrincipal.direccion(direccion) 
                        personajePrincipal.ultimadireccion(direccion)})
        tecla.onReleaseDo({personajePrincipal.direccion(ninguna)})
    }

    
    method moverEntrePersonajes(tecla, numero) { 
        //Implementacion con numeros para seleccionar personaje
        tecla.onPressDo({selectorPersonajes.seleccionarPersonaje(numero)})        
    }

    method confirmarPersonaje(){
        keyboard.enter().onPressDo({selectorPersonajes.confirmarSeleccion()})
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



   
}