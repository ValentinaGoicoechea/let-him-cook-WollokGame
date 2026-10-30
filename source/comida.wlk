import source.ambiente.*
import wollok.game.*
import estados.*

// COMIDAS Y VAJILLA (CLASES Y OBJETOS)


class Comida{
    var property position 
    var property estado = cruda //asi comienzan todas las comidas
    var property estaEnPlato = false
    var property sePuedeAgarrar = true 

    method nuevaPosicion(posicion){
        self.position(posicion)
    }
    
    method vaciarElementos() {}

    method desaparecerDeBasura() {
        game.removeVisual(self)
    }

    method procesarEnMesadaEntrega(mesadaEntrega) {} //no suelta nada en la mesa de entrega, no hace nada

    method colocarseEnMesadaArmado(){
        MesadaArmado.recibirComida(self)
    }

    method tareasCruda() = ["cocinar", "tirar"]
    method tareasCortada() = [] //solo papa 
    method image() {estado.image(self)} //la imagen se activa segun el estado en el que se encuentra
    method tareas() = estado.tareas(self)

}


class PechugaDePollo inherits Comida{
    method nombreCruda() = "pechugaDePollo"
    method nombreCocinada() = "pechugacocinada"
    method nombreQuemada() = "pechugaQuemada"

    method imagenCruda() = "imagenesComida-Vajilla/pechuga.png"
    method imagenCocinada() = "imagenesComida-Vajilla/pechugacocinada.png"
    method imagenQuemada() = "imagenesComida-Vajilla/pechugaquemada.png"
    
}

class Papa inherits Comida{

    method nombreCruda() = "papaCruda"
    method nombreCortada() = "papaCortada"
    method nombreCocinada() = "papasFritas"
    method nombreQuemada() = "papaFritaQuemada"

    method imagenCruda() = "imagenesComida-Vajilla/papaCruda.png"
    method imagenCortada() = "imagenesComida-Vajilla/papaCortada.png"
    method imagenCocinada() = "imagenesComida-Vajilla/papaFrita.png"
    method imagenQuemada() = "imagenesComida-Vajilla/papaFritaQuemada.png"

    override method tareasCruda() = ["cortar", "tirar"] //es el unico que puede (y debe) cortarse antes de cocinarse
    override method tareasCortada() = ["cocinar", "tirar"]

}

class OjoDeBife inherits Comida {
    method nombreCruda() = "ojoBife"
    method nombreCocinada() = "ojoBifeCocinado"
    method nombreQuemada() = "ojoBifeQuemado"

    method imagenCruda() = "imagenesComida-Vajilla/ojoBife.png"
    method imagenCocinada() = "imagenesComida-Vajilla/ojoBifeCocinado.png"
    method imagenQuemada() = "imagenesComida-Vajilla/ojoBifeQuemado.png"
}

class Huevo inherits Comida {
    method nombreCruda() = "huevo"
    method nombreCocinada() = "huevoFrito"
    method nombreQuemada() = "huevoFritoQuemado"

    method imagenCruda() = "imagenesComida-Vajilla/huevo.png"
    method imagenCocinada() = "imagenesComida-Vajilla/huevoFrito.png"
    method imagenQuemada() = "imagenesComida-Vajilla/huevoFritoQuemado.png"
}

class Vajilla {
    var property position
    var property estaEnPlato = false
    var property sePuedeAgarrar = true
    var property estado

    method nuevaPosicion(posicion){
        self.position(posicion)
    }

    method image() {estado.image(self)} //la imagen se activa segun el estado en el que se encuentra
    method tareas() = estado.tareas(self)
}
class Plato inherits Vajilla {  
    method colocarseEnMesadaArmado(){
        estado.colocarseEnMesadaArmado(self)

    }

    method imagenLimpio() = "imagenesComida-Vajilla/plato.png"
    method imagenSucio() = "imagenesComida-Vajilla/platoSucio.png"
}

const plato1 = new Plato(
    position = game.at(16,3),
    estado = limpio
)

const plato2 = new Plato(
    position = game.at(16,3),
    estado = limpio
)

const plato3 = new Plato(
    position = game.at(16,3),
    estado = limpio
)

class PlatoArmado inherits Vajilla(estado = platoArmado){
    var property elementosPlato = []
    
    override method nuevaPosicion(nuevaPos) {
        position = nuevaPos
        elementosPlato.forEach({ elem => elem.position(nuevaPos) })
    } 
    
    method vaciarElementos() {
    elementosPlato.forEach({ elemento => 
        if (elemento.elemento() != "plato") {
            game.removeVisual(elemento)
            elementosPlato.remove(elemento)
        }
    })
   
}

}
