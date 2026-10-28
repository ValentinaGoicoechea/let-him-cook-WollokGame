import personajeprincipal.*
import wollok.game.*
import controladorPantallasYNiveles.*
import selectorPersonajes.*

// MANEJO DEL TECLADO (MOVERSE-AGARRAR/SOLTAR-INICIAR-ACCIONAR)

object teclado{
    method movimiento() {
            // Al presionar: empieza a caminar en esa dirección
            keyboard.d().onPressDo({ personajePrincipal.direccion("derecha") 
                                    personajePrincipal.ultimadireccion("derecha") })
            keyboard.a().onPressDo({ personajePrincipal.direccion("izquierda") 
                                    personajePrincipal.ultimadireccion("izquierda")})
            keyboard.w().onPressDo({ personajePrincipal.direccion("arriba") 
                                    personajePrincipal.ultimadireccion("arriba")})
            keyboard.s().onPressDo({ personajePrincipal.direccion("abajo") 
                                    personajePrincipal.ultimadireccion("abajo")})

            // Al soltar: se frena inmediatamente
            keyboard.d().onReleaseDo({ personajePrincipal.direccion("ninguna") })
            keyboard.a().onReleaseDo({ personajePrincipal.direccion("ninguna") })
            keyboard.w().onReleaseDo({ personajePrincipal.direccion("ninguna") })
            keyboard.s().onReleaseDo({ personajePrincipal.direccion("ninguna") })
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

    method moverEntrePersonajes() {
        keyboard.d().onPressDo({ selectorPersonajes.moverseA("derecha") })
        keyboard.a().onPressDo({ selectorPersonajes.moverseA("izquierda") })
        keyboard.w().onPressDo({ selectorPersonajes.moverseA("arriba") })
        keyboard.s().onPressDo({ selectorPersonajes.moverseA("abajo") })
    }

    method iniciarJuego() { 
        keyboard.enter().onPressDo({pantallaInicio.saltarPantallaInicio()})
    }

   
}