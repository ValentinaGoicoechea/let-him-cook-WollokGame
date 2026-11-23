import musicaYSonidos.*
import wollok.game.*
import pedidos.*
import personajeprincipal.*
import comida.*
import puntaje.*
import estados.*
import tareas.*
import niveles.*



//MANEJO DE ESTACIONES DE LA COCINA + STOCK DEL DEPOSTIO + ENTREGAS
//COSAS A CAMBIAR 
//Cambiar el elemento estacion y el elemento stock

class Estacion{
    var property position 
    var prendido = false
    var estaOcupado = false
    const tiempoTarea
    const imagen1
    const imagen2
    const tareaAsociada
    const property numeroEstacion 
    const property esMesadaArmado = false //ver si modificamos esto
    
    method reproducirSonido(){}
    method imagenPrendida() = imagen1 

    method image(){
        if(prendido){
            return self.imagenPrendida()
        } else{
            return imagen2
        }
    }

    method tareaDeEstacion(jugador, objeto) {
        if(objeto != null){
            if(objeto.tareas().contains(tareaAsociada) && !estaOcupado){
                prendido = true
                estaOcupado = true
                objeto.nuevaPosicion(position)
                jugador.soltarObjeto() 
                objeto.sePuedeAgarrar(false)
                self.reproducirSonido()
                game.schedule(tiempoTarea, { 
                        tareaAsociada.ejecutar(objeto)
                        objeto.sePuedeAgarrar(true)
                        self.tareaExtra(objeto)
                }
                )
            }
        }
    }


    method agarrar(personaje){}
    method soltar(personaje){}
    method permiteApoyar() = false
        
    method tareaExtra(objeto) {
        self.liberar()
    }

    method liberar(){
        prendido = false
        estaOcupado = false
    }
}

class MesaFernet inherits Estacion{
    override method reproducirSonido(){
        //game.sound("sonidos/sonidoFernet.mp3").play()
        controladorSonidos.reproducirSonido(game.sound("sonidos/sonidoFernet.mp3"), 0.4)
    }
}

const mesaFernet1 = new MesaFernet(
    position = game.at(19,11),
    tiempoTarea = 4000, 
    imagen1 = "imagenesEstaciones/mesadaFernet.png", 
    imagen2 = "imagenesEstaciones/mesadaFernet.png", 
    tareaAsociada = tareaLlenar,
    numeroEstacion = 1)


const mesaFernet2 = new MesaFernet(
    position = game.at(20,11),
    tiempoTarea = 4000, 
    imagen1 = "imagenesEstaciones/vacio.png", 
    imagen2 = "imagenesEstaciones/vacio.png", 
    tareaAsociada = tareaLlenar,
    numeroEstacion = 2)


const mesaFernet3 = new MesaFernet(
    position = game.at(21,11),
    tiempoTarea = 4000, 
    imagen1 = "imagenesEstaciones/vacio.png", 
    imagen2 = "imagenesEstaciones/vacio.png", 
    tareaAsociada = tareaLlenar,
    numeroEstacion = 3)

class CartelPrecaucion { //ver donde lo movemos
    var property position
    method image() = "cartelPrecaucion.png"
    method permiteApoyar() = false
}

class Horno inherits Estacion( tiempoTarea = 7000, imagen1 = "imagenesEstaciones/hornoprendido.gif", imagen2 = "imagenesEstaciones/hornoapagado.png",tareaAsociada = tareaCocinar){
    var precaucion = null
    const sonidoActual
    var sonido = null

    override method reproducirSonido(){
        controladorSonidos.reproducirSonido(game.sound(sonidoActual), 0.4)
    }

    method controlarQuemado(objeto){
        var tiempoHastaQuemarse = 10 //si está mas de 10 segundos despues de cocinarse se quema
        var nombreTick
        if(numeroEstacion == 1) nombreTick = "controlarQuemado1" //Ver como cambiar esto
        if(numeroEstacion == 2) nombreTick = "controlarQuemado2"

        self.crearCartelPrecaucion()
        game.onTick(500, nombreTick, { //controla cada medio segundo
            if(tiempoHastaQuemarse == 0){ //no me importa la posicion, si llego a 0 se quemó
                self.liberar()
                tareaQuemar.ejecutar(objeto)
                game.removeTickEvent(nombreTick)
                game.removeVisual(precaucion)
            } else if (tiempoHastaQuemarse == 5) {
                game.addVisual(precaucion)
                tiempoHastaQuemarse -= 0.5
            } else {
                if(objeto.position() != position){ // si lo saque
                    sonido.stop()
                    self.liberar()
                    game.removeTickEvent(nombreTick)
                    game.removeVisual(precaucion)//Quitar cartel
                }else{
                    tiempoHastaQuemarse -= 0.5
                }
            }
            })
    }
    override method tareaExtra(objeto){
        self.controlarQuemado(objeto)
    }
    method crearCartelPrecaucion() {
        var posicionX = position.x() + 0.5
        var posicionY = position.y() + 2
        precaucion = new CartelPrecaucion (
                    position = game.at(posicionX, posicionY) 
                )
    }
}

//INSTANCIANDO TODAS LAS ESTACIONES 
const horno1 = new Horno(
    position = game.at(6,11),
    numeroEstacion = 1,
    sonidoActual = "sonidos/sonidoCocina1.mp3"
)

const horno2 = new Horno(
    position = game.at(8,11),
    numeroEstacion = 2,
    sonidoActual = "sonidos/sonidoCocina2.mp3"
)

object basura inherits Estacion(
    position = game.at(20,7),
    tiempoTarea = 500,
    imagen1 = "imagenesEstaciones/basuraAbierta.png",
    imagen2 = "imagenesEstaciones/basura.png",
    tareaAsociada = tareaTirar,
    numeroEstacion = 1
){
    override method reproducirSonido(){
        controladorSonidos.reproducirSonido(game.sound("sonidos/sonidoBasura.mp3"), 1)
    }
}

object bacha inherits Estacion(
    position = game.at(4,6),
    tiempoTarea = 3000,
    imagen1 = "imagenesEstaciones/bachaAbierta.gif", 
    imagen2 = "imagenesEstaciones/vacio.png",
    tareaAsociada = tareaLimpiar,
    numeroEstacion = 1

){
    var property imagenAbierta = "imagenesEstaciones/bachaAbierta.gif"
    override method imagenPrendida() = imagenAbierta

    override method reproducirSonido(){
        controladorSonidos.reproducirSonido(game.sound("sonidos/sonidoBacha.mp3"), 1)
    }
}

object tablaDeCortar inherits Estacion(
    position = game.at(4,9),
    tiempoTarea = 4500,
    imagen1 = "imagenesEstaciones/tablaDeCortar.png", 
    imagen2 = "imagenesEstaciones/tablaDeCortar.png", // hacer cambio (para notar que esta en uso)
    tareaAsociada = tareaCortar,
    numeroEstacion = 1
){
    override method reproducirSonido(){
        controladorSonidos.reproducirSonido(game.sound("sonidos/sonidoCortar.mp3"), 1)
    }
}

class Mesada{
    var property position
    const property image
    method tareaDeEstacion(jugador, objeto)
    
    method agarrar(personaje){}
    method soltar(personaje){}
    method permiteApoyar() = false
}

class MesadaEntrega inherits Mesada{
    var property contador = 0 
    const property esMesadaArmado = false //CAMBIAR ESTO 

    method devolverPlatoSucio(plato){
        plato.position(plato.posicionPlatoSucio())
        plato.estado(sucio)
        plato.estaEnPlato(false)
    }

    method resetearPlatoArmado(plato){
        plato.vaciarElementos()
        plato.elementosPlato().clear() 
        game.removeVisual(plato)
    }
    
    method tomarPlato(plato){
        const platoUsado = plato.elementosPlato().findOrDefault({elemento => !elemento.debeEliminarseAlVaciar()}, null) //busca elemento que no deba eliminarse al vaciar (plato)
        if(platoUsado != null){
            self.resetearPlatoArmado(plato)
            self.devolverPlatoSucio(platoUsado)
        }
    }
 
    method procesoPlato(pedido, plato){
        pedido.seEntrego(true)
        generadorDePedidos.listaPedidos().remove(pedido)
        puntajeEnJuego.sumar(puntajeEnJuego.asignarPuntos(pedido, plato))
        game.removeVisual(pedido)
        self.tomarPlato(plato)
    }

    override method tareaDeEstacion(jugador,objeto){
        if(objeto != null){objeto.entregarEnMesaEntrega(jugador, self)}
    }
}

const mesadaEntrega1 = new MesadaEntrega(
    position = game.at(14,11),
    image = "imagenesEstaciones/mesada.png"
)

const mesadaEntrega2 = new MesadaEntrega(
    position = game.at(15,11),
    image = "imagenesEstaciones/vacio.png"
)

const mesadaEntrega3 = new MesadaEntrega(
    position = game.at(16,11),
    image = "imagenesEstaciones/vacio.png"
)


class MesadaArmado inherits Mesada{
    const property esMesadaArmado = true
    var property platoEnArmado = null
    var property hayPlatoParaArmar = false

    method crearPlatoArmado(){
      platoEnArmado = new PlatoArmado(mesadaActual = self,position = position) 
    }

    method recibirPlatoLimpio(jugador, objeto){
        if(platoEnArmado == null){
            self.crearPlatoArmado()
            game.addVisual(platoEnArmado)               
            platoEnArmado.elementosPlato().add(objeto) 
            objeto.estaEnPlato(true)  
            objeto.nuevaPosicion(position)
            jugador.soltarObjeto() 
            hayPlatoParaArmar = true
                
        } 
    }

    method recibirPlatoArmado(jugador, objeto){
        if(platoEnArmado == null){
            hayPlatoParaArmar = true
            platoEnArmado = objeto 
            objeto.mesadaActual(self)
            objeto.nuevaPosicion(position)
            jugador.soltarObjeto()
        }
    }

    method recibirComida(jugador, objeto){
        if(hayPlatoParaArmar){ 
            platoEnArmado.elementosPlato().add(objeto)
            objeto.estaEnPlato(true) 
            objeto.nuevaPosicion(position)
            jugador.soltarObjeto()
        }
    }


    override method tareaDeEstacion(jugador, objeto){
        if(objeto != null){
            objeto.colocarseEnMesadaArmado(jugador, self)} //le mando la mesadaDeArmado por parametro
    }

    method agarrarPlatoArmado() {
        if( platoEnArmado != null && platoEnArmado.sePuedeAgarrar()){
            hayPlatoParaArmar = false
            platoEnArmado = null 
        }
    }

    method reiniciar() { //Método para reiniciar cuando cambio el nivel si habia algun plato armado en la mesa
        if (platoEnArmado != null) {
            if (game.allVisuals().contains(platoEnArmado)) {
                game.removeVisual(platoEnArmado)
            }
            platoEnArmado = null
        }
        hayPlatoParaArmar = false
    }
}


const mesadaArmado1 = new MesadaArmado(
    position = game.at(25,7),
    image = "imagenesEstaciones/mesadaArmado.png"
)


const mesadaArmado2 = new MesadaArmado(
    position = game.at(25,9),
    image = "imagenesEstaciones/vacio.png"
)


const mesadaArmado3 = new MesadaArmado(
    position = game.at(25,11),
    image = "imagenesEstaciones/vacio.png"
)


class Cajon {
    var property position 
    var property posicionAlimento
    const stockMaximo = 5
    const alimentos = [] 
    const imagenCajon
    const property esMesadaArmado = false

    method estaEnPlato() = false
    method image() = imagenCajon

    method agarrar(personaje){}
    method soltar(personaje){}
    method permiteApoyar() = false

    method cantidadEnStock() {
        return alimentos.count({alimento => alimento.position() == posicionAlimento })
    }

    method crearAlimento(){}
    
    method reponerStock() {
        if (self.cantidadEnStock() == 0) { 
            stockMaximo.times({ _ => 
                const nuevoAlimento = self.crearAlimento()
                alimentos.add(nuevoAlimento)
                game.addVisual(nuevoAlimento)
            })
        }
    }

    method tareaDeEstacion(personaje, objeto){
        if(objeto == null) self.reponerStock()
    }

    method reiniciarPorFinDeNivel() {
        alimentos.forEach({ alimento => 
            if (game.allVisuals().contains(alimento)) {
                game.removeVisual(alimento)
            }
        })
        alimentos.clear()
    }
}

object cajonDePapas inherits Cajon (
    position = game.at(22,6),
    posicionAlimento = game.at(9,3),
    imagenCajon = "imagenesCajones/cajonDePapas.png"){
    override method crearAlimento() = new Comida(tipo = tipoPapa, position = posicionAlimento)
}

object cajonDePollo inherits Cajon (
    position = game.at(20,6),
    posicionAlimento = game.at(6,3),
    imagenCajon = "imagenesCajones/cajonDePollo.png"){
    override method crearAlimento() = new Comida(tipo = tipoPollo, position = posicionAlimento)
}

object cajonDeHuevo inherits Cajon (
    position = game.at(24,6),
    posicionAlimento = game.at(11,3),
    imagenCajon = "imagenesCajones/cajonDeHuevos.png"){ 
    override method crearAlimento() = new Comida(tipo= tipoHuevo,position = posicionAlimento)
}

object cajonDeBife inherits Cajon (
    position = game.at(20,3),
    posicionAlimento = game.at(13,3),
    imagenCajon = "imagenesCajones/cajonDeOjoDeBife.png"){ 
    override method crearAlimento() = new Comida(tipo = tipoBife,position = posicionAlimento)
}

