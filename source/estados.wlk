import source.ambiente.*


//Unicamente para estados de COMIDAS y PLATOS

//COSAS A CAMBIAR
//Elemento y estado 
//Tareas


object cruda {
    method elementoYEstado(comida) = comida.nombreBase()
    method image(comida) = comida.imagenCruda()
    method tareas(comida) = comida.tareasCruda()
    method cocinar(comida) { comida.estado(cocinada) }
    method cortar(comida) { comida.estado(cortada) }
    method quemar(comida) { comida.estado(quemada) }
    method tirar(comida) { comida.estado(tirada) }
}

object cortada {
    method elementoYEstado(comida) = comida.nombreCortada()
    method image(comida) = comida.imagenCortada()
    method tareas(comida) = comida.tareasCortada()
    method cocinar(comida) { comida.estado(cocinada) }
    method cortar(comida) {}
    method quemar(comida) { comida.estado(quemada) }
    method tirar(comida) { comida.estado(tirada) }
}

object cocinada {
    method elementoYEstado(comida) = comida.nombreCocinada()
    method image(comida) = comida.imagenCocinada()
    method tareas(comida) = ["tirar"]
    method cocinar(comida) {}
    method cortar(comida) {}
    method quemar(comida) { comida.estado(quemada) }
    method tirar(comida) { comida.estado(tirada) }
}

object quemada {
    method elementoYEstado(comida) = comida.nombreQuemada()
    method image(comida) = comida.imagenQuemada()
    method tareas(comida) = ["tirar"]
    method cocinar(comida) {}
    method cortar(comida) {}
    method quemar(comida) {}
    method tirar(comida) { comida.estado(tirada) }
}

object tirada {
    method elementoYEstado(comida) = "vacio"
    method image(comida) = "imagenesEstaciones/vacio.png"
    method tareas(comida) = []
    method cocinar(comida) {}
    method cortar(comida) {}
    method quemar(comida) {}
    method tirar(comida) {}
}

// Estados para el plato
object limpio {
    method elementoYEstado(plato) = "platoLimpio"
    method image(plato) = plato.imagenLimpio()
    method tareas(plato) = []
    method colocarseEnMesadaArmado(plato) { MesadaArmado.recibirPlatoLimpio(plato) }
    
}

object sucio {
    method elementoYEstado(plato) = "platoSucio"
    method image(plato) = plato.imagenSucio()
    method tareas(plato) = ["limpiar"]
    method colocarseEnMesadaArmado(plato) {}
    
}

object platoArmado{
    method elementoYEstado(plato) = "platoArmado"
    method image(plato) = "vacio.png"
    method tareas(plato) = ["tirar"]
    method colocarseEnMesadaArmado(){ MesadaArmado.recibirPlatoArmado(self)}

}

