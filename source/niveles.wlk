import pedidos.*
import ambiente.*
import controladorPantallasYNiveles.*
import puntaje.*
import direcciones.*
import comida.*


class Nivel{
    var property puntosParaGanar 
    var property siguienteNivel = null
    const pantalla
    const fondo
    const property mapa = mapaNivelBase

    method nuevoPedido() {
        //segun el nivel se crean distinto pedidos
    }

    method iniciar() {
        escenario.nivelActual(self)
        fondoJuego.imagen(fondo)
        self.acomodarEscenario()
        self.cajones().forEach({cajon => if(!game.allVisuals().contains(cajon))
            {game.addVisual(cajon)}
            cajon.reponerStock()
        })

        pantalla.mostrarInfoNivel()

        game.schedule(5200, {
            controladorDePartida.puntosSegunNivel()
            generadorDePedidos.empezar(self) 
        })
    }

    method cajones() = [cajonDeHuevo, cajonDeBife]

    method acomodarEscenario() {
        horno1.position(game.at(6, 11))
        horno2.position(game.at(8, 11))
        basura.position(game.at(20, 7))
        bacha.position(game.at(4, 6))
        tablaDeCortar.position(game.at(4, 9))
        mesadaArmado1.position(game.at(25, 7))
        mesadaArmado2.position(game.at(25, 9))
        mesadaArmado3.position(game.at(25, 11))
        cajonDePapas.position(game.at(22, 6))
        cajonDePapas.posicionAlimento(game.at(9, 3))
        cajonDePollo.position(game.at(20, 6))
        cajonDePollo.posicionAlimento(game.at(6, 3))
        cajonDeHuevo.position(game.at(24, 6))
        cajonDeHuevo.posicionAlimento(game.at(11, 3))
        cajonDeBife.position(game.at(20, 3))
        cajonDeBife.posicionAlimento(game.at(13, 3))
       
    }
}

object nivel3 inherits Nivel(
    puntosParaGanar = 200, //Cambiar
    pantalla = pantallaNivel3, //CAMBIAR
    fondo = "imagenesFondos/fondoCocina3.png",
    mapa = mapaNivel3){   
    override method cajones() = [cajonDeHuevo, cajonDeBife, cajonDePapas, cajonDePollo]
    
    override method acomodarEscenario() {
        horno1.position(game.at(18, 11))
        horno2.position(game.at(20, 11))
        basura.position(game.at(9, 7))
        bacha.position(game.at(25, 6))
        tablaDeCortar.position(game.at(25, 10))
        mesadaArmado1.position(game.at(4, 7))
        mesadaArmado2.position(game.at(4, 9))
        mesadaArmado3.position(game.at(4, 11))
        cajonDePapas.position(game.at(4, 6))
        cajonDePapas.posicionAlimento(game.at(14, 3))
        cajonDePollo.position(game.at(6, 3))
        cajonDePollo.posicionAlimento(game.at(16, 3))
        cajonDeBife.position(game.at(6, 6))
        cajonDeBife.posicionAlimento(game.at(18, 3))
        cajonDeHuevo.position(game.at(4, 3))
        cajonDeHuevo.posicionAlimento(game.at(20, 3))
        mesaFernet1.position(game.at(7,11))
        mesaFernet2.position(game.at(8,11))
        mesaFernet3.position(game.at(9,11))
        mesadaEntrega1.position(game.at(12,11))
        mesadaEntrega2.position(game.at(13,11))
        mesadaEntrega3.position(game.at(14,11))
        [vaso1,vaso2,vaso3].forEach({v=>v.posicionInicial(game.at(25,8))})
        [plato1,plato2,plato3].forEach({p => p.posicionPlatoSucio(game.at(25,7)) p.posicionInicial(game.at(22,3))})
        [plato1, plato2, plato3, vaso1, vaso2, vaso3].forEach({ v => v.reiniciar() }) //para aplicar los cambios de la posicion Inicial
    }

    override method nuevoPedido(){
         generadorDePedidos.pedir(0.randomUpTo(2).round())//Puede salir ojo de bife, pollo con papas o fernet
    }     


}

object nivel2 inherits Nivel(
    puntosParaGanar = 100,
    siguienteNivel = nivel3,
    pantalla = pantallaNivel2,
    fondo = "imagenesFondos/fondoCocina.png"){
    override method nuevoPedido() {
        generadorDePedidos.pedir(0.randomUpTo(2).round()) //Puede salir ojo de bife, pollo con papas o fernet
    }
    override method cajones() = [cajonDeHuevo, cajonDeBife, cajonDePapas, cajonDePollo]
    
}

object nivel1 inherits Nivel(
    puntosParaGanar = 300,
    siguienteNivel = nivel2,
    pantalla = pantallaNivel1,
    fondo = "imagenesFondos/fondoCocina.png"){
    override method nuevoPedido() {
        generadorDePedidos.pedir(0.randomUpTo(1).round()) //pide ojo de bife y fernet
        //generadorDePedidos.pedir(1)  //Solo ojo de bife con huevo
    }
}

object fondoJuego {
    var property imagen = "imagenesFondos/fondoCocina.png"
    method position() = game.at(0, 0)
    method image() = imagen
}