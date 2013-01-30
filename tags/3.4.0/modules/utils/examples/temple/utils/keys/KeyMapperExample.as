/**
 * @exampleText
 * 
 * <a name="KeyMapper"></a>
 * <h1>KeyMapper</h1>
 * 
 * <p>This is an example of how to use the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/doc/temple/utils/keys/KeyMapper.html">KeyMapper</a>.</p>
 *  
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/examples/temple/utils/keys/KeyMapperExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/utils/examples/temple/utils/keys/KeyMapperExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.core.display.CoreSprite;
	import temple.utils.keys.KeyCode;
	import temple.utils.keys.KeyMapper;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class KeyMapperExample extends DocumentClassExample 
	{
		private var _sprite:CoreSprite;
		
		public function KeyMapperExample()
		{
			super("Temple - KeyMapperExample");
			
			// Create a new Sprite
			_sprite = new CoreSprite();
			_sprite.graphics.beginFill(0x000000);
			_sprite.graphics.drawRect(0, 0, 20, 20);
			_sprite.graphics.endFill();
			addChild(_sprite);
			_sprite.x = 200;
			_sprite.y = 200;
			
			// Create a KeyMapper to control the Sprite with the keyboard 
			var keyMapper:KeyMapper = new KeyMapper(this.stage);
			
			// Use cursor keys to move left, right, up and down
			keyMapper.map(KeyCode.LEFT, this.moveHorizontal, [-1]);
			keyMapper.map(KeyCode.RIGHT, this.moveHorizontal, [1]);
			keyMapper.map(KeyCode.UP, this.moveVertical, [-1]);
			keyMapper.map(KeyCode.DOWN, this.moveVertical, [1]);
			
			// use Shift key to move even faster
			keyMapper.map(KeyCode.LEFT + KeyMapper.SHIFT, this.moveHorizontal, [-20]);
			keyMapper.map(KeyCode.RIGHT + KeyMapper.SHIFT, this.moveHorizontal, [20]);
			keyMapper.map(KeyCode.UP + KeyMapper.SHIFT, this.moveVertical, [-20]);
			keyMapper.map(KeyCode.DOWN + KeyMapper.SHIFT, this.moveVertical, [20]);
			
			logInfo("Use the following keys to control the object:\n" + keyMapper.getInfo());
		}

		private function moveHorizontal(speed:Number):void 
		{
			_sprite.x += speed;
		}

		private function moveVertical(speed:Number):void 
		{
			_sprite.y += speed;
		}
	}
}
