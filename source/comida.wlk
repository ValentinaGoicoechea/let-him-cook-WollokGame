import source.ambiente.*
import wollok.game.*
import estados.*
import personajeprincipal.* 
import puntaje.*
import pedidos.*
import tareas.*

//Ver si tiene sentido lo ultimo de que el plato armado sepa entregarse (por eso se agregan los ultimos 3 imports)

// COMIDAS Y VAJILLA (CLASES Y OBJETOS)

class TipoDeComida{
    const property nombre
    method tareasCruda() = [tareaCocinar, tareaTirar] //Cambia en las papas
    method tareasCortada() = []

}
const tipoBife = new TipoDeComida(nombre = "ojoBife")
const tipoHuevo = new TipoDeComida(nombre = "huevo")
const tipoPollo = new TipoDeComida(nombre = "pechuga")
const tipoVaso = new TipoDeComida(nombre = "vaso")
object tipoPapa inherits TipoDeComida(nombre = "papa"){
    override method tareasCruda() = [tareaCortar, tareaTirar]
    override method tareasCortada() = [tareaCocinar, tareaTirar]
}

class Comida{
    const property tipo
    var property position 
    var property estado = cruda //asi comienzan todas las comidas
    var property estaEnPlato = false
    var property sePuedeAgarrar = true 
    var property debeEliminarseAlVaciar = true //util para saber si al estar en un plato armado debo sacarlos o no

    method image() = "imagenesComida-Vajilla/" + tipo.nombre() + estado.nombre() + ".png"
    method tareas() = estado.tareas(tipo)

    method cumpleRequerimiento(tipoEsperado, estadoEsperado) {
        return tipo == tipoEsperado && estado == estadoEsperado
    }
    
    method nuevaPosicion(posicion){self.position(posicion)}
    method desaparecer() {game.removeVisual(self)}
    method colocarseEnMesadaArmado(jugador, mesadaArmado){mesadaArmado.recibirComida(jugador, self)}

    method agarrar(personaje){
        if (sePuedeAgarrar && !estaEnPlato) {
            personaje.agarroObjeto(self)
        }
    }

    method soltar(personaje){personaje.sueltoObjeto(self)}
    method vaciarElementos() {}
    method entregarEnMesaEntrega(jugador,mesadaEntrega){}
    method tareaDeEstacion(objeto){} //PARA NO ROMPER EL POLIMORFISMO CON LAS ESTACIONES   
    method invalidaEntrega() = estado.invalidaEntrega()
}

class Vajilla {
    var property position
    var property posicionInicial = position
    var property estaEnPlato = false
    var property sePuedeAgarrar = true
    var property estado

    method nuevaPosicion(posicion){
        self.position(posicion)
    }
    method desaparecer(){} //plato no hace nada
    method tareaDeEstacion(objeto){} //PARA NO ROMPER EL POLIMORFISMO CON LAS ESTACIONES

    method entregarEnMesaEntrega(jugador,mesadaEntrega){}
    
    method agarrar(personaje){
        if (sePuedeAgarrar && !estaEnPlato) {
            personaje.agarroObjeto(self)
        }
    }

    method soltar(personaje){
        personaje.sueltoObjeto(self)
    }

    method colocarseEnMesadaArmado(jugador, mesada){
        estado.colocarseEnMesadaArmado(jugador, self, mesada)
    }
    
    method clase() = self.className()

    method image() = estado.image(self) //la imagen se activa segun el estado en el que se encuentra
    method tareas() = estado.tareas(self)

    method reiniciar() {
        position = posicionInicial
        estado = limpio          
        estaEnPlato = false
        sePuedeAgarrar = true
    }
    method tieneAlgunElementoQuemado() = false
    method invalidaEntrega() = false
}
class Vaso inherits Vajilla(position = game.at(4,8)){
    const property tipo = tipoVaso
    method elementosPlato() = [] 
    method imagenLimpio() = "imagenesComida-Vajilla/vaso.png"
    method imagenLleno() = "imagenesComida-Vajilla/vasoFernet.png"
    
    method cumpleRequerimiento(tipoEsperado, estadoEsperado) {
        return tipo == tipoEsperado && estado == estadoEsperado
    }
    
    override method colocarseEnMesadaArmado(jugador, mesada){} //no hace nada
    override method tareas() = [tareaLlenar]

    /*override method reiniciar(){
        position = posicionInicial
        estado = limpio
        sePuedeAgarrar = true
    }
    */

    override method entregarEnMesaEntrega(jugador, mesadaEntrega){
        const pedido = selectorPedidos.eleccionDePedido([self]) 
        jugador.agarrarOSoltar()

        if (pedido == null) { 
            puntajeEnJuego.restar(100)  
        } else{
            mesadaEntrega.procesoPlato(pedido, self)
        }
        self.reiniciar()
    }
}


const vaso1 = new Vaso(estado=limpio)
const vaso2 = new Vaso(estado=limpio)
const vaso3 = new Vaso(estado=limpio)
class Plato inherits Vajilla(){  
    var property posicionPlatoSucio = game.at(4,5)
    var property debeEliminarseAlVaciar = false

    method imagenLimpio() = "imagenesComida-Vajilla/plato.png"
    method imagenSucio() = "imagenesComida-Vajilla/platoSucio.png"
}

const plato1 = new Plato(position = game.at(16,3),estado = limpio)
const plato2 = new Plato(position = game.at(16,3),estado = limpio)
const plato3 = new Plato(position = game.at(16,3),estado = limpio)

class PlatoArmado inherits Vajilla(estado = platoArmado){
    var property elementosPlato = []
    var property mesadaActual 
    
    override method nuevaPosicion(nuevaPos) {
        position = nuevaPos
        elementosPlato.forEach({ elem => elem.position(nuevaPos) })
    } 
    
    override method desaparecer(){
        self.vaciarElementos()
        game.removeVisual(self) //NUEVO CAMBIO
    }

    override method agarrar(personaje){
        if (mesadaActual != null) {
            mesadaActual.agarrarPlatoArmado() //le avisa a la mesada que no esta mas el plato
            mesadaActual = null
        }
        personaje.agarroObjeto(self)
    }


    method vaciarElementos() {
    elementosPlato.forEach({ elemento => 
        if (elemento.debeEliminarseAlVaciar()) {
            game.removeVisual(elemento)
            elementosPlato.remove(elemento)
        }else{
            elemento.estaEnPlato(false)
            elemento.sePuedeAgarrar(true)
        }
    })
    }

    override method entregarEnMesaEntrega(jugador, mesadaEntrega){ //Ver si tiene sentido que este aca
        const comidas = elementosPlato.filter({elem => elem.debeEliminarseAlVaciar()})
        const pedido = selectorPedidos.eleccionDePedido(comidas) //No compara el plato

        jugador.agarrarOSoltar()
        if (pedido == null) { 
            puntajeEnJuego.restar(100)  
            mesadaEntrega.tomarPlato(self)
        } else{
            mesadaEntrega.procesoPlato(pedido, self)
        }
    }

    override method tieneAlgunElementoQuemado() = elementosPlato.any({elemento => elemento.invalidaEntrega()})
}
