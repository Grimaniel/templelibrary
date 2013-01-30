		/**
		 * Checks for a <code>scrollRect</code> and returns the width of the <code>scrollRect</code>.
		 * Otherwise the <code>super.width</code> is returned. This fixes a FlashPlayer bug; Flash doesn't immediatly
		 * update the objects width when a scrollRect is set on a DisplayObject.
		 */
		override public function get width():Number
		{
			return scrollRect ? scrollRect.width : super.width;
		}
		
		/**
		 * If the object does not have a width and is not scaled to 0 the object is empty, 
		 * setting the width is useless and can only cause weird errors, so we don't.
		 */
		override public function set width(value:Number):void
		{
			if (super.width || !scaleX) super.width = value;
		}
		
		/**
		 * Checks for a <code>scrollRect</code> and returns the height of the <code>scrollRect</code>.
		 * Otherwise the <code>super.height</code> is returned. This fixes a FlashPlayer bug; Flash doesn't immediatly
		 * update the objects height when a scrollRect is set on a DisplayObject.
		 */
		override public function get height():Number
		{
			return scrollRect ? scrollRect.height : super.height;
		}

		/**
		 * If the object does not have a height and is not scaled to 0 the object is empty, 
		 * setting the height is useless and can only cause weird errors, so we don't. 
		 */
		override public function set height(value:Number):void
		{
			if (super.height || !scaleY) super.height = value;
		}
		
		/**
		 * When object is not on the stage it gets the stage reference from the StageProvider. So therefore this object
		 * will always has a reference to the stage.
		 */
		override public function get stage():Stage
		{
			return super.stage || StageProvider.stage;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get onStage():Boolean
		{
			return _onStage;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get hasParent():Boolean
		{
			return _onParent;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeFromParent():void
		{
			if (parent && _onParent) parent.removeChild(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoAlpha():Number
		{
			return visible ? alpha : 0;
		}

		/**
		 * @inheritDoc
		 */
		public function set autoAlpha(value:Number):void
		{
			alpha = value;
			visible = alpha > 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get position():Point
		{
			return new Point(x, y);
		}
		
		/**
		 * @inheritDoc
		 */
		public function set position(value:Point):void
		{
			x = value.x;
			y = value.y;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scale():Number
		{
			return scaleX == scaleY ? scaleX : NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set scale(value:Number):void
		{
			scaleX = scaleY = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get destructOnUnload():Boolean
		{
			return _destructOnUnload;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set destructOnUnload(value:Boolean):void
		{
			_destructOnUnload = value;
		}