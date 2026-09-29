import personajeprincipal.*
import wollok.game.*

object teclado{
    method movimiento() {
            // Al presionar: empieza a caminar en esa dirección
            keyboard.d().onPressDo({ personajePrincipal.direccion("derecha") })
            keyboard.a().onPressDo({ personajePrincipal.direccion("izquierda") })
            keyboard.w().onPressDo({ personajePrincipal.direccion("arriba") })
            keyboard.s().onPressDo({ personajePrincipal.direccion("abajo") })

            // Al soltar: se frena inmediatamente
            keyboard.d().onReleaseDo({ personajePrincipal.direccion("ninguna") })
            keyboard.a().onReleaseDo({ personajePrincipal.direccion("ninguna") })
            keyboard.w().onReleaseDo({ personajePrincipal.direccion("ninguna") })
            keyboard.s().onReleaseDo({ personajePrincipal.direccion("ninguna") })
    }

    method agarrarObjeto(){
        keyboard.e().onPressDo({personajePrincipal.agarrar()}) //tendría que recibir una confirmacion del chef diciendo que agarro algo?
    }


   
}