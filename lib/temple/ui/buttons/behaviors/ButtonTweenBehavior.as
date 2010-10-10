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

package temple.ui.buttons.behaviors 
{
	import temple.ui.buttons.behaviors.AbstractButtonDesignBehavior;
	import temple.utils.types.ObjectUtils;

	import com.greensock.OverwriteManager;
	import com.greensock.TweenMax;
	import com.greensock.easing.EaseLookup;

	import flash.display.DisplayObject;

	/**
	 * The ButtonTweenBehavior uses TweenMax to tween to a state. To define a state you just add
	 * an object with properties as you would do for a 'normal' TweenMax tween. 
	 * 
	 * @includeExample ../TweenButtonExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class ButtonTweenBehavior extends AbstractButtonDesignBehavior
	{
		private static const _UP:String = "up";
		private static const _OVER:String = "over";
		private static const _DOWN:String = "down";
		private static const _SELECTED:String = "selected";
		private static const _DISABLED:String = "disabled";
		
		private var _upVars:Object;
		private var _upDuration:Number;
		
		private var _overVars:Object;
		private var _overDuration:Number;
		
		private var _downVars:Object;
		private var _downDuration:Number;
		
		private var _selectedVars:Object;
		private var _selectedDuration:Number;
		
		private var _disabledVars:Object;
		private var _disabledDuration:Number;
		
		private var _state:String;
		
		public function ButtonTweenBehavior(target:DisplayObject, upDuration:Number = NaN, upVars:Object = null, overDuration:Number = NaN, overVars:Object = null, downDuration:Number = NaN, downVars:Object = null)
		{
			super(target);
			
			OverwriteManager.init();
			
			this.upDuration = upDuration;
			this.upVars = upVars;
			
			this.overDuration = overDuration;
			this.overVars = overVars;
			
			this.downDuration = downDuration;
			this.downVars = downVars;
		}

		public function get upVars():Object
		{
			return this._upVars;
		}
		
		public function set upVars(value:Object):void
		{
			this._upVars = value;
			if(this.debug) this.logDebug("upVars: " + ObjectUtils.traceObject(this._upVars, 3, false));
			this.update(this);
		}
		
		/**
		 * Total duration of the 'up' animation in seconds
		 */
		public function get upDuration():Number
		{
			return this._upDuration;
		}
		
		/**
		 * @private
		 */
		public function set upDuration(value:Number):void
		{
			this._upDuration = value;
		}
		
		public function setUpTween(duration:Number, vars:Object):void
		{
			this.upDuration = duration;
			this.upVars = vars;
		}

		public function get overVars():Object
		{
			return this._overVars;
		}
		
		/**
		 * @private
		 */
		public function set overVars(value:Object):void
		{
			this._overVars = value;
			if(this.debug) this.logDebug("overVars: " + ObjectUtils.traceObject(this._overVars, 3, false));
			this.update(this);
		}
		
		/**
		 * Total duration of the 'over' animation in seconds
		 */
		public function get overDuration():Number
		{
			return this._overDuration;
		}
		
		/**
		 * @private
		 */
		public function set overDuration(value:Number):void
		{
			this._overDuration = value;
		}
		
		public function setOverTween(duration:Number, vars:Object):void
		{
			this.overDuration = duration;
			this.overVars = vars;
		}
		
		public function get downVars():Object
		{
			return this._downVars;
		}
		
		/**
		 * @private
		 */
		public function set downVars(value:Object):void
		{
			this._downVars = value;
			if(this.debug) this.logDebug("downVars: " + ObjectUtils.traceObject(this._downVars, 3, false));
			this.update(this);
		}
		
		/**
		 * Total duration of the 'down' animation in seconds
		 */
		public function get downDuration():Number
		{
			return this._downDuration;
		}
		
		/**
		 * @private
		 */
		public function set downDuration(value:Number):void
		{
			this._downDuration = value;
		}
		
		public function setDownTween(duration:Number, vars:Object):void
		{
			this.downDuration = duration;
			this.downVars = vars;
		}
		
		public function get selectedVars():Object
		{
			return this._selectedVars;
		}
		
		/**
		 * @private
		 */
		public function set selectedVars(value:Object):void
		{
			this._selectedVars = value;
			if(this.debug) this.logDebug("selectedVars: " + ObjectUtils.traceObject(this._selectedVars, 3, false));
			this.update(this);
		}
		
		/**
		 * Total duration of the 'selected' animation in seconds
		 */
		public function get selectedDuration():Number
		{
			return this._selectedDuration;
		}
		
		/**
		 * @private
		 */
		public function set selectedDuration(value:Number):void
		{
			this._selectedDuration = value;
		}
		
		public function setSelectedTween(duration:Number, vars:Object):void
		{
			this.selectedDuration = duration;
			this.selectedVars = vars;
		}
		
		public function get disabledVars():Object
		{
			return this._disabledVars;
		}
		
		/**
		 * @private
		 */
		public function set disabledVars(value:Object):void
		{
			this._disabledVars = value;
			if(this.debug) this.logDebug("disabledVars: " + ObjectUtils.traceObject(this._disabledVars, 3, false));
			this.update(this);
		}
		
		/**
		 * Total duration of the 'disabled' animation in seconds
		 */
		public function get disabledDuration():Number
		{
			return this._disabledDuration;
		}
		
		/**
		 * @private
		 */
		public function set disabledDuration(value:Number):void
		{
			this._disabledDuration = value;
		}
		
		public function setDisabledTween(duration:Number, vars:Object):void
		{
			this.disabledDuration = duration;
			this.disabledVars = vars;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update(status:IButtonStatus):void
		{
			super.update(status);
			
			if(!this.enabled) return;
			
			if(this.debug) this.logDebug("update: selected=" + this.selected + ", disabled=" + this.disabled + ", over=" + this.over + ", down=" + this.down + ", state=" + this._state);
			
			switch(true)
			{
				case this.selected:
				{
					this.selectedState();
					break;
				}
				case this.disabled:
				{
					this.disabledState();
					break;
				}
				case this.down:
				{
					this.downState();
					break;
				}
				case this.over:
				{
					this.overState();
					break;
				}
				default:
				{
					this.upState();
					break;
				}
			}
		}
		
		/**
		 * Go to the 'up' state.
		 * @param immediately if set to true, the upDuration will be ignored and the state will immediatly be set
		 */
		public function upState(immediately:Boolean = false):void
		{
			this.toState(ButtonTweenBehavior._UP, immediately ? 0 : this._upDuration, this._upVars);
		}
		
		/**
		 * Go to the 'over' state.
		 * @param immediately if set to true, the overDuration will be ignored and the state will immediatly be set
		 */
		public function overState(immediately:Boolean = false):void
		{
			this.toState(ButtonTweenBehavior._OVER, immediately ? 0 : this._overDuration, this._overVars);
		}
		
		/**
		 * Go to the 'down' state.
		 * @param immediately if set to true, the downDuration will be ignored and the state will immediatly be set
		 */
		public function downState(immediately:Boolean = false):void
		{
			this.toState(ButtonTweenBehavior._DOWN, immediately ? 0 : this._downDuration, this._downVars);
		}
		
		/**
		 * Go to the 'selected' state.
		 * @param immediately if set to true, the selectedDuration will be ignored and the state will immediatly be set
		 */
		public function selectedState(immediately:Boolean = false):void
		{
			this.toState(ButtonTweenBehavior._SELECTED, immediately ? 0 : this._selectedDuration, this._selectedVars);
		}

		/**
		 * Go to the 'disabled' state.
		 * @param immediately if set to true, the disabledDuration will be ignored and the state will immediatly be set
		 */
		public function disabledState(immediately:Boolean = false):void
		{
			this.toState(ButtonTweenBehavior._DISABLED, immediately ? 0 : this._disabledDuration, this._disabledVars);
		}

		private function toState(state:String, duration:Number, vars:Object):void
		{
			if(this.debug) this.logDebug("toState: " + state + ", duration: " + duration + ", vars: " + ObjectUtils.traceObject(vars, 3, false));
			
			this._state = state;
			if(isNaN(duration)) duration = 0;
			if(vars)
			{
				if(vars['ease'] is String) vars['ease'] = EaseLookup.find(vars['ease']);
				TweenMax.to(this.target, duration, vars);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._upVars = null;
			this._overVars = null;
			this._downVars = null;
			this._selectedVars = null;
			this._disabledVars = null;
			this._state = null;
			
			super.destruct();
		}
	}
}
