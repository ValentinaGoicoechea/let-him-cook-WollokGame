import wollok.game.*
import pedidos.*
import personajeprincipal.*
import comida.*
import puntaje.*

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
        if(objeto.tareas().contains(debeValidar) && !estaOcupado){ //plato armado solo va a responder a tirar porque es lo unico que puede hacer
            prendido = true
            estaOcupado = true
            personajePrincipal.agarrarOSoltar() //el personaje principal suelta el objeto
            objeto.sePuedeAgarrar(false)
            game.schedule(tiempoTarea, { 
                    objeto.modificado(valorOtorgado)
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

class CartelPrecaucion {
    var property position
    method image() = "cartelPrecaucion.png"
}

class Horno inherits Estacion{
    var precaucion = null

    method controlarQuemado(objeto){
        var tiempoHastaQuemarse = 10 //si está mas de 10 segundos despues de cocinarse se quema
        var nombreTick
        if(numeroEstacion == 1) nombreTick = "controlarQuemado1"
        if(numeroEstacion == 2) nombreTick = "controlarQuemado2"

        self.crearCartelPrecaucion()
        game.onTick(500, nombreTick, { //controla cada medio segundo
            if(tiempoHastaQuemarse == 0){ //no me importa la posicion, si llego a 0 se quemó
                self.liberar()
                objeto.modificado("quemado")
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
        plato.estaEnPlato(false) //lo saco de plato
    }

    method resetearPlatoArmado(plato){
        plato.elementosPlato().forEach({elemento => if (elemento.elemento() != "plato"){game.removeVisual(elemento)}}) //borro todos los ingredientes de plato armado que no sea "plato"
        plato.elementosPlato().clear() //libero la lista de elementos del objeto PlatoArmado
        game.removeVisual(plato)
    }

    //Debería aparecer un plato sucio y volver a estar donde estaba el platoArmado
    
    method tomarPlato(plato){
        const platoUsado = plato.elementosPlato().findOrDefault({elemento => elemento.elementoYEstado() == "plato"}, null) //obtengo el plato que usaba el platoArmado
        if(platoUsado != null){
            self.resetearPlatoArmado(plato)
            self.devolverPlatoSucio(platoUsado)
        }
    }
 
    method procesoPlato(pedido, plato){
        pedido.seEntrego(true)
        generadorDePedidos.listaPedidos().remove(pedido)
        puntaje.sumar(puntaje.asignarPuntos(pedido, plato))
        game.removeVisual(pedido)
        self.tomarPlato(plato)
    }

    override method tareaDeEstacion(platoArmado){
        if(platoArmado.elemento() == "plato armado"){
            const pedido = selectorPedidos.eleccionDePedido(platoArmado.elementosPlato()) //elije el pedido que coincida con los elementos de la receta y la que tenga mas prioridad
            personajePrincipal.agarrarOSoltar() //suelta el plato armado
            if (pedido == null) { //Si el plato no coincide con ningun pedido
                puntaje.restar(100)  
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
      platoEnArmado = new PlatoArmado(position = position) //Creo un nuevo PlatoArmado
    }

    override method tareaDeEstacion(objeto){
        if(objeto.elemento() == "plato" && objeto.modificado() == "limpio"){ //si el elemento que traigo es un plato y está limpio
            if(platoEnArmado == null){ //si no hay plato armado => no hay plato en la mesa
                self.crearPlatoArmado()
                game.addVisual(platoEnArmado)               
                platoEnArmado.elementosPlato().add(objeto) //agrego el plato
                objeto.estaEnPlato(true)  //agrego plato a PlatoArmado
                personajePrincipal.agarrarOSoltar() //el personaje suelta el plato
                hayPlatoParaArmar = true
                
            } 
        } else if (objeto.elemento()== "plato armado"){ // si vengo con un plato armado
            if(platoEnArmado == null){
                hayPlatoParaArmar = true
                platoEnArmado = objeto //actualizo el nuevo plato en armado
                personajePrincipal.agarrarOSoltar()
            }
        } else{ //si lo que traigo no es un plato
            if(hayPlatoParaArmar){ //me fijo si hay un plato en la mesada, si lo hay puedo agregar la comida
                platoEnArmado.elementosPlato().add(objeto)
                objeto.estaEnPlato(true) //agrego comida a PlatoArmado
                personajePrincipal.agarrarOSoltar()
            }
        }        

    }

    method agarrarPlatoArmado() {
        if(platoEnArmado.sePuedeAgarrar() && platoEnArmado != null){ //si tiene el plato y algun elemento
            hayPlatoParaArmar = false
            platoEnArmado = null //no hay plato en armado, está dando vueltas 
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
}

object cajonDePapas inherits Cajon (
    position = game.at(22,6),
    posicionAlimento = game.at(9,3),
    imagenCajon = "imagenesCajones/cajonDePapas.png"){
    override method reponerStock() {
        if (self.cantidadEnStock() == 0) { 
            stockMaximo.times( 
                {papaX => const nuevaPapa = new Papa(position = posicionAlimento, modificado = "")
                alimentos.add(nuevaPapa)
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
                {pechugaX => const nuevaPechuga = new PechugaDePollo(position = posicionAlimento, modificado = "")
                alimentos.add(nuevaPechuga)
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
                {huevoX => const nuevoHuevo = new Huevo(position = posicionAlimento, modificado = "")
                alimentos.add(nuevoHuevo)
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
                {bifeX => const nuevoOjoBife = new OjoDeBife(position = posicionAlimento, modificado = "")
                alimentos.add(nuevoOjoBife)
                game.addVisual(nuevoOjoBife)
                }
            )
        }
    }
}

