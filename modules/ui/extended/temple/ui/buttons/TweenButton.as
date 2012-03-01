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

package temple.ui.buttons 
{
	import temple.data.collections.ICollection;
	import temple.data.collections.PropertyValueData;
	import temple.ui.buttons.behaviors.ButtonTweenBehavior;

	import flash.events.Event;

	/**
	 * A <code>MultiStateButtom</code> which can use TweenMax to tween between different states.
	 * 
	 * <p>The Temple knows different kinds of buttons. Check out the 
	 * <a href="http://templelibrary.googlecode.com/svn/trunk/modules/ui/readme.html" target="_blank">button schema</a>
	 * in the UI Module of the Temple for a list of all available buttons which their features. </p>
	 * 
	 * @see ../../../../readme.html
	 * @see temple.ui.buttons.MultiStateButton
	 * @see temple.ui.buttons.behaviors.TweenButtonBehavior
	 * 
	 * @includeExample TweenButtonExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class TweenButton extends MultiStateButton 
	{
		private var _tweenBehavior:ButtonTweenBehavior;
		
		public function TweenButton()
		{
			this._tweenBehavior = new ButtonTweenBehavior(this);
			
			this.addEventListener(Event.ACTIVATE, this.handleActivate);
		}
		
		/**
		 * Returns a reference to the ButtonTweenBehavior.
		 */
		public function get tweenBehavior():ButtonTweenBehavior
		{
			return this._tweenBehavior;
		}
		
		/**
		 * Total duration of the 'up' animation in seconds
		 */
		public function get upDuration():Number
		{
			return this._tweenBehavior.upDuration;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Up duration", type="Number")]
		public function set upDuration(value:Number):void
		{
			this._tweenBehavior.upDuration = value;
		}
		
		/**
		 * 
		 */
		public function get upVars():Object 
		{
			return this._tweenBehavior.upVars;
		}

		/**
		 * @private
		 */
		[Collection(name="Up vars", collectionClass="temple.data.collections.Collection", collectionItem="temple.data.collections.PropertyValueData",identifier="property")]
		public function set upVars(value:Object):void 
		{
			if (value is ICollection)
			{
				var vars:Object = new Object;
				var pvd:PropertyValueData;
				var leni:int = (value as ICollection).length;
				for (var i:int = 0; i < leni ; i++)
				{
					pvd = (value as ICollection).getItemAt(i) as PropertyValueData;
					if (pvd)
					{
						vars[pvd.property] = pvd.value;
					}
					else
					{
						this.logError("childrenLiquidProperties: '" + (value as ICollection).getItemAt(i) + "' is not of type PropertyValueData");
					}
				}
				this._tweenBehavior.upVars = vars;
			}
			else
			{
				this._tweenBehavior.upVars = value;
			}
		}

		/**
		 * Total duration of the 'over' animation in seconds
		 */
		public function get overDuration():Number
		{
			return this._tweenBehavior.overDuration;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Over duration", type="Number")]
		public function set overDuration(value:Number):void
		{
			this._tweenBehavior.overDuration = value;
		}
		
		/**
		 * @private
		 */
		[Collection(name="Over vars", collectionClass="temple.data.collections.Collection", collectionItem="temple.data.collections.PropertyValueData",identifier="property")]
		public function set overVars(value:Object):void 
		{
			if (value is ICollection)
			{
				var vars:Object = new Object;
				var pvd:PropertyValueData;
				var leni:int = (value as ICollection).length;
				for (var i:int = 0; i < leni ; i++)
				{
					pvd = (value as ICollection).getItemAt(i) as PropertyValueData;
					if (pvd)
					{
						vars[pvd.property] = pvd.value;
					}
					else
					{
						this.logError("childrenLiquidProperties: '" + (value as ICollection).getItemAt(i) + "' is not of type PropertyValueData");
					}
				}
				this._tweenBehavior.overVars = vars;
			}
			else
			{
				this._tweenBehavior.overVars = value;
			}
		}
		
		/**
		 * Total duration of the 'down' animation in seconds
		 */
		public function get downDuration():Number
		{
			return this._tweenBehavior.downDuration;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Down duration", type="Number")]
		public function set downDuration(value:Number):void
		{
			this._tweenBehavior.downDuration = value;
		}
		
		/**
		 * @private
		 */
		[Collection(name="Down vars", collectionClass="temple.data.collections.Collection", collectionItem="temple.data.collections.PropertyValueData",identifier="property")]
		public function set downVars(value:Object):void 
		{
			if (value is ICollection)
			{
				var vars:Object = new Object;
				var pvd:PropertyValueData;
				var leni:int = (value as ICollection).length;
				for (var i:int = 0; i < leni ; i++)
				{
					pvd = (value as ICollection).getItemAt(i) as PropertyValueData;
					if (pvd)
					{
						vars[pvd.property] = pvd.value;
					}
					else
					{
						this.logError("childrenLiquidProperties: '" + (value as ICollection).getItemAt(i) + "' is not of type PropertyValueData");
					}
				}
				this._tweenBehavior.downVars = vars;
			}
			else
			{
				this._tweenBehavior.downVars = value;
			}
		}
		
		/**
		 * Total duration of the 'selected' animation in seconds
		 */
		public function get selectedDuration():Number
		{
			return this._tweenBehavior.selectedDuration;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Selected duration", type="Number")]
		public function set selectedDuration(value:Number):void
		{
			this._tweenBehavior.selectedDuration = value;
		}
		
		/**
		 * @private
		 */
		[Collection(name="Selected vars", collectionClass="temple.data.collections.Collection", collectionItem="temple.data.collections.PropertyValueData",identifier="property")]
		public function set selectedVars(value:Object):void 
		{
			if (value is ICollection)
			{
				var vars:Object = new Object;
				var pvd:PropertyValueData;
				var leni:int = (value as ICollection).length;
				for (var i:int = 0; i < leni ; i++)
				{
					pvd = (value as ICollection).getItemAt(i) as PropertyValueData;
					if (pvd)
					{
						vars[pvd.property] = pvd.value;
					}
					else
					{
						this.logError("childrenLiquidProperties: '" + (value as ICollection).getItemAt(i) + "' is not of type PropertyValueData");
					}
				}
				this._tweenBehavior.selectedVars = vars;
			}
			else
			{
				this._tweenBehavior.selectedVars = value;
			}
		}
		
		/**
		 * Total duration of the 'disabled' animation in seconds
		 */
		public function get disabledDuration():Number
		{
			return this._tweenBehavior.disabledDuration;
		}
		
		/**
		 * @private
		 */
		[Inspectable(name="Disabled duration", type="Number")]
		public function set disabledDuration(value:Number):void
		{
			this._tweenBehavior.disabledDuration = value;
		}
		
		/**
		 * @private
		 */
		[Collection(name="Disabled vars", collectionClass="temple.data.collections.Collection", collectionItem="temple.data.collections.PropertyValueData",identifier="property")]
		public function set disabledVars(value:Object):void 
		{
			if (value is ICollection)
			{
				var vars:Object = new Object;
				var pvd:PropertyValueData;
				var leni:int = (value as ICollection).length;
				for (var i:int = 0; i < leni ; i++)
				{
					pvd = (value as ICollection).getItemAt(i) as PropertyValueData;
					if (pvd)
					{
						vars[pvd.property] = pvd.value;
					}
					else
					{
						this.logError("childrenLiquidProperties: '" + (value as ICollection).getItemAt(i) + "' is not of type PropertyValueData");
					}
				}
				this._tweenBehavior.disabledVars = vars;
			}
			else
			{
				this._tweenBehavior.disabledVars = value;
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function set debug(value:Boolean):void
		{
			super.debug = value;
			
			if (this._tweenBehavior) this._tweenBehavior.debug = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get updateByParent():Boolean
		{
			return super.updateByParent && this._tweenBehavior.updateByParent;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Update By Parent", type="Boolean", defaultValue="true")]
		override public function set updateByParent(value:Boolean):void
		{
			this._tweenBehavior.updateByParent = super.updateByParent = value;
		}
		
		private function handleActivate(event:Event):void
		{
			this._tweenBehavior.update(this._tweenBehavior);
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._tweenBehavior = null;
			
			super.destruct();
		}
	}
}
