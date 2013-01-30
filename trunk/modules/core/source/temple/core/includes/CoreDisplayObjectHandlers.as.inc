		private function handleUnload(event:Event):void
		{
			if (_destructOnUnload) destruct();
		}
		
		private function handleAdded(event:Event):void
		{
			if (event.currentTarget == this) _onParent = true;
		}

		private function handleAddedToStage(event:Event):void
		{
			_onStage = true;
			StageProvider.stage ||= super.stage;
		}

		private function handleRemoved(event:Event):void
		{
			if (event.target == this)
			{
				_onParent = false;
				if (!_isDestructed) super.addEventListener(Event.ENTER_FRAME, handleDestructedFrameDelay);
			}
		}
		
		private function handleDestructedFrameDelay(event:Event):void
		{
			super.removeEventListener(Event.ENTER_FRAME, handleDestructedFrameDelay);
			checkParent();
		}

		/**
		 * Check objects parent, after being removed. If the object still has a parent, the object has been removed by a timeline animation.
		 * If an object is removed by a timeline animation, the object is not used anymore and can be destructed
		 */
		private function checkParent():void
		{
			if (parent && !_onParent) destruct();
		}

		private function handleRemovedFromStage(event:Event):void
		{
			_onStage = false;
		}		