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