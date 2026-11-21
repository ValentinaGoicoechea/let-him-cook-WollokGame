import pedidos.*
import personajeprincipal.*
import wollok.game.*
import controladorPantallasYNiveles.*
import selectorPersonajes.*
import direcciones.*

// MANEJO DEL TECLADO (MOVERSE-AGARRAR/SOLTAR-INICIAR-ACCIONAR)

object teclado{
    method movimiento() {
        //W-A-S-D
        self.movimientoTecla(jugador1, keyboard.d(), derecha)
        self.movimientoTecla(jugador1, keyboard.a(), izquierda)
        self.movimientoTecla(jugador1, keyboard.w(), arriba)
        self.movimientoTecla(jugador1,keyboard.s(), abajo)

        //FLECHAS
        self.movimientoTecla(jugador2, keyboard.right(), derecha)
        self.movimientoTecla(jugador2, keyboard.left(), izquierda)
        self.movimientoTecla(jugador2, keyboard.up(), arriba)
        self.movimientoTecla(jugador2,keyboard.down(), abajo)
    }

    method seleccion(){
        self.moverEntrePersonajes(keyboard.num1(),1)
        self.moverEntrePersonajes(keyboard.num2(), 2)
        //por ahora solo 2 personajes
    }

    method movimientoTecla(jugador,tecla, direccion) {
        tecla.onPressDo({jugador.direccion(direccion) 
                        jugador.ultimadireccion(direccion)})
        tecla.onReleaseDo({jugador.direccion(ninguna)})
    }

    method moverEntrePersonajes(tecla, numero) { 
        //Implementacion con numeros para seleccionar personaje
        tecla.onPressDo({selectorPersonajes.seleccionarPersonaje(numero)})        
    }

    method agarrarOSoltarObjeto(){
        keyboard.e().onPressDo({jugador1.agarrarOSoltar()})
        keyboard.m().onPressDo({jugador2.agarrarOSoltar()})
    }

    method realizarAccion() {
        keyboard.q().onPressDo({jugador1.accionar()})
        keyboard.k().onPressDo({jugador2.accionar()})
    }   
}