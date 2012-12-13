		/**
		 * @inheritDoc
		 */
		public function get preloader():IPreloader
		{
			return this._preloadableBehavior.preloader;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set preloader(value:IPreloader):void
		{
			this._preloadableBehavior.preloader = value;
		}