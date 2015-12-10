package screens 
{
	import actors.AI;
	import actors.Ball;
	import actors.Paddle;
	import actors.Player;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import utils.MovementCalculator;
	import screens.Scoreboard;
	import actors.PowerUp;
	
	/**
	 * ...
	 * @author Tom Reus
	 */
	public class GameScreen extends Screen
	{
		private var balls:Array = [];
		private var paddles:Array = [];
		//array voor mijn powerups
		private var powerups:Array = [];
		private var scoreboard:Scoreboard;
		static public const GAME_OVER:String = "game over";
		static public const BALL_BOUNCE:String = "ballBounce";
		//variabele hieronder is de timer voor de spawn van de powerup 
		private var timer:Timer = new Timer(3700 + Math.random() * 10000);
		public function GameScreen()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);		
		}				
		private function init(e:Event):void 
		{
			//start de timer van de powerup spawn
			timer.start();
			//eventlistener voor mijn timer
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			removeEventListener(Event.ADDED_TO_STAGE, init);
				for (var i:int = 0; i < 1; i++) //1 bal laten spawnen in plaats van 2
			{
				balls.push(new Ball());
				addChild(balls[i]);
				balls[i].reset();
				
				balls[i].addEventListener(Ball.OUTSIDE_RIGHT, onRightOut);
				balls[i].addEventListener(Ball.OUTSIDE_LEFT, onLeftOut);
				
			}	
			paddles.push(new AI());
			paddles.push(new Player());
			paddles[1].maxSpeed = 10;
			paddles[0].balls = balls;
			for (i = 0; i < 2; i++) 
			{
				
				addChild(paddles[i]);
				paddles[i].y = stage.stageHeight / 2;
			}	
			paddles[0].x = stage.stageWidth - 100;
			
			paddles[1].x = 100;
			
			scoreboard = new Scoreboard();
			addChild(scoreboard);
			
			this.addEventListener(Event.ENTER_FRAME, loop);
		}		
		
		private function loop(e:Event):void 
		{
			checkCollision();
		}	
		private function checkCollision():void 
		{
			for (var i:int = 0; i < balls.length; i++) 
			{
				//for loop hieronder voor mijn powerup
				for (var k:int = 0; k < powerups.length; k++) {
					if (balls[i].hitTestObject(powerups[k])) {
						balls[i].startPowerUp();
						this.removeChild(powerups[k]);
						powerups.splice(k,1);
					}
				}
				
				for (var j:int = 0; j < paddles.length; j++) 
				{
					if (paddles[j].hitTestObject(balls[i]))
					{
						balls[i].xMove *= -1;
						balls[i].x += balls[i].xMove / 2;
						
						dispatchEvent(new Event(BALL_BOUNCE));
					}
				}
			}
			
		}
		private function onLeftOut(e:Event):void 
		{
			var b:Ball = e.target as Ball;
			b.reset();
			
			scoreboard.player2 += 1;
			
			checkScore();
		}		
		private function onRightOut(e:Event):void 
		{
			var b:Ball = e.target as Ball;
			b.reset();
			scoreboard.player1 += 1;
			
			
			checkScore();
		}		
		
		private function checkScore():void 
		{
			if (scoreboard.player1 >= 10 || scoreboard.player2 >= 10)
			{
				destroy();
				dispatchEvent(new Event(GAME_OVER));
				
			}
			
		}
			
		private function destroy():void
		{
			for (var i:int = 0; i < balls.length; i++) 
			{
				balls[i].destroy();
				removeChild(balls[i]);
			}
			balls.splice(0, balls.length);
		}
		//functie om powerup te spawnen
		private function onTimer(t:TimerEvent):void {
			var powerUp:PowerUp = new PowerUp();
			powerUp.x = 100 + Math.random() * 700;
			powerUp.y = 100 + Math.random() * 400;
			this.addChild(powerUp);
			powerups.push(powerUp);
		}
	}
}