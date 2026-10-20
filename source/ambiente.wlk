import wollok.game.*
import pedidos.*
import personajeprincipal.*
import comida.*

class Estacion{
    const property position
    var prendido 
    var estaOcupado 
    const tiempoTarea
    const imagen1
    const imagen2
    const valorOtorgado
    const debeValidar
    const property esMesadaArmado = false //ver si modificamos esto

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
            if(objeto.elemento() == "plato armado"){ //solo se va a usar en tirar
                objeto.elementosPlato().forEach({elemento => if (elemento.elemento() != "plato"){
                    game.removeVisual(elemento)
                    objeto.elementosPlato().remove(elemento) //lo saco de la lista del plato
                }}) //borro todos los ingredientes de plato armado que no sea "plato"
                prendido = false
                estaOcupado = false
                
            }else{
                objeto.sePuedeAgarrar(false)
                game.schedule(tiempoTarea, { 
                    objeto.modificado(valorOtorgado)
                    if(valorOtorgado == "tirado") game.removeVisual(objeto)
                    prendido = false
                    estaOcupado = false
                    objeto.sePuedeAgarrar(true)
            })}
        }
        
        return
    }
}

const horno1 = new Estacion(
    position = game.at(6,11),
    prendido = false,
    estaOcupado = false,
    tiempoTarea = 7000,
    imagen1 = "hornoprendido.png",
    imagen2 = "hornoapagado.png",
    valorOtorgado = "cocinado",
    debeValidar = "cocinar"
)


const horno2 = new Estacion(
    position = game.at(8,11),
    prendido = false,
    estaOcupado = false,
    tiempoTarea = 7000,
    imagen1 = "hornoprendido.png",
    imagen2 = "hornoapagado.png",
    valorOtorgado = "cocinado",
    debeValidar = "cocinar"
)



const basura = new Estacion(
    position = game.at(20,7),
    prendido = false,
    estaOcupado = false,
    tiempoTarea = 500,
    imagen1 = "basuraAbierta.png",
    imagen2 = "basura.png",
    valorOtorgado = "tirado",
    debeValidar = "tirar"
)

const bacha = new Estacion(
    position = game.at(4,6),
    prendido = false,
    estaOcupado = false,
    tiempoTarea = 3000,
    imagen1 = "vacio.png", //ESPUMA O AGUA
    imagen2 = "vacio.png",
    valorOtorgado = "limpio",
    debeValidar = "limpiar"
)

const tablaDeCortar = new Estacion(
    position = game.at(4,9),
    prendido = false,
    estaOcupado = false,
    tiempoTarea = 4500,
    imagen1 = "tablaDeCortar.png", 
    imagen2 = "tablaDeCortar.png", // hacer cambio (para notar que esta en uso)
    valorOtorgado = "cortada",
    debeValidar = "cortar"
)

class Mesada{
    const property position
    const property image

    method elemento() = "estacion"
    method sePuedeAgarrar() = false
    method tareaDeEstacion(objeto)
}
class MesadaEntrega inherits Mesada{
    var listaActual = null
    var property contador = 0 
    const property esMesadaArmado = false

    //PRIORIDAD: ENTREGA PRIMERO LOS QUE ESTAN EN ESPERA 2, DESPUES ESPERA 1, DESPUES LOS NUEVOS 

    method compararIngredientesLista(plato, lista){
       return ((plato.size() == lista.size())&& plato.all({elemento => lista.contains(elemento.elementoYEstado())}))
    }

    method devolverPlatoSucio(plato){
        plato.position(game.at(16,3))
        plato.modificado("sucio")
        plato.estaEnPlato(false) //lo saco de plato
    }

    method resetearPlatoArmado(plato){
        plato.elementosPlato().forEach({elemento => if (elemento.elemento() != "plato"){game.removeVisual(elemento)}}) //borro todos los ingredientes de plato armado que no sea "plato"
        plato.elementosPlato().clear() //libero la lista de elementos del objeto PlatoArmado
        game.removeVisual(plato)
    }

    
    //Debería aparecer un plato sucio y volver a estar donde estaba el platoArmado
    method tomarPlato(plato, lista){ 
        const platoUsado = plato.elementosPlato().findOrDefault({elemento => elemento.elementoYEstado() == "plato"}, null) //obtengo el plato que usaba el platoArmado
        const posicionPlatoAArmar = plato.position()

        if(platoUsado != null){
            self.resetearPlatoArmado(plato)
            game.removeVisual(lista)
            self.devolverPlatoSucio(platoUsado)
        }
    }

    method procesoPlato(listaSegunEspera, plato){
        listaActual = listaSegunEspera.first() 
        generadorDePedidos.listaPedidos().remove(listaActual)
        self.tomarPlato(plato, listaActual) 
        //Sumar puntos
    }

    override method tareaDeEstacion(platoArmado){
        if(platoArmado.elemento() == "plato armado"){ //verifico antes que es un plato armado
            const listaEspera2 = generadorDePedidos.listaPedidos().filter({ pedido =>
                pedido.estado() == "ESPERA2" &&   //Comparo si tienen los mismos ingredientes ANTES de
                self.compararIngredientesLista(   //procesoPlato.
                platoArmado.elementosPlato(),
                pedido.ingredientes()
                )}
            )
            const listaEspera1 = generadorDePedidos.listaPedidos().filter({ pedido =>
                pedido.estado() == "ESPERA1" &&
                self.compararIngredientesLista(
                platoArmado.elementosPlato(),
                pedido.ingredientes()
                )}
            )
            const listaNuevos = generadorDePedidos.listaPedidos().filter({ pedido =>
                pedido.estado() == "NUEVO" &&
                self.compararIngredientesLista(
                platoArmado.elementosPlato(),
                pedido.ingredientes()
                )}
            )

            personajePrincipal.agarrarOSoltar() //el personaje lo suelta
            if (!listaEspera2.isEmpty()){ // si hay pedidos en espera2 y que coincidan
                self.procesoPlato(listaEspera2, platoArmado)       
            }else if(!listaEspera1.isEmpty()){
                self.procesoPlato(listaEspera1, platoArmado)
            }else if(!listaNuevos.isEmpty()){
                self.procesoPlato(listaNuevos, platoArmado)
            } // else { restar puntos } ? Habría que restar en caso de que un pedido pasa a perdido, supongo
        }
    }
}


const mesadaEntrega1 = new MesadaEntrega(
    position = game.at(14,11),
    image = "mesada.png"
)

const mesadaEntrega2 = new MesadaEntrega(
    position = game.at(15,11),
    image = "vacio.png"
)

const mesadaEntrega3 = new MesadaEntrega(
    position = game.at(16,11),
    image = "vacio.png"
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
            if(platoEnArmado == null){ //si no hay plato armado
                self.crearPlatoArmado()
                game.addVisual(platoEnArmado)
            }
            if(!platoEnArmado.elementosPlato().any({elem=> elem.elemento() == "plato"})){ //si en la mesada no hay ningun plato               
                platoEnArmado.elementosPlato().add(objeto) //agrego el plato
                objeto.estaEnPlato(true)  //agrego plato a PlatoArmado
                personajePrincipal.agarrarOSoltar() //el personaje suelta el plato
                hayPlatoParaArmar = true
                
            } //Si hay alguno tendria qe decir que ya hay un plato!
        } else if (objeto.elemento()== "plato armado"){ // si vengo con un plato armado
            hayPlatoParaArmar = true
            personajePrincipal.agarrarOSoltar()
            platoEnArmado = objeto //actualizo el nuevo plato en armado
            

        } else{ //si lo que traigo no es un plato
            if(hayPlatoParaArmar){ //me fijo si hay un plato en la mesada, si lo hay puedo agregar la comida
                platoEnArmado.elementosPlato().add(objeto)
                objeto.estaEnPlato(true) //agrego comida a PlatoArmado
                personajePrincipal.agarrarOSoltar()
            }
            //Si no hay plato tiene que decir que necesita un plato para poner la comida
        }        

    }

    method agarrarPlatoArmado() {
        if(platoEnArmado.sePuedeAgarrar()){ //si tiene el plato y algun elemento
            hayPlatoParaArmar = false
            platoEnArmado = null //no hay plato en armado, está dando vueltas 
        }
    }
}


const mesadaArmado1 = new MesadaArmado(
    position = game.at(24.5,7),
    image = "mesadaArmado.png"
)


const mesadaArmado2 = new MesadaArmado(
    position = game.at(24.5,9),
    image = "vacio.png"
)


const mesadaArmado3 = new MesadaArmado(
    position = game.at(24.5,11),
    image = "vacio.png"
)


class Cajon {
    const property position 
    const posicionAlimento
    const stockMaximo
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
}

object cajonDePapas inherits Cajon (
    position = game.at(23,5),
    posicionAlimento = game.at(9,3),
    stockMaximo = 5,
    imagenCajon = "cajonDePapas.png"){
    method reponerStock() {
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
    position = game.at(20,5),
    posicionAlimento = game.at(6,3),
    stockMaximo = 5,
    imagenCajon = "cajonDePollo.png"){
    method reponerStock() {
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



