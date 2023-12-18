import wollok.game.*

object gameSoundManager {
	
    method playSoundtrackForLevel1() {
    	const stage1 = game.sound("soundtrackLvl1.mp3")
    	
    	stage1.shouldLoop(true)
    	game.schedule(500, { stage1.play()} )
    	
    }

    method stopSoundtrackForLevel1() { //esto tendria que ir en un metodo que sea finalizarnivel1 (quizas)

      game.sound("soundtrackLvl1.mp3").stop()
    }
    
}