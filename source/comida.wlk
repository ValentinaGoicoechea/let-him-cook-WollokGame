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
    method tareasCruda() = [tareaCocinar, tareaTirar] //Cambia en las papas
    method tareasCortada() = []

    method imagenCruda()
    method imagenCocinada()
    method imagenQuemada()
    method imagenCortada() = "" //solo la papa
}

object tipoBife inherits TipoDeComida (){
    override method imagenCruda() = "imagenesComida-Vajilla/ojoBife.png"
    override method imagenCocinada() = "imagenesComida-Vajilla/ojoBifeCocinado.png"
    override method imagenQuemada() = "imagenesComida-Vajilla/ojoBifeQuemado.png"
}

object tipoHuevo inherits TipoDeComida{
    override method imagenCruda() = "imagenesComida-Vajilla/huevo.png"
    override method imagenCocinada() = "imagenesComida-Vajilla/huevoFrito.png"
    override method imagenQuemada() = "imagenesComida-Vajilla/huevoFritoQuemado.png"
}

object tipoPollo inherits TipoDeComida {
    override method imagenCruda() = "imagenesComida-Vajilla/pechuga.png"
    override method imagenCocinada() = "imagenesComida-Vajilla/pechugacocinada.png"
    override method imagenQuemada() = "imagenesComida-Vajilla/pechugaquemada.png"
}

object tipoPapa inherits TipoDeComida {
    override method imagenCruda() = "imagenesComida-Vajilla/papaCruda.png"
    override method imagenCortada() = "imagenesComida-Vajilla/papaCortada.png"
    override method imagenCocinada() = "imagenesComida-Vajilla/papaFrita.png"
    override method imagenQuemada() = "imagenesComida-Vajilla/papaFritaQuemada.png"
   

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

    method image() = estado.image(tipo) //la imagen se activa segun el estado en el que se encuentra
    method tareas() = estado.tareas(tipo)

    method cumpleRequerimiento(tipoEsperado, estadoEsperado) {
        return tipo == tipoEsperado && estado == estadoEsperado
    }
    
    method nuevaPosicion(posicion){self.position(posicion)}
    method desaparecer() {game.removeVisual(self)}
    method colocarseEnMesadaArmado(mesadaArmado){mesadaArmado.recibirComida(self)}

    method agarrar(personaje){
        if (sePuedeAgarrar && !estaEnPlato) {
            personaje.agarroObjeto(self)
        }
    }

    method soltar(personaje){personaje.sueltoObjeto(self)}
    method vaciarElementos() {}
    method entregarEnMesaEntrega(mesadaEntrega){}
    method tareaDeEstacion(objeto){} //PARA NO ROMPER EL POLIMORFISMO CON LAS ESTACIONES   
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
    method tareaDeEstacion(objeto){} //PARA NO ROMPER EL POLIMORFISMO CON LAS ESTACIONES

    method entregarEnMesaEntrega(mesadaEntrega){}
    
    method agarrar(personaje){
        if (sePuedeAgarrar && !estaEnPlato) {
            personaje.agarroObjeto(self)
        }
    }

    method soltar(personaje){
        personaje.sueltoObjeto(self)
    }

    method colocarseEnMesadaArmado(mesada){
        estado.colocarseEnMesadaArmado(self, mesada)
    }
    
    method clase() = self.className()

    method image() = estado.image(self) //la imagen se activa segun el estado en el que se encuentra
    method tareas() = estado.tareas(self)
}
class Plato inherits Vajilla {  
    var property debeEliminarseAlVaciar = false

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
        mesadaActual.agarrarPlatoArmado() //le avisa a la mesada que no esta mas el plato
        mesadaActual = null
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

    override method entregarEnMesaEntrega(mesadaEntrega){ //Ver si tiene sentido que este aca
        const comidas = elementosPlato.filter({elem => elem.debeEliminarseAlVaciar()})
        const pedido = selectorPedidos.eleccionDePedido(comidas) //No compara el plato

        personajePrincipal.agarrarOSoltar()
        if (pedido == null) { 
            puntajeEnJuego.restar(100)  
            mesadaEntrega.tomarPlato(self)
        } else{
            mesadaEntrega.procesoPlato(pedido, self)
        }
    }
}
