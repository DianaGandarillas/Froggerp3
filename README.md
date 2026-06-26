# Froggerp3
nombres: Yery Gallardo y Diana Gandarillas
##  Cómo jugar
Guía a la rana desde la acera inferior hasta las cinco casillas objetivo en la parte superior de la pantalla, esquivando autos y cruzando el río sobre troncos y tortugas.

## Controles
El movimiento de la rana se realiza con las teclas A,W,S,D del teclado. La tecla W salta hacia adelante, La tecla s retrocede, y La teclas A y D desplazan la rana lateralmente. Para pausar o reanudar el juego se utiliza la tecla Esc.

## Récord
El juego guarda el **puntaje más alto** alcanzado durante la sesión. El récord se muestra tanto en la pantalla de **Game Over** como en la pantalla de **Pausa**. Se resetea al cerrar el juego.

## Sistema de Puntaje
El puntaje se acumula a lo largo de toda la partida sin resetearse entre niveles. Cada vez que la rana ocupa exitosamente una casilla objetivo se suman 50 puntos. Al completar todas las metas de un nivel se otorga un bono adicional de 1000 puntos. El puntaje actual se muestra en pantalla en todo momento.

## Pantalla de Pausa
Accesible con la tecla **Esc** durante el juego. Al pausar:
- Todos los obstáculos se **congelan**
- El jugador **no puede moverse**
- Se muestra el **récord actual**
- Se puede elegir entre **Volver** al juego o **Reiniciar** desde cero
- 
## Pantalla de Game Over
Aparece al agotar todas las vidas. Muestra:
- El **récord** más alto alcanzado en la sesión
- Un botón para **Reiniciar** el juego desde el nivel 1

## Dificultad Progresiva
Cada vez que el jugador completa un nivel, la velocidad de todos los obstáculos aumenta automáticamente un 15% adicional respecto al nivel anterior. Esto significa que en el nivel 2 los obstáculos se mueven un 17% más rápido que en el nivel 1, en el nivel 3 un 30% más rápido, y así sucesivamente. Este incremento se aplica a todos los carriles de autos y plataformas sin excepción, haciendo que cada nivel suponga un desafío mayor que el anterior.

### Aspectos técnicos destacados

- **Movimiento en cuadrícula:** el jugador se desplaza en saltos discretos de 50px, replicando la mecánica original del Frogger.
- **Detección de colisiones dual:** se usan señales (`area_entered`) para colisiones instantáneas con autos y metas, y polling en `_process` para detectar plataformas y agua de forma continua.
- **Singleton (Global.gd):** nodo Autoload que persiste entre escenas, almacenando vidas, puntaje, nivel y récord.
- **Object Pool:** los autos no se destruyen al salir de pantalla, se teletransportan al lado opuesto reutilizando el mismo nodo.
- **Dificultad progresiva:** multiplicador de velocidad calculado automáticamente en base al nivel actual al recargar la escena.
- **Sistema de pausa nativo:** usa `get_tree().paused = true` para congelar todos los nodos excepto la interfaz de pausa.
