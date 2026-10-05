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
    method mesaArmado() = false //PRUEBA
    method mesadaEntrega() = false //PRUEBA

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
        if(objeto.tareas().contains(debeValidar) && !estaOcupado){
            prendido = true
            estaOcupado = true
            personajePrincipal.agarrarOSoltar()
            objeto.sePuedeAgarrar(false)
            game.schedule(tiempoTarea, { 
                objeto.modificado(valorOtorgado)
                if(valorOtorgado == "tirado") game.removeVisual(objeto)
                prendido = false
                estaOcupado = false
                objeto.sePuedeAgarrar(true)
            })}
        
        return
    }
}

const horno = new Estacion(
    position = game.at(6,11),
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

object mesadaEntrega {
    const property position = game.at(14,11) 
    var listaActual = null
    method image() = "mesada.png"
    method elemento() = "estacion"
    var property contador = 0 

    method mesaArmado() = false //PRUEBA
    method mesadaEntrega() = true //PRUEBA
    method sePuedeAgarrar() = false
    //PRIORIDAD: ENTREGA PRIMERO LOS QUE ESTAN EN ESPERA 2, DESPUES ESPERA 1, DESPUES LOS NUEVOS 

    method compararIngredientesLista(plato, lista){
        console.println("COMPARANDO LISTA Y PLATO")
       return ((plato.size() == lista.size())&& plato.all({elemento => lista.contains(elemento.elementoYEstado())}))
    }

    method devolverPlatoSucio(plato){
        console.println("DEVOLVIENDO PLATO SUCIO")
        plato.position(game.at(16,3))
        plato.modificado("sucio")
        plato.estaEnPlato(false)
    }

    method resetearPlatoArmado(plato){
        plato.elementosPlato().forEach({elemento => game.removeVisual(elemento)})
        plato.elementosPlato().clear()
        plato.resetearPosicion()
    }

    
    //Debería aparecer un plato sucio y volver a estar donde estaba el platoArmado
    method tomarPlato(plato, lista){ 
        console.println("REMOVIENDO ELEMENTOS")
        const platoUsado = plato.elementosPlato().findOrDefault({elemento => elemento.elementoYEstado() == "plato"}, null) //obtengo el plato que usaba el platoArmado
        const posicionPlatoAArmar = plato.position()


        if(platoUsado != null){
            console.println("EXISTE PLATO SUCIO")
            self.resetearPlatoArmado(plato)
            game.removeVisual(lista)
            self.devolverPlatoSucio(platoUsado)
            game.addVisual(platoUsado)
        }
    }

    method procesoPlato(listaSegunEspera, plato){
        listaActual = listaSegunEspera.first() 
            if(self.compararIngredientesLista(plato.elementosPlato(), listaActual.ingredientes())){ // si tienen lo mismo
                console.println("CUMPLE EL PLATO CON LA LISTA")
                //Acá se añaden los puntos 
                generadorDePedidos.listaPedidos().remove(listaActual)
                self.tomarPlato(plato, listaActual)
            }else{
                console.println("EL PLATO NO CUMPLE CON LA LISTA")
                //Restar puntos
                generadorDePedidos.listaPedidos().remove(listaActual)
                self.tomarPlato(plato, listaActual)
            }
    }



    method entregarPlato(platoArmado){ //verifico antes que es un plato armado
        const listaEspera2 = generadorDePedidos.listaPedidos().filter({pedidolista => pedidolista.estado() == "ESPERA2"})
        const listaEspera1 = generadorDePedidos.listaPedidos().filter({pedidolista => pedidolista.estado() == "ESPERA1"})
        const listaNuevos = generadorDePedidos.listaPedidos().filter({pedidolista => pedidolista.estado() == "NUEVO"})
        
        personajePrincipal.agarrarOSoltar() //el personaje lo suelta
        if (!listaEspera2.isEmpty()){ // si hay pedidos en espera2
            self.procesoPlato(listaEspera2, platoArmado)       
        }else if(!listaEspera1.isEmpty()){
            self.procesoPlato(listaEspera1, platoArmado)
        }else if(!listaNuevos.isEmpty()){
            self.procesoPlato(listaNuevos, platoArmado)
        }
    }
}

class PlatoArmado {
    var property position
    var property elementosPlato = []
    const property estaEnPlato = false
    var posicionInicial = null
    method tareas() = ["tirar"]

    method initialize(){ //la asigna al crearse con NEW
        posicionInicial = position
    }

    method resetearPosicion(){
        self.position(posicionInicial)
    }
    
    method sePuedeAgarrar(){
        return(elementosPlato.size() > 1)
    }


    method elemento(){
        if(self.sePuedeAgarrar()){
            return "plato armado"
        }else{
            return "plato no armado"
        }
    } 

    method nuevaposicion(nuevaPos) {
        position = nuevaPos
        elementosPlato.forEach({ elem => elem.position(nuevaPos) })
    }


}

const platoArmado1 = new PlatoArmado( //ASIGNANDO UN PLATO A CADA MESADA
    position = game.at(24.5,7)
)


object mesadaArmado { //Hay 3 mesas de armado, por eso un class
    const property position = game.at(24.5,7)
    method image() = "mesadaArmado.png"  
    method elemento() = "estacion"
    method mesaArmado() = true
    method mesadaEntrega() = false
    method sePuedeAgarrar() = false
    const property platoEnArmado = platoArmado1 //Cada mesa tiene un plato asignado? ver como hacemos cuando los entregamos


    method armarPlato(objeto){
        if(objeto.elemento() == "plato"){
            if(!platoEnArmado.elementosPlato().any({elem=> elem.elemento() == "plato"})){
                platoEnArmado.elementosPlato().add(objeto)
                objeto.estaEnPlato(true)  
                personajePrincipal.agarrarOSoltar()
                           
                
            } //Si hay alguno tendria qe decir que ya hay un plato!
        } else{
            if(platoEnArmado.elementosPlato().any({elem => elem.elemento() == "plato"})){
                platoEnArmado.elementosPlato().add(objeto)
                objeto.estaEnPlato(true)
                personajePrincipal.agarrarOSoltar()
            }
            //Si no hay plato tiene que decir que necesita un plato para poner la comida
        }        

    }

    method agarrarPlatoArmado() {
        if(platoEnArmado.sePuedeAgarrar()){
            return platoEnArmado
        }else{
            return null
        }
    }

}

object cajonDePapas {  //La idea es que el cajón cuente la cantidad de papas de alguna forma
                       // y en base a eso restockee. Tal vez haya que hacer una colección de papas.
    const property position = game.at(26,5)
    const stockMaximo = 5
    method image() = "cajonDePapas.png"
    method elemento() = "cajonDePapas"
    /*
    method reponerStock() {
        const cantidadDePapas = papasEnJuego.size()
        if (cantidadDePapas <= stockMaximo) {
            
        }
    }

    method cantidadDePapas() {
        return papasEnJuego.size()
    } 
    */

    
}

object cajonDePollo {
    const property position = game.at(26,6)
    const stockMaximo = 5
    method image() = "cajonDePollo.png"
    method elemento() = "cajonDePollo"

    /*
    method reponerStock() {
        
    }

    method cantidadDePollos() {
        return pollosEnJuego().size()
    }
    */

}





