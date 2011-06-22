package temple.ui.icons 
{
	import temple.CodeComponents;
	import temple.core.CoreShape;

	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;

	/**
	 * @author Thijs Broerse
	 */
	public class CodeCheck extends CoreShape 
	{
		CodeComponents;
		
		public function CodeCheck(color:uint = 0x000000, alpha:Number = 1)
		{
			super("CodeCheck");
			
			this.graphics.beginFill(color, alpha);
			this.graphics.lineStyle(0, 0x000000, 0, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER, 3);
			this.graphics.moveTo(3, 6);
			this.graphics.lineTo(6, 9);
			this.graphics.lineTo(12, 3);
			this.graphics.lineTo(12, 6);
			this.graphics.lineTo(6, 12);
			this.graphics.lineTo(3, 9);
			this.graphics.lineTo(3, 6);
			this.graphics.endFill();
		}
	}
}
