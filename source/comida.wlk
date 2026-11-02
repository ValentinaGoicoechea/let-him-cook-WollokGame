import source.ambiente.*
import wollok.game.*
import estados.*
import personajeprincipal.* 
import puntaje.*
import pedidos.*
import tareas.*

//Ver si tiene sentido lo ultimo de que el plato armado sepa entregarse (por eso se agregan los ultimos 3 imports)

// COMIDAS Y VAJILLA (CLASES Y OBJETOS)


class Comida{
    var property position 
    var property estado = cruda //asi comienzan todas las comidas
    var property estaEnPlato = false
    var property sePuedeAgarrar = true 
    var property debeEliminarseAlVaciar = true //util para saber si al estar en un plato armado debo sacarlos o no

    method nuevaPosicion(posicion){
        self.position(posicion)
    }
    
    method vaciarElementos() {}
    method entregarEnMesaEntrega(){}

    method desaparecer() {
        game.removeVisual(self)
    }

    method procesarEnMesadaEntrega(mesadaEntrega) {}

    method colocarseEnMesadaArmado(){
        MesadaArmado.recibirComida(self)
    }

    method clase() = self.className() //ver si cambiamos esto

    method cumpleRequerimiento(tipoComida, estadoEsperado){
        return (self.clase() == tipoComida && self.estado() == estadoEsperado)
    }

    method tareasCruda() = [tareaCocinar, tareaTirar] //ahora son objetos 
    method tareasCortada() = [] //solo papa 
   
    method image() {estado.image(self)} //la imagen se activa segun el estado en el que se encuentra
}


class PechugaDePollo inherits Comida{

    method imagenCruda() = "imagenesComida-Vajilla/pechuga.png"
    method imagenCocinada() = "imagenesComida-Vajilla/pechugacocinada.png"
    method imagenQuemada() = "imagenesComida-Vajilla/pechugaquemada.png"
    
}

class Papa inherits Comida{
    method imagenCruda() = "imagenesComida-Vajilla/papaCruda.png"
    method imagenCortada() = "imagenesComida-Vajilla/papaCortada.png"
    method imagenCocinada() = "imagenesComida-Vajilla/papaFrita.png"
    method imagenQuemada() = "imagenesComida-Vajilla/papaFritaQuemada.png"

    override method tareasCruda() = [tareaCortar, tareaTirar] //es el unico que puede (y debe) cortarse antes de cocinarse
    override method tareasCortada() = [tareaCocinar, tareaTirar]

}

class OjoDeBife inherits Comida {
    method imagenCruda() = "imagenesComida-Vajilla/ojoBife.png"
    method imagenCocinada() = "imagenesComida-Vajilla/ojoBifeCocinado.png"
    method imagenQuemada() = "imagenesComida-Vajilla/ojoBifeQuemado.png"
}

class Huevo inherits Comida {
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
    method desaparecer(){} //plato no hace nada

    method entregarEnMesaEntrega(){}

    method clase() = self.className()

    method image() {estado.image(self)} //la imagen se activa segun el estado en el que se encuentra
    method tareas() = estado.tareas(self)
}
class Plato inherits Vajilla {  
    var property debeEliminarseAlVaciar = false

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
    
    override method desaparecer(){
        self.vaciarElementos()
        self.sePuedeAgarrar(true)
    }

    method vaciarElementos() {
    elementosPlato.forEach({ elemento => 
        if (elemento.debeEliminarseAlVaciar()) {
            game.removeVisual(elemento)
            elementosPlato.remove(elemento)
        }
    })
    }

    override method entregarEnMesaEntrega(){ //Ver si tiene sentido que este aca
        const pedido = selectorPedidos.eleccionDePedido(elementosPlato)
            personajePrincipal.agarrarOSoltar()
            if (pedido == null) { 
                puntajeEnJuego.restar(100)  
                MesadaEntrega.tomarPlato(self)
            } else{
                MesadaEntrega.procesoPlato(pedido, self)
            }
    }
}
