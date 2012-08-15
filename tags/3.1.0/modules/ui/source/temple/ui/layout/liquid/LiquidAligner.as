/*
 *	Temple Library for ActionScript 3.0
 *	Copyright © MediaMonks B.V.
 *	All rights reserved.
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	1. Redistributions of source code must retain the above copyright
 *	   notice, this list of conditions and the following disclaimer.
 *	2. Redistributions in binary form must reproduce the above copyright
 *	   notice, this list of conditions and the following disclaimer in the
 *	   documentation and/or other materials provided with the distribution.
 *	3. All advertising materials mentioning features or use of this software
 *	   must display the following acknowledgement:
 *	   This product includes software developed by MediaMonks B.V.
 *	4. Neither the name of MediaMonks B.V. nor the
 *	   names of its contributors may be used to endorse or promote products
 *	   derived from this software without specific prior written permission.
 *	
 *	THIS SOFTWARE IS PROVIDED BY MEDIAMONKS B.V. ''AS IS'' AND ANY
 *	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *	DISCLAIMED. IN NO EVENT SHALL MEDIAMONKS B.V. BE LIABLE FOR ANY
 *	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
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
