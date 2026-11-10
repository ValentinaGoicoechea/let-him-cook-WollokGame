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
class Zona {
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
        new Zona(xMin = 9,  xMax = 13, yMin = 11, yMax = 11),
        new Zona(xMin = 17, xMax = 18, yMin = 11, yMax = 11),
        new Zona(xMin = 22, xMax = 24, yMin = 11, yMax = 11),
        new Zona(xMin = 5,  xMax = 24, yMin = 7,  yMax = 10),
        new Zona(xMin = 5,  xMax = 18, yMin = 6,  yMax = 6),
        new Zona(xMin = 5,  xMax = 25, yMin = 4,  yMax = 5),
        new Zona(xMin = 18, xMax = 25, yMin = 3,  yMax = 3)
    ],
    bloqueados= [new Zona(xMin = 20, xMax = 20, yMin = 7,  yMax = 7)] //TACHO DE BASURA
){}

object mapaNivel3 inherits Mapa(
    zonas = [
        new Zona(xMin = 5, xMax= 24, yMin = 3, yMax = 11) //piso principal
    ],
    bloqueados = [
        new Zona(xMin = 4,  xMax = 10, yMin = 6, yMax = 6), //pared de la despensa
        new Zona(xMin = 9,  xMax = 9,  yMin = 7, yMax = 7), //tacho de basura
        new Zona(xMin = 7,  xMax = 9, yMin = 11, yMax = 11), //mesa Fernet
        new Zona(xMin = 11, xMax = 14, yMin = 11, yMax = 11), //mesa de entrega
        new Zona(xMin = 18, xMax = 22, yMin = 11, yMax = 11),//hornos
        new Zona(xMin = 12, xMax = 24, yMin = 3, yMax = 3)//mesada de ingredientes
    ]
){}

object mapaNivel5 inherits Mapa(
    zonas = [
        new Zona(xMin = 4,  xMax = 24, yMin = 7, yMax = 10),   // piso principal
        new Zona(xMin = 10, xMax = 13, yMin = 11, yMax = 11),  // entre los hornos y el sofá
        new Zona(xMin = 11, xMax = 17, yMin = 3, yMax = 6),    // piso inferior centro
        new Zona(xMin = 19, xMax = 24, yMin = 3, yMax = 6),    // piso inferior derecha
        new Zona(xMin = 25, xMax = 25, yMin = 7, yMax = 9)     // carril entre bacha y tabla
    ],
    bloqueados = [
        new Zona(xMin = 11, xMax = 11, yMin = 3, yMax = 3),    // tacho de basura
        new Zona(xMin = 12, xMax = 13, yMin = 6, yMax = 6),    // hueco medio
        new Zona(xMin = 15, xMax = 16, yMin = 4, yMax = 5),    // hueco inferior
        new Zona(xMin = 9,  xMax = 9,  yMin = 9, yMax = 9),    // hueco chico
        new Zona(xMin = 6,  xMax = 7,  yMin = 9, yMax = 10),   // hueco arriba izquierda
        new Zona(xMin = 22, xMax = 22, yMin = 9, yMax = 10),   // hueco arriba derecha
        new Zona(xMin = 19, xMax = 20, yMin = 8, yMax = 9),    // tablón de comida
        new Zona(xMin = 18, xMax = 18, yMin = 3, yMax = 8)     // mesada de armado
    ]
){}
