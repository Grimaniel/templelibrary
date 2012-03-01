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

package temple.ui.layout 
{
	import temple.common.enum.Orientation;
	import temple.data.collections.ICollection;
	import temple.data.collections.PropertyValueData;
	import temple.ui.layout.liquid.LiquidBehavior;
	import temple.ui.layout.liquid.LiquidContainer;
	import temple.utils.FrameDelay;
	import temple.utils.PropertyApplier;

	import flash.display.DisplayObject;

	/**
	 * The LayoutContainer lays out its children in a single horizontal row or a single vertical column, deppending on
	 * its <code>orientation</code>.
	 * 
	 * @see temple.ui.layout.LayoutBehavior
	 * 
	 * @author Thijs Broerse
	 */
	public class LayoutContainer extends LiquidContainer implements ILayoutContainer
	{
		private var _layoutBehavior:LayoutBehavior;

		public function LayoutContainer(width:Number = NaN, height:Number = NaN, orientation:String = "horizontal", direction:String = "ascending", spacing:Number = 0)
		{
			super(width, height);
			
			this._layoutBehavior = new LayoutBehavior(this, orientation, direction, spacing, orientation == Orientation.HORIZONTAL ? isNaN(width) : isNaN(height), false);
			// wait a frame before enabling 
			new FrameDelay(this.initLayout);
		}

		private function initLayout():void 
		{
			if (this.isDestructed) return;
			this._layoutBehavior.enabled = true;
			this._layoutBehavior.layoutChildren();
		}

		/**
		 * @inheritDoc
		 */
		public function get orientation():String
		{
			return this._layoutBehavior.orientation;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Orientation", type="String", defaultValue="horizontal", enumeration="horizontal,vertical")]
		public function set orientation(value:String):void
		{
			this._layoutBehavior.orientation = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get direction():String
		{
			return this._layoutBehavior.direction;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Direction", type="String", defaultValue="ascending", enumeration="ascending,descending")]
		public function set direction(value:String):void
		{
			this._layoutBehavior.direction = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get spacing():Number
		{
			return this._layoutBehavior.spacing;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(name="Spacing", type="Number", defaultValue="0")]
		public function set spacing(value:Number):void
		{
			this._layoutBehavior.spacing = value;
		}

		/**
		 * Set an object with properties which will applied on all children.
		 */
		[Collection(name="Children Liquid properties", collectionClass="temple.data.collections.Collection", collectionItem="temple.data.collections.PropertyValueData",identifier="property")]
		public function set childrenLiquidProperties(value:Object):void 
		{
			var properties:Object;
			if (value is ICollection)
			{
				properties = new Object;
				var pvd:PropertyValueData;
				var leni:int = (value as ICollection).length;
				for (var i:int = 0; i < leni ; i++)
				{
					pvd = (value as ICollection).getItemAt(i) as PropertyValueData;
					if (pvd)
					{
						properties[pvd.property] = pvd.value;
					}
					else
					{
						this.logError("childrenLiquidProperties: '" + (value as ICollection).getItemAt(i) + "' is not of type PropertyValueData");
					}
				}
			}
			else
			{
				properties = value;
			}
			
			var liquid:LiquidBehavior;
			var child:DisplayObject;
			leni = this.numChildren;
			for (i = 0; i < leni; i++)
			{
				child = this.getChildAt(i);
				liquid = LiquidBehavior.getInstance(child);
				if (!liquid)
				{
					liquid = new LiquidBehavior(child);
					liquid.init();
				}
				PropertyApplier.apply(liquid, properties);
			}
			this._layoutBehavior.layoutChildren();
		}
		
		/**
		 * Returns a reference to the LayoutBehavior.
		 */
		public function get layoutBehavior():LayoutBehavior
		{
			return this._layoutBehavior;
		}
		
		/**
		 * 
		 */
		public function get ignoreInvisibleChildren():Boolean
		{
			return this._layoutBehavior.ignoreInvisibleChildren;
		}

		/**
		 * @private
		 */
		public function set ignoreInvisibleChildren(value:Boolean):void
		{
			this._layoutBehavior.ignoreInvisibleChildren = value;
		}
		
		/**
		 * Distributes all children of the target corresponding to the orientation, direction and spacing.
		 */
		public function layoutChildren():void
		{
			this._layoutBehavior.layoutChildren();
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._layoutBehavior)
			{
				this._layoutBehavior.destruct();
				this._layoutBehavior = null;
			}
			
			super.destruct();
		}
	}
}
