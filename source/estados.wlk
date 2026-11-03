import source.ambiente.*
import tareas.*


//Unicamente para estados de COMIDAS y PLATOS

//COSAS A CAMBIAR
//Elemento y estado 
//Tareas


object cruda {
    method image(tipo) = tipo.imagenCruda()
    method tareas(tipo) = tipo.tareasCruda()
}

object cortada {
    method image(tipo) = tipo.imagenCortada()
    method tareas(tipo) = tipo.tareasCortada()
}

object cocinada {
    method image(tipo) = tipo.imagenCocinada()
    method tareas(tipo) = [tareaTirar]
   
}

object quemada {
    method image(tipo) = tipo.imagenQuemada()
    method tareas(tipo) = [tareaTirar]
}

// Estados para el plato
object limpio {
    method image(plato) = plato.imagenLimpio()
    method tareas(plato) = []

    method colocarseEnMesadaArmado(plato, mesada) { mesada.recibirPlatoLimpio(plato) }
    
}

object sucio {
    method image(plato) = plato.imagenSucio()
    method tareas(plato) = [tareaLimpiar]

    method colocarseEnMesadaArmado(plato, mesada) {}
    
}

object platoArmado{
    method image(plato) = "imagenesEstaciones/vacio.png"
    method tareas(plato) = [tareaTirar]

    method colocarseEnMesadaArmado(plato, mesada){ mesada.recibirPlatoArmado(plato)}

}

