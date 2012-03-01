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

package temple.ui.layout.liquid
{
	import temple.core.behaviors.AbstractBehavior;
	import temple.core.debug.IDebuggable;
	import temple.core.destruction.DestructEvent;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;

	import flash.events.Event;

	/**
	 * Behavior which can align a liquid object to an other liquid object.
	 * 
	 * @see temple.ui.layout.liquid.LiquidBehavior
	 * 
	 * @author Thijs Broerse
	 */
	public class LiquidAligner extends AbstractBehavior implements IDebuggable
	{
		private var _targetProperty:String;
		private var _related:ILiquidRelatedObject;
		private var _relatedProperty:String;
		private var _offset:Number;
		private var _debug:Boolean;
		
		/**
		 * Let a liquid object align to an other liquid object.
		 * @param target the liquid object that must be aligned.
		 * @param targetProperty the liquid property of the target which must be aligned.
		 * @param related the liquid object which is used to align the target to.
		 * @param relatedProperty the property of the related objected which is used to align the target to.
		 * @param offset a Number which is added to the property to create some spacing between the target and the related.
		 * 
		 * @see temple.ui.layout.liquid.LiquidProperties
		 */
		public function LiquidAligner(target:ILiquidRelatedObject, targetProperty:String, related:ILiquidRelatedObject, relatedProperty:String, offset:Number = 0)
		{
			super(target);
			
			if (!targetProperty in target) throwError(new TempleArgumentError(this, "target object does not has a property '" + targetProperty + "'"));
			if (!relatedProperty in related) throwError(new TempleArgumentError(this, "related object does not has a property '" + targetProperty + "'"));
			
			this._targetProperty = targetProperty;
			this._related = related;
			this._relatedProperty = relatedProperty;
			this._offset = offset;
			
			this._related.addEventListener(Event.RESIZE, this.handleRelatedResize);
			this._related.addEventListener(DestructEvent.DESTRUCT, this.handleRelatedDestructed);
			
			this.toStringProps.push("targetProperty", "related", "relatedProperty", "offset");
			
			this.update();
		}
		
		/**
		 * The liquid property of the target which must be aligned.
		 * 
		 * @see temple.ui.layout.liquid.LiquidProperties
		 */
		public function get targetProperty():String
		{
			return this._targetProperty;
		}
		
		/**
		 * The property of the related objected which is used to align the target to.
		 * 
		 * @see temple.ui.layout.liquid.LiquidProperties
		 */
		public function get relatedProperty():String
		{
			return this._relatedProperty;
		}

		/**
		 * The liquid object which is used to align the target to.
		 */
		public function get related():ILiquidRelatedObject
		{
			return this._related;
		}

		/**
		 * A Number which is added to the property to create some spacing between the target and the related.
		 */
		public function get offset():Number
		{
			return this._offset;
		}

		/**
		 * @private
		 */
		public function set offset(value:Number):void
		{
			this._offset = value;
		}
		
		/**
		 * Recalculates and sets the property of the target.
		 */
		public function update():void
		{
			if (isNaN(this._related[this._relatedProperty]))
			{
				this.target[this._targetProperty] = LiquidUtils.calculateProperty(this._related, this._relatedProperty) + this._offset;
			}
			else
			{
				this.target[this._targetProperty] = this._related[this._relatedProperty] + this._offset;
			}
			if (this.target is ILiquidObject) ILiquidObject(this.target).update();
			
			if (this.debug) this.logDebug("update: target[" + this._targetProperty + "] = " + this.target[this._targetProperty]);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return this._debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			this._debug = value;
		}

		private function handleRelatedResize(event:Event):void
		{
			this.update();
		}

		private function handleRelatedDestructed(event:DestructEvent):void
		{
			this.destruct();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._related)
			{
				this._related.removeEventListener(Event.RESIZE, this.handleRelatedResize);
				this._related.removeEventListener(DestructEvent.DESTRUCT, this.handleRelatedDestructed);
				this._related = null;
			}
			
			super.destruct();
		}
	}
}
