import wollok.game.*
import niveles.*

//DIRECCIONES(OBJETOS) POSIBLES DE MOVIMIENTO
object arriba {
    method siguiente(posicion) = posicion.up(1) 
    method direccionImagen() = "Espalda"
}
object abajo {
    method siguiente(posicion) = posicion.down(1)
    method direccionImagen() = "Frente"
}
object izquierda {
    method siguiente(posicion) = posicion.left(1)
    method direccionImagen() = "Izquierda"
}
object derecha {
    method siguiente(posicion) = posicion.right(1)
    method direccionImagen() = "Derecha"
}
object ninguna {  
    method siguiente(posicion) = posicion //no muevo
    method direccionImagen() = "Frente"
}

object escenario { //Para el nivel 1 y 2 
    var property nivelActual = nivel1 //asi inicializa
    method esTransitable(pos) = nivelActual.mapa().esTransitable(pos)
}
class ZonaTransitable {
    const xMin
    const xMax
    const yMin
    const yMax

    method dentroDeZona(pos)= pos.x().between(xMin, xMax) && pos.y().between(yMin, yMax)
}

class Mapa {
    const zonas
    const bloqueados = []

    method estaBloqueado(pos) = bloqueados.any({celda => celda.dentroDeZona(pos) })
    method esTransitable(pos) = !self.estaBloqueado(pos) && zonas.any({zonita => zonita.dentroDeZona(pos) })
}

object mapaNivelBase inherits Mapa(
    zonas = [
        new ZonaTransitable(xMin = 9,  xMax = 13, yMin = 11, yMax = 11),
        new ZonaTransitable(xMin = 17, xMax = 18, yMin = 11, yMax = 11),
        new ZonaTransitable(xMin = 22, xMax = 24, yMin = 11, yMax = 11),
        new ZonaTransitable(xMin = 5,  xMax = 24, yMin = 7,  yMax = 10),
        new ZonaTransitable(xMin = 5,  xMax = 18, yMin = 6,  yMax = 6),
        new ZonaTransitable(xMin = 5,  xMax = 25, yMin = 4,  yMax = 5),
        new ZonaTransitable(xMin = 18, xMax = 25, yMin = 3,  yMax = 3)
    ],
    bloqueados= [new ZonaTransitable(xMin = 20, xMax = 20, yMin = 7,  yMax = 7)] //TACHO DE BASURA
){}

object mapaNivel3 inherits Mapa(
    zonas = [
        new ZonaTransitable(xMin = 5,  xMax = 11, yMin = 5, yMax = 6),
        new ZonaTransitable(xMin = 12,  xMax = 18, yMin = 4, yMax = 7),
        new ZonaTransitable(xMin = 5,  xMax = 18, yMin = 8, yMax = 11),
        new ZonaTransitable(xMin = 11,  xMax = 14, yMin = 12, yMax = 12),
        new ZonaTransitable(xMin = 19,  xMax = 19, yMin = 9, yMax = 11),
        new ZonaTransitable(xMin = 20,  xMax = 25, yMin = 4, yMax = 11)
    ],
    bloqueados= [new ZonaTransitable(xMin = 12, xMax = 12, yMin = 4,  yMax = 4),  //TACHO DE BASURA
                new ZonaTransitable(xMin = 13, xMax = 14, yMin = 7,  yMax = 7),
                new ZonaTransitable(xMin = 16, xMax = 17, yMin = 5,  yMax = 6),
                new ZonaTransitable(xMin = 10, xMax = 10, yMin = 10, yMax = 10),
                new ZonaTransitable(xMin = 7,  xMax = 8,  yMin = 10, yMax = 11),
                new ZonaTransitable(xMin = 20, xMax = 21, yMin = 9,  yMax = 10),
                new ZonaTransitable(xMin = 23, xMax = 23, yMin = 10, yMax = 11)              
    ] 
){}
