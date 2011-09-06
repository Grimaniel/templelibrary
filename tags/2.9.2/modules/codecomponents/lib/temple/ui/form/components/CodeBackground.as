package temple.ui.form.components 
{
	import flash.geom.Rectangle;
	import temple.core.CoreSprite;
	import temple.ui.style.CodeStyle;

	/**
	 * @author Thijs Broerse
	 */
	public class CodeBackground extends CoreSprite 
	{
		public function CodeBackground(width:Number = 14, height:Number = 14)
		{
			if (CodeStyle.backgroundRounding)
			{
//				this.scale9Grid = new Rectangle(CodeStyle.backgroundRounding, CodeStyle.backgroundRounding, width - 2 * CodeStyle.backgroundRounding, height - 2 * CodeStyle.backgroundRounding)
				this.scale9Grid = new Rectangle(3, 3, width - 6, height - 6);
			}
			
			this.graphics.beginFill(CodeStyle.backgroundColor, CodeStyle.backgroundAlpha);
			this.graphics.drawRoundRect(0, 0, width, height, isNaN(CodeStyle.backgroundRounding) ? 0 : CodeStyle.backgroundRounding);
			this.graphics.endFill();
			this.filters = CodeStyle.backgroundFilters;
		}
	}
}
