package temple.ui.style 
{
	import temple.CodeComponents;

	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;

	/**
	 * @author Thijs Broerse
	 */
	public final class CodeStyle 
	{
		CodeComponents.checkVersion();
		
		/**
		 * Text
		 */
		public static const textFormat:TextFormat = new TextFormat();
		public static var textColor:uint = 0x000000;
		
		/**
		 * Outline properties
		 */
		public static var outlineThickness:Number = 1;
		public static var outlineColor:uint = 0x000000;
		public static var outlineAlpha:Number = .9;
		
		/**
		 * Background properties
		 */
		public static var backgroundColor:uint = 0xffffff;
		public static var backgroundAlpha:Number = .9;
		public static var backgroundRounding:Number = 2;
		public static var backgroundFilters:Array = [new DropShadowFilter(2, 45, 0, 1, 2, 2, .5, 1, true)];
		
		/**
		 * Button
		 */
		public static var buttonColor:uint = 0x999999;
		public static var buttonAlpha:Number = 1;
		public static var buttonRounding:Number = 0;
		public static var buttonFilters:Array = [new BevelFilter(1, 45, 0xffffff, 1, 0x000000, 1, 1, 1, 1, 1)];
		public static var buttonOverstateColor:uint = 0xeeeeee;
		public static var buttonOverstateAlpha:Number = 1;
		public static var buttonDownstateColor:uint = 0xeeeeee;
		public static var buttonDownstateAlpha:Number = 1;
		
		/**
		 * Focus
		 */
		public static var focusFilters:Array = [new GlowFilter(0xffffff, .75, 3, 3, 2, 1, false, true)];
		
		/**
		 * Icons
		 */
		public static var iconColor:uint = 0x000000;
		public static var iconAlpha:Number = 1;
		
		/**
		 * List
		 */
		public static var listItemSelectstateColor:uint = 0x888888;
		public static var listItemSelectstateAlpha:Number = .5;
		public static var listItemOverstateColor:uint = 0x888888;
		public static var listItemOverstateAlpha:Number = .2;
		
		/**
		 * ToolTip
		 */
		public static var toolTipBackgroundColor:uint = 0xFFFFFF;
		public static var toolTipBackgroundAlpha:Number = .8;
		public static var toolTipBorderColor:uint = 0x000000;
		public static var toolTipBorderAlpha:Number = 1;
		public static var toolTipTextColor:uint = 0x000000;
		public static var toolTipTextFormat:TextFormat = new TextFormat();
		public static var toolTipFilters:Array = [new DropShadowFilter()];

		private static function init():void 
		{
			textFormat.font = "_sans";
			textFormat.size = 11;
			textFormat.leftMargin = textFormat.rightMargin = 4;

			toolTipTextFormat.font = "_sans";
			toolTipTextFormat.size = 10;
			toolTipTextFormat.leftMargin = toolTipTextFormat.rightMargin = 0;
		}
		
		init();
	}
}
