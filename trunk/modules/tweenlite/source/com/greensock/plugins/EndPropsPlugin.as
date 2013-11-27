package com.greensock.plugins
{
	import com.greensock.TweenLite;
	
	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	public class EndPropsPlugin extends TweenPlugin
	{
		public static const API:Number = 1.0;
		
		/** @private **/
		private var _target:Object;
		/** @private **/
		private var _tween:TweenLite;
		/** @private **/
		private var _endProps:Object;

		public function EndPropsPlugin()
		{
			super("end");
		}
		/** @private **/
		override public function _onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			_target = target;
			_tween = tween;
			_endProps = value;
			
			return true;
		}
		
		/** @private **/
		override public function setRatio(n:Number):void {
			var key : *;
			if (n == 1) { //a changeFactor of 1 doesn't necessarily mean the tween is done - if the ease is Elastic.easeOut or Back.easeOut for example, they could hit 1 mid-tween. The reason we check to see if cachedTime is 0 is for from() tweens
				for (key in _endProps)
				{
					_target[key] = _endProps[key];
				};
			}
		}
	}
}
