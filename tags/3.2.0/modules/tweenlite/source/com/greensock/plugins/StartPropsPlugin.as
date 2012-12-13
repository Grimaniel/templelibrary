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
			super();
			
			this.propName = "start";
			this.overwriteProps = ["start"];
		}
		/** @private **/
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			for (var key : * in value)
			{
				target[key] = value[key];
			}
			return true;
		}
		
		/** @private **/
		override public function set changeFactor(n:Number):void {
		}
	}
}
