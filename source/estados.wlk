import source.ambiente.*
import tareas.*


//Unicamente para estados de COMIDAS y PLATOS

//COSAS A CAMBIAR
//Elemento y estado 
//Tareas


object cruda {
    method image(comida) = comida.imagenCruda()

    method tareas(comida) = comida.tareasCruda()

}

object cortada {
    method image(comida) = comida.imagenCortada()

    method tareas(comida) = comida.tareasCortada()

}

object cocinada {
    method image(comida) = comida.imagenCocinada()
    method tareas(comida) = [tareaTirar]
   
}

object quemada {
    method image(comida) = comida.imagenQuemada()
    method tareas(comida) = [tareaTirar]
    
}


// Estados para el plato
object limpio {
    method image(plato) = plato.imagenLimpio()
    method tareas(plato) = []

    method colocarseEnMesadaArmado(plato) { MesadaArmado.recibirPlatoLimpio(plato) }
    
}

object sucio {
    method image(plato) = plato.imagenSucio()
    method tareas(plato) = [tareaLimpiar]

    method colocarseEnMesadaArmado(plato) {}
    
}

object platoArmado{
    method image(plato) = "vacio.png"
    method tareas(plato) = [tareaTirar]

    method colocarseEnMesadaArmado(){ MesadaArmado.recibirPlatoArmado(self)}

}

