
object musicaDeFondo {
    var musicaActual = game.sound("musica/musicaJuegoPrincipal.wav")
    var musicaPausada = false

    method iniciarMusica() {
        musicaActual.shouldLoop(true)
        game.schedule(500, { musicaActual.play()} )
    }

    method pararMusica() {
        musicaActual.stop()
    }

    method pausarOReanudarMusica() {
        if (musicaPausada) {
            musicaPausada = false
            musicaActual.resume()
        } else {
            musicaPausada = true
            musicaActual.pause()
        }
    }

    method cambiarMusica(nuevaMusica) {
        musicaActual = nuevaMusica
    }

    method mutearMusica() {
        keyboard.p().onPressDo({self.pausarOReanudarMusica()})
    }
}