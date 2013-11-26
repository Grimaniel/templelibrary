		/**
		 * @inheritDoc
		 */
		public function get children():Vector.<DisplayObject>
		{
			var i:int = numChildren;
			var children:Vector.<DisplayObject> = new Vector.<DisplayObject>(i, true);
			for (--i; i >= 0; --i)
			{
				children[i] = getChildAt(i);
			}
			return children;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addChildAtPosition(child:DisplayObject, x:Number, y:Number, index:int = -1):DisplayObject
		{
			child.x = x;
			child.y = y;
			
			return index < 0 ? addChild(child) : addChildAt(child, index);
		}
		