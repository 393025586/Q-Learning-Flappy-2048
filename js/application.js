// Wait till the browser is ready to render the game (avoids glitches)
window.requestAnimationFrame(function () {
	window.input = KeyboardInputManager;
	window.actuator = HTMLActuator;
  window.score = LocalScoreManager;
  window.game = new GameManager(4, KeyboardInputManager, HTMLActuator, LocalScoreManager);
});
