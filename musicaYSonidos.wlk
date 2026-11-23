object musicaDeFondo {
    var musicaActual = null
    var musicaMuteada = false
    var musicaIniciada = false //Creo que no va a hacer falta 

    method iniciarMusica(musica) {
        self.detenerMusica() //por si quedo una sonando (ej: al pasar de nivel)
        musicaIniciada = true
        musicaActual = musica
        musicaActual.shouldLoop(true) //bucle
        musicaActual.volume(0.4)
        musicaActual.play()
    }

    method detenerMusica() {
        if (musicaActual != null) {
            try { musicaActual.stop() } catch e {}
            musicaActual = null
        }
    }

    method cambiarMusica(nuevaMusica) {
        musicaActual = nuevaMusica
    }

    method pausarMusica() {
        if (musicaActual != null) {
            musicaActual.pause()
        }   
    }

    method reanudarMusica() {
        if (musicaActual != null) {
            musicaActual.resume()
        }
    }

    method mutearMusica() {
        if (musicaActual != null) {
            if (!musicaMuteada) {
                musicaActual.volume(0)
                musicaMuteada = true
            } else {
                musicaActual.volume(0.4)
                musicaMuteada = false
            }
        }
    }

    method configurarMuteo() {
        keyboard.p().onPressDo({self.mutearMusica()})
    }

    method iniciarOReanudarMusica(musica) {
        if (musicaActual == null) {
            self.iniciarMusica(musica)
        } else {
            self.reanudarMusica()
        }
    }
}

object controladorSonidos {
    var sonidosActivados = true
    var sonidosEnReproduccion = #{}

    method desactivarSonidos() {
        sonidosActivados = !sonidosActivados
        sonidosEnReproduccion.forEach({ sonido =>
            if (sonidosActivados) {
                sonido.volume(0.4)
            } else {
                sonido.volume(0)
            }
        })
    }

    method configurarMuteo() {
        keyboard.o().onPressDo({self.desactivarSonidos()})
    }

    method reproducirSonido(sonido, volumen) {
        sonidosEnReproduccion.add(sonido)
        if (sonidosActivados) {
            sonido.volume(volumen)
        } else {
            sonido.volume(0)
        }
        sonido.play() 
    }
}