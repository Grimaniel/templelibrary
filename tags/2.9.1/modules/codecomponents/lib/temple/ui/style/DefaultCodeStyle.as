package temple.ui.style
{
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	/**
	 * @author Thijs Broerse
	 */
	public final class DefaultCodeStyle
	{
		public static function init():void
		{
			CodeStyle.textFormat.font = "_sans";
			CodeStyle.textFormat.size = 11;
			CodeStyle.textFormat.leftMargin = CodeStyle.textFormat.rightMargin = 4;

			CodeStyle.toolTipTextFormat.font = "_sans";
			CodeStyle.toolTipTextFormat.size = 10;
			CodeStyle.toolTipTextFormat.leftMargin = CodeStyle.toolTipTextFormat.rightMargin = 0;
			
			CodeStyle.textColor = 0x000000;
		
			CodeStyle.outlineThickness = 1;
			CodeStyle.outlineColor = 0x000000;
			CodeStyle.outlineAlpha = .9;
		
			CodeStyle.backgroundColor = 0xffffff;
			CodeStyle.backgroundAlpha = .9;
			CodeStyle.backgroundRounding = 0;
			CodeStyle.backgroundFilters = [new DropShadowFilter(2, 45, 0, 1, 2, 2, .5, 1, true)];
		
			CodeStyle.buttonColor = 0x999999;
			CodeStyle.buttonAlpha = 1;
			CodeStyle.buttonFilters = [new BevelFilter(1, 45, 0xffffff, 1, 0x000000, 1, 1, 1, 1, 1)];
			CodeStyle.buttonOverstateColor = 0xeeeeee;
			CodeStyle.buttonOverstateAlpha = 1;
			
			CodeStyle.focusFilters = [new GlowFilter(0xffffff, .5, 3, 3, 2, 1, false, true)];
			
			CodeStyle.iconColor = 0x000000;
			CodeStyle.iconAlpha = 1;
			
			CodeStyle.listItemSelectstateColor = 0x888888;
			CodeStyle.listItemSelectstateAlpha = .5;
			CodeStyle.listItemOverstateColor = 0x888888;
			CodeStyle.listItemOverstateAlpha = .2;
			
			CodeStyle.toolTipBackgroundColor = 0xFFFFFF;
			CodeStyle.toolTipBackgroundAlpha = .8;
			CodeStyle.toolTipBorderColor = 0x000000;
			CodeStyle.toolTipBorderAlpha = 1;
			CodeStyle.toolTipTextColor = 0x000000;
			CodeStyle.toolTipFilters = [new DropShadowFilter()];
		}
	}
}
