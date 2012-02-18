package com.greensock.plugins
{
	import com.greensock.TweenLite;
	
	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	public class TempPropsPlugin extends TweenPlugin
	{
		public static const API:Number = 1.0;
		
		/** @private **/
		private var _target:Object;
		/** @private **/
		private var _tween:TweenLite;
		/** @private **/
		private var _tempProps:Object;
		/** @private **/
		private var _initProps:Object;
		
		public function TempPropsPlugin()
		{
			super();
			
			this.propName = "temp";
			this.overwriteProps = ["temp"];
		}
		/** @private **/
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			_target = target;
			_tween = tween;
			_initProps = {};

			_tempProps = value;
			
			for (var key : * in _tempProps)
			{
				_initProps[key] = target[key];
				_target[key] = _tempProps[key];
			}
			return true;
		}
		
		/** @private **/
		override public function set changeFactor(n:Number):void {
			var key : *;
			if (n == 1 && (_tween.cachedDuration == _tween.cachedTime || _tween.cachedTime == 0)) { //a changeFactor of 1 doesn't necessarily mean the tween is done - if the ease is Elastic.easeOut or Back.easeOut for example, they could hit 1 mid-tween. The reason we check to see if cachedTime is 0 is for from() tweens
				for (key in _tempProps)
				{
					_target[key] = _initProps[key];
				};
			} else {
				for (key in _tempProps)
				{
					_target[key] = _tempProps[key];
				};
			}
		}
	}
}
