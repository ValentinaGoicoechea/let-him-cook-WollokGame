
object musicaDeFondo {
    var musicaActual = game.sound("musica/musicaJuegoPrincipal.wav")
    var musicaIniciada = false
    var musicaPausada = false

    method iniciarMusica() {
        musicaActual.shouldLoop(true)
        musicaActual.play()
        musicaIniciada = true
        musicaPausada = false
    }

    method pararMusica() {
        if (musicaIniciada) {
            musicaActual.stop()
            musicaIniciada = false
            musicaPausada = false
        }
    }

    method cambiarMusica(nuevaMusica) {
        self.pararMusica()
        musicaActual = nuevaMusica
    }

    method pausarOReanudarMusica() {
        if (musicaPausada) {
            musicaActual.resume()
            musicaPausada = false
        } else {
            musicaActual.pause()
            musicaPausada = true
        }
    }

    method mutearMusica() {
        keyboard.p().onPressDo({
            self.pausarOReanudarMusica()
        })
    }
}