import wollok.game.*
import pedidos.*
import personajeprincipal.*
import comida.*
import puntaje.*
import estados.*

//MANEJO DE ESTACIONES DE LA COCINA + STOCK DEL DEPOSTIO + ENTREGAS

class Estacion{
    const property position
    var prendido = false
    var estaOcupado = false
    const tiempoTarea
    const imagen1
    const imagen2
    const valorOtorgado
    const debeValidar
    const property esMesadaArmado = false //ver si modificamos esto
    const property numeroEstacion

    method sePuedeAgarrar() = false
    method elemento() = "estacion"

    method image(){
        if(prendido){
            return imagen1
        } else{
            return imagen2
        }
    }

    method tareaDeEstacion(objeto) {
        if(objeto.estado().tareas().contains(debeValidar) && !estaOcupado){
            prendido = true
            estaOcupado = true
            personajePrincipal.agarrarOSoltar() //el personaje principal suelta el objeto
            objeto.sePuedeAgarrar(false)
            game.schedule(tiempoTarea, { 
                    objeto.estado(valorOtorgado)
                    objeto.sePuedeAgarrar(true)
                    self.tareaExtra(objeto)
            }
            )
            
        }
    }
        
    method tareaExtra(objeto) {
        self.liberar()
    }

    method liberar(){
        prendido = false
        estaOcupado = false
    }
}

class CartelPrecaucion { //ver donde lo movemos
    var property position
    method image() = "cartelPrecaucion.png"
}

class Horno inherits Estacion{
    var precaucion = null

    method controlarQuemado(objeto){
        var tiempoHastaQuemarse = 10 //si está mas de 10 segundos despues de cocinarse se quema
        var nombreTick
        if(numeroEstacion == 1) nombreTick = "controlarQuemado1" //Ver como cambiar esto
        if(numeroEstacion == 2) nombreTick = "controlarQuemado2"

        self.crearCartelPrecaucion()
        game.onTick(500, nombreTick, { //controla cada medio segundo
            if(tiempoHastaQuemarse == 0){ //no me importa la posicion, si llego a 0 se quemó
                self.liberar()
                objeto.estado(quemada)
                game.removeTickEvent(nombreTick)
                game.removeVisual(precaucion)
            } else if (tiempoHastaQuemarse == 5) {
                game.addVisual(precaucion)
                tiempoHastaQuemarse -= 0.5
            } else {
                if(objeto.position() != position){ // si lo saque
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

const horno1 = new Horno(
    position = game.at(6,11),
    tiempoTarea = 7000,
    imagen1 = "imagenesEstaciones/hornoprendido.png",
    imagen2 = "imagenesEstaciones/hornoapagado.png",
    valorOtorgado = "cocinado",
    debeValidar = "cocinar",
    numeroEstacion = 1
)


const horno2 = new Horno(
    position = game.at(8,11),
    tiempoTarea = 7000,
    imagen1 = "imagenesEstaciones/hornoprendido.png",
    imagen2 = "imagenesEstaciones/hornoapagado.png",
    valorOtorgado = "cocinado",
    debeValidar = "cocinar",
    numeroEstacion = 2
)

object basura inherits Estacion(
    position = game.at(20,7),
    tiempoTarea = 500,
    imagen1 = "imagenesEstaciones/basuraAbierta.png",
    imagen2 = "imagenesEstaciones/basura.png",
    valorOtorgado = "tirado",
    debeValidar = "tirar",
    numeroEstacion = 1
){
    override method tareaExtra(objeto){
        objeto.sePuedeAgarrar(false)

        if(objeto.elemento() == "plato armado"){ //solo se va a usar en tirar
            objeto.elementosPlato().forEach({elemento => if (elemento.elemento() != "plato")
                {game.removeVisual(elemento)
                objeto.elementosPlato().remove(elemento)}                
            })
            objeto.sePuedeAgarrar(true)
             
        }else{
            game.removeVisual(objeto)            
        }
        self.liberar()

    }
}


const bacha = new Estacion(
    position = game.at(4,6),
    tiempoTarea = 3000,
    imagen1 = "imagenesEstaciones/vacio.png", //ESPUMA O AGUA
    imagen2 = "imagenesEstaciones/vacio.png",
    valorOtorgado = "limpio",
    debeValidar = "limpiar",
    numeroEstacion = 1
)

const tablaDeCortar = new Estacion(
    position = game.at(4,9),
    tiempoTarea = 4500,
    imagen1 = "imagenesEstaciones/tablaDeCortar.png", 
    imagen2 = "imagenesEstaciones/tablaDeCortar.png", // hacer cambio (para notar que esta en uso)
    valorOtorgado = "cortada",
    debeValidar = "cortar",
    numeroEstacion = 1
)

class Mesada{
    const property position
    const property image

    method elemento() = "estacion"
    method sePuedeAgarrar() = false
    method tareaDeEstacion(objeto)
}

class MesadaEntrega inherits Mesada{
    var property contador = 0 
    const property esMesadaArmado = false

    method devolverPlatoSucio(plato){
        plato.position(game.at(4,5))
        plato.modificado("sucio")
        plato.estaEnPlato(false)
    }

    method resetearPlatoArmado(plato){
        plato.elementosPlato().forEach({elemento => if (elemento.elemento() != "plato"){game.removeVisual(elemento)}}) //cambiar aca
        plato.elementosPlato().clear() 
        game.removeVisual(plato)
    }
    
    method tomarPlato(plato){
        const platoUsado = plato.elementosPlato().findOrDefault({elemento => elemento.elementoYEstado() == "plato"}, null) //cambiar aca
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

    override method tareaDeEstacion(platoArmado){
        if(platoArmado.elemento() == "plato armado"){ //cambiar aca
            const pedido = selectorPedidos.eleccionDePedido(platoArmado.elementosPlato()) 
            personajePrincipal.agarrarOSoltar()
            if (pedido == null) { 
                puntajeEnJuego.restar(100)  
                self.tomarPlato(platoArmado)
            } else{
                self.procesoPlato(pedido, platoArmado)
            }
            
        }
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
      platoEnArmado = new PlatoArmado(position = position) 
    }

    method recibirPlatoLimpio(objeto){
        if(platoEnArmado == null){
            self.crearPlatoArmado()
            game.addVisual(platoEnArmado)               
            platoEnArmado.elementosPlato().add(objeto) 
            objeto.estaEnPlato(true)  
            personajePrincipal.agarrarOSoltar() 
            hayPlatoParaArmar = true
                
        } 
    }

    method recibirPlatoArmado(objeto){
        if(platoEnArmado == null){
            hayPlatoParaArmar = true
            platoEnArmado = objeto 
            personajePrincipal.agarrarOSoltar()
        }
    }

    method recibirComida(objeto){
        if(hayPlatoParaArmar){ 
            platoEnArmado.elementosPlato().add(objeto)
            objeto.estaEnPlato(true) 
            personajePrincipal.agarrarOSoltar()
        }
    }


    override method tareaDeEstacion(objeto){
         objeto.colocarseEnMesadaArmado()      
    }

    method agarrarPlatoArmado() {
        if( platoEnArmado != null && platoEnArmado.sePuedeAgarrar()){
            hayPlatoParaArmar = false
            platoEnArmado = null 
        }
    }
}


const mesadaArmado1 = new MesadaArmado(
    position = game.at(24.5,7),
    image = "imagenesEstaciones/mesadaArmado.png"
)


const mesadaArmado2 = new MesadaArmado(
    position = game.at(24.5,9),
    image = "imagenesEstaciones/vacio.png"
)


const mesadaArmado3 = new MesadaArmado(
    position = game.at(24.5,11),
    image = "imagenesEstaciones/vacio.png"
)


class Cajon {
    const property position 
    const posicionAlimento
    const stockMaximo = 5
    const alimentos = [] 
    const imagenCajon
    const property esMesadaArmado = false

    method sePuedeAgarrar() = false
    method estaEnPlato() = false
    method image() = imagenCajon
    method elemento() = "stock"

    method cantidadEnStock() {
        return alimentos.count({alimento => alimento.position() == posicionAlimento })
    }

    method reponerStock()

    method reiniciarPorFinDeNivel() {
        alimentos.clear()
    }
}

object cajonDePapas inherits Cajon (
    position = game.at(22,6),
    posicionAlimento = game.at(9,3),
    imagenCajon = "imagenesCajones/cajonDePapas.png"){
    override method reponerStock() {
        if (self.cantidadEnStock() == 0) { 
            stockMaximo.times( 
                {papaX => const nuevaPapa = new Papa(position = posicionAlimento, modificado = "");
                alimentos.add(nuevaPapa);
                game.addVisual(nuevaPapa)
                }
            )
        }
    }
}

object cajonDePollo inherits Cajon (
    position = game.at(20,6),
    posicionAlimento = game.at(6,3),
    imagenCajon = "imagenesCajones/cajonDePollo.png"){
    override method reponerStock() {
        if (self.cantidadEnStock() == 0) { 
            stockMaximo.times( 
                {pechugaX => const nuevaPechuga = new PechugaDePollo(position = posicionAlimento, modificado = "");
                alimentos.add(nuevaPechuga);
                game.addVisual(nuevaPechuga)
                }
            )
        }
    }
}

object cajonDeHuevo inherits Cajon (
    position = game.at(24,6),
    posicionAlimento = game.at(11,3),
    imagenCajon = "imagenesCajones/cajonDeHuevos.png"){ // hay que hacer uno para el resto!!
    override method reponerStock() {
        if (self.cantidadEnStock() == 0) { 
            stockMaximo.times( 
                {huevoX => const nuevoHuevo = new Huevo(position = posicionAlimento, modificado = "");
                alimentos.add(nuevoHuevo);
                game.addVisual(nuevoHuevo)
                }
            )
        }
    }
}

object cajonDeBife inherits Cajon (
    position = game.at(20,3),
    posicionAlimento = game.at(13,3),
    imagenCajon = "imagenesCajones/cajonDeOjoDeBife.png"){ // hay que hacer uno para el resto!!
    override method reponerStock() {
        if (self.cantidadEnStock() == 0) { 
            stockMaximo.times( 
                {bifeX => const nuevoOjoBife = new OjoDeBife(position = posicionAlimento, modificado = "");
                alimentos.add(nuevoOjoBife);
                game.addVisual(nuevoOjoBife)
                }
            )
        }
    }
}

