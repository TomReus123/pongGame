package actors 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Tom Reus
	 */
	public class PowerUp extends MovieClip
	{
		//art aanmaken van mijn powerup
		public function PowerUp() 
		{
			addChild(new PowerUpArt());
		}
		
	}

}