package temple.ui.style
{
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	/**
	 * @author Thijs Broerse
	 */
	public class RoundedBlueCodeStyle
	{
		public static function init():void
		{
			CodeStyle.buttonColor = 0x8888FF;
			CodeStyle.buttonRounding = 30;
			CodeStyle.buttonFilters = [new BevelFilter(2, 45, 0xffffff, 1, 0x000000, 1, 2, 2)];
			CodeStyle.buttonOverstateColor = 0xFFFFFF;
			CodeStyle.buttonOverstateAlpha = .5;
			CodeStyle.buttonDownstateColor = 0x0000FF;
			CodeStyle.buttonDownstateAlpha = .5;
			
			CodeStyle.textFormat.font = "Arial";
			CodeStyle.textFormat.size = 12;
			CodeStyle.textFormat.bold = true;
			CodeStyle.textColor = 0x0000FF;
			
			CodeStyle.backgroundColor = 0xEEEEFF;
			CodeStyle.backgroundAlpha = .9;
			CodeStyle.backgroundRounding = 14;
			CodeStyle.backgroundFilters = [new DropShadowFilter(2, 45, 0x0000FF, .75, 4, 4, 1, 1, true)];
		}
	}
}
