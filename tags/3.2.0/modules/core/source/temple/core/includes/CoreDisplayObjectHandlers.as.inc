		private function handleUnload(event:Event):void
		{
			if (this._destructOnUnload) this.destruct();
		}
		
		private function handleAdded(event:Event):void
		{
			if (event.currentTarget == this) this._onParent = true;
		}

		private function handleAddedToStage(event:Event):void
		{
			this._onStage = true;
			StageProvider.stage ||= super.stage;
		}

		private function handleRemoved(event:Event):void
		{
			if (event.target == this)
			{
				this._onParent = false;
				if (!this._isDestructed) super.addEventListener(Event.ENTER_FRAME, this.handleDestructedFrameDelay);
			}
		}
		
		private function handleDestructedFrameDelay(event:Event):void
		{
			super.removeEventListener(Event.ENTER_FRAME, this.handleDestructedFrameDelay);
			this.checkParent();
		}

		/**
		 * Check objects parent, after being removed. If the object still has a parent, the object has been removed by a timeline animation.
		 * If an object is removed by a timeline animation, the object is not used anymore and can be destructed
		 */
		private function checkParent():void
		{
			if (this.parent && !this._onParent) this.destruct();
		}

		private function handleRemovedFromStage(event:Event):void
		{
			this._onStage = false;
		}		