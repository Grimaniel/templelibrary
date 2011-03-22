package temple.ui.scroll 
{
	import temple.CodeComponents;
	import temple.core.CoreShape;
	import temple.ui.buttons.CodeButton;
	import temple.ui.layout.Direction;
	import temple.ui.layout.Orientation;
	import temple.ui.style.CodeStyle;

	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;

	/**
	 * @author Thijs Broerse
	 */
	public class CodeScrollButton extends CodeButton 
	{
		CodeComponents;
		
		public function CodeScrollButton(orientation:String = Orientation.VERTICAL, direction:String = Direction.ASCENDING, width:Number = 14, height:Number = 14, x:Number = 0, y:Number = 0)
		{
			super(width, height, x, y);
			
			// draw icon
			var icon:CoreShape = new CoreShape();
			this.addChild(icon);
			icon.x = width * .5;
			icon.y = height * .5;
			
			icon.graphics.beginFill(CodeStyle.iconColor, CodeStyle.iconAlpha);
			icon.graphics.lineStyle(0, 0x000000, 0, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER, 3);
			icon.graphics.moveTo(0, -3);
			icon.graphics.lineTo(4, 2);
			icon.graphics.lineTo(-4, 2);
			icon.graphics.lineTo(0, -3);
			icon.graphics.endFill();
			
			switch (orientation)
			{
				case Orientation.HORIZONTAL:
					switch (direction)
					{
						case Direction.ASCENDING:
							// right
							icon.rotation = 90;
							break;
						case Direction.DESCENDING:
							// left
							icon.rotation = -90;
							break;
					}
					break;
				case Orientation.VERTICAL:
					switch (direction)
					{
						case Direction.ASCENDING:
							// down
							icon.rotation = 180;
							break;
						case Direction.DESCENDING:
							// up
							icon.rotation = 0;
							break;
					}
					break;
			}
		}
	}
}
