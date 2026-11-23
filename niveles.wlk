import pedidos.*
import ambiente.*
import controladorPantallasYNiveles.*
import puntaje.*
import direcciones.*
import comida.*


class Nivel{
    var recetasDisponibles 
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
        game.schedule(3500, { //cuando se saca la pantalla de presentacion y se puede jugar
            if (controladorDePartida.nivelActual() == self) { musicaDeFondo.iniciar() }
        })

        game.schedule(5200, {
            if (controladorDePartida.nivelActual() == self) { //Para evitar la superposición de generadorDePedidos.empezar(self) en caso de terminar el nivel antes de 5200 ms (creo)
                controladorDePartida.puntosSegunNivel()
                generadorDePedidos.empezar(self) 
            }
        })
    }

    method cajones() = [cajonDeHuevo, cajonDeBife]

    method acomodarEscenario() {
        horno1.position(game.at(6, 11))
        horno2.position(game.at(8, 11))
        basura.position(game.at(20, 7))
        bacha.position(game.at(4, 6))
        bacha.imagenAbierta("imagenesEstaciones/bachaAbierta.gif")
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
        mesaFernet1.position(game.at(19,11))
        mesaFernet2.position(game.at(20,11))
        mesaFernet3.position(game.at(21,11))
        mesadaEntrega1.position(game.at(14,11))
        mesadaEntrega2.position(game.at(15,11))
        mesadaEntrega3.position(game.at(16,11))
        [vaso1,vaso2,vaso3].forEach({v=>v.posicionInicial(game.at(4,8))})
        [plato1,plato2,plato3].forEach({p => p.posicionPlatoSucio(game.at(4,5)) p.posicionInicial(game.at(16,3))})
        [plato1, plato2, plato3, vaso1, vaso2, vaso3].forEach({ v => v.reiniciar() })         
       
    }
}

object nivel3 inherits Nivel(
    recetasDisponibles = [ojoDeBifeConHuevo, polloConPapas, fernetConCoca],
    puntosParaGanar = 900,  //900
    siguienteNivel = nivel4,
    pantalla = pantallaNivel3,
    fondo = "imagenesFondos/fondoCocinaNivel3.png",
    mapa = mapaNivel3){
    override method nuevoPedido() {
        generadorDePedidos.pedir(recetasDisponibles.anyOne()) 
    }
    override method cajones() = [cajonDeHuevo, cajonDeBife, cajonDePapas, cajonDePollo]
    }

object nivel4 inherits Nivel (
    recetasDisponibles = [ojoDeBifeConHuevo, polloConPapas, fernetConCoca],
    puntosParaGanar =900, //900
    pantalla = pantallaNivel4, 
    fondo = "imagenesFondos/fondoCocinaNivel4.png",
    mapa = mapaNivel4){   
    override method cajones() = [cajonDeHuevo, cajonDeBife, cajonDePapas, cajonDePollo]
    
    override method acomodarEscenario() {
        horno1.position(game.at(19, 11))
        horno2.position(game.at(21, 11))
        basura.position(game.at(9, 7))
        bacha.position(game.at(25, 6))
        bacha.imagenAbierta("imagenesEstaciones/bachaAbiertaInvertida.gif")
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
        mesaFernet1.position(game.at(8,11))
        mesaFernet2.position(game.at(9,11))
        mesaFernet3.position(game.at(10,11))
        mesadaEntrega1.position(game.at(12,11))
        mesadaEntrega2.position(game.at(13,11))
        mesadaEntrega3.position(game.at(14,11))
        [vaso1,vaso2,vaso3].forEach({v=>v.posicionInicial(game.at(25,8))})
        [plato1,plato2,plato3].forEach({p => p.posicionPlatoSucio(game.at(25,7)) p.posicionInicial(game.at(22,3))})
        [plato1, plato2, plato3, vaso1, vaso2, vaso3].forEach({ v => v.reiniciar() }) 
    }

    override method nuevoPedido(){
        generadorDePedidos.pedir(recetasDisponibles.anyOne())
    }     


}

object nivel2 inherits Nivel(
    recetasDisponibles = [ojoDeBifeConHuevo, polloConPapas, fernetConCoca],
    puntosParaGanar = 850,  //850
    siguienteNivel = nivel3,
    pantalla = pantallaNivel2,
    fondo = "imagenesFondos/fondoCocina.png"){
    override method nuevoPedido() {
        generadorDePedidos.pedir(recetasDisponibles.anyOne()) //Puede salir ojo de bife, pollo con papas o fernet
    }
    override method cajones() = [cajonDeHuevo, cajonDeBife, cajonDePapas, cajonDePollo]
    
}

object nivel1 inherits Nivel(
    recetasDisponibles = [ojoDeBifeConHuevo, fernetConCoca],
    puntosParaGanar = 750, //Cambiar a 750
    siguienteNivel = nivel2,
    pantalla = pantallaNivel1,
    fondo = "imagenesFondos/fondoCocina.png"){
    override method nuevoPedido() {
        generadorDePedidos.pedir(recetasDisponibles.anyOne()) //pide ojo de bife y fernet
    }
}

object fondoJuego {
    var property imagen = "imagenesFondos/fondoCocina.png"
    method position() = game.at(0, 0)
    method image() = imagen
    method permiteApoyar() = true
}