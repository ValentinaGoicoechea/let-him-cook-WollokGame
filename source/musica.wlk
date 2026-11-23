
object musicaDeFondo {
    const musicaNiveles = game.sound("musica/musicaJuegoPrincipal.wav")

    method iniciarMusica() {
        musicaNiveles.shouldLoop(true)
        musicaNiveles.play()
        game.schedule(500, { musicaNiveles.play()} )
    }
}