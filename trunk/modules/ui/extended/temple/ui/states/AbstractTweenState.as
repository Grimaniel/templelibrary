/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2012 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *	
 */

package temple.ui.states 
{
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;

	import com.greensock.TweenMax;

	/**
	 * This class uses TweenLite to show and hide the object. This class is used as base for several states.
	 * 
	 * @includeExample StatesExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class AbstractTweenState extends AbstractState implements IState 
	{
		private var _showDuration:Number;
		private var _hideDuration:Number;
		private var _showVars:Object;
		private var _hideVars:Object;
		private var _tween:TweenMax;

		public function AbstractTweenState(showVars:Object, hideVars:Object, showDuration:Number = .5, hideDuration:Number = .5)
		{
			this._showVars = showVars;
			this._hideVars = hideVars;
			this.showDuration = showDuration;
			this.hideDuration = hideDuration;
			
			this.hide(true);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function show(instant:Boolean = false):void
		{
			this.tween(true, instant ? 0 : this._showDuration, this._showVars);
		}

		/**
		 * @inheritDoc
		 */
		override public function hide(instant:Boolean = false):void
		{
			this.tween(false, instant ? 0 : this._hideDuration, this._hideVars);
		}
		
		/**
		 * Duration in seconds of the fade-in animation
		 */
		public final function get showDuration():Number
		{
			return this._showDuration;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Show duration", type="Number", defaultValue="0.5")]
		public final function set showDuration(value:Number):void
		{
			if (isNaN(value)) throwError(new TempleArgumentError(this, "showDuration cannot be NaN"));
			
			this._showDuration = value;
		}
		
		/**
		 * Duration in seconds of the fade-in animation
		 */
		public final function get hideDuration():Number
		{
			return this._hideDuration;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Hide duration", type="Number", defaultValue="0.5")]
		public final function set hideDuration(value:Number):void
		{
			if (isNaN(value)) throwError(new TempleArgumentError(this, "hideDuration cannot be NaN"));
			
			this._hideDuration = value;
		}
		
		private function tween(show:Boolean, duration:Number, vars:Object):void
		{
			if (vars == null)
			{
				throwError(new TempleArgumentError(this, "Vars cannot be null"));
				return;
			}
			if (this.enabled == false || this._shown == show && duration > 0) return;
			this._shown = show;
			vars.immediateRender = duration == 0;
			if (this._tween) this._tween.kill();
			this._tween = TweenMax.to(this, duration, vars);
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._tween)
			{
				this._tween.kill();
				this._tween = null;
			}
			this._showVars = null;
			this._hideVars = null;
			
			super.destruct();
		}

	}
}
