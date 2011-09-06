package temple.ui.icons 
{
	import temple.CodeComponents;
	import temple.core.CoreShape;

	/**
	 * @author Thijs Broerse
	 */
	public class CodeCross extends CoreShape 
	{
		CodeComponents;
		
		public function CodeCross(color:uint = 0x000000, size:Number = 10, thickness:Number = 2)
		{
			super("CodeCross");
			
			this.graphics.beginFill(color);
			this.graphics.drawRect(-.5 * thickness, -.5 * size, thickness, size);
			this.graphics.endFill();
			this.graphics.beginFill(color);
			this.graphics.drawRect(-.5 * size, -.5 * thickness, size, thickness);
			this.graphics.endFill();
		}
	}
}
