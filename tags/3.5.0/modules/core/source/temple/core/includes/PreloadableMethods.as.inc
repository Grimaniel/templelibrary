		/**
		 * @inheritDoc
		 */
		public function get preloader():IPreloader
		{
			return _preloadableBehavior.preloader;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set preloader(value:IPreloader):void
		{
			_preloadableBehavior.preloader = value;
		}