object musicaDeFondo {
    var musicaActual = null
    var musicaMuteada = false
    var musicaIniciada = false

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