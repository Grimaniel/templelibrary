/**
 * @exampleText
 * 
 * <p>This is an example about how to use the KeyMapper</p>
 *  
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/utils/keys/KeyMapperExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/utils/keys/KeyMapperExample.swf</a></p>
 */
package  
{
	import temple.core.CoreSprite;
	import temple.utils.keys.KeyCode;
	import temple.utils.keys.KeyMapper;

	public class KeyMapperExample extends CoreSprite 
	{
		private var _sprite:CoreSprite;
		
		public function KeyMapperExample()
		{
			// Create a new Sprite
			this._sprite = new CoreSprite();
			this._sprite.graphics.beginFill(0x000000);
			this._sprite.graphics.drawRect(0, 0, 20, 20);
			this._sprite.graphics.endFill();
			this.addChild(this._sprite);
			this._sprite.x = 200;
			this._sprite.y = 200;
			
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
		}

		private function moveHorizontal(speed:Number):void 
		{
			this._sprite.x += speed;
		}

		private function moveVertical(speed:Number):void 
		{
			this._sprite.y += speed;
		}
	}
}
