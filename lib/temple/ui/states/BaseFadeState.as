/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
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
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.throwError;

	import com.greensock.TweenLite;

	/**
	 * This class uses a TweenLite fade (autoAlpha) to show and hide the object. This class is used as base for several states.
	 * 
	 * @includeExample StatesExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class BaseFadeState extends AbstractState implements IState 
	{
		private var _showDuration:Number;
		private var _hideDuration:Number;

		public function BaseFadeState(showDuration:Number = .5, hideDuration:Number = .5)
		{
			this.visible = false;
			this.alpha = 0;
			
			this.showDuration = showDuration;
			this.hideDuration = hideDuration;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function show(instant:Boolean = false):void
		{
			if (this.enabled == false || this._shown) return;
			this._shown = true;
			
			if (instant)
			{
				this.autoAlpha = 1;
			}
			else
			{
				TweenLite.to(this, this._showDuration, {autoAlpha:1});
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function hide(instant:Boolean = false):void
		{
			if (this.enabled == false || !this._shown) return;
			this._shown = false;
			
			if (instant)
			{
				this.autoAlpha = 0;
			}
			else
			{
				TweenLite.to(this, this._hideDuration, {autoAlpha:0});
			}
		}
		
		/**
		 * Duration in seconds of the fade-in animation
		 */
		public function get showDuration():Number
		{
			return this._showDuration;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Show duration", type="Number", defaultValue="0.5")]
		public function set showDuration(value:Number):void
		{
			if(isNaN(value)) throwError(new TempleArgumentError(this, "showDuration can not be NaN"));
			
			this._showDuration = value;
		}
		
		/**
		 * Duration in seconds of the fade-in animation
		 */
		public function get hideDuration():Number
		{
			return this._hideDuration;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Hide duration", type="Number", defaultValue="0.5")]
		public function set hideDuration(value:Number):void
		{
			if(isNaN(value)) throwError(new TempleArgumentError(this, "hideDuration can not be NaN"));
			
			this._hideDuration = value;
		}
	}
}
