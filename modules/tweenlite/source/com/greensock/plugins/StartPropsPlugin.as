package com.greensock.plugins
{
	import com.greensock.TweenLite;
	
	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	public class StartPropsPlugin extends TweenPlugin
	{
		public static const API:Number = 1.0;
		
		public function StartPropsPlugin()
		{
			super("start");
		}
		/** @private **/
		override public function _onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			for (var key : * in value)
			{
				target[key] = value[key];
			}
			return true;
		}
		
		/** @private **/
		override public function setRatio(n:Number):void {
		}
	}
}
