package temple
{
	import temple.debug.getClassName;
	import temple.debug.log.Log;

	/**
	 * CodeComponents are code-only, easy-to-use, light-weight components for Flash. CodeComponents are special designed
	 * for quick and easy creation of user interfaces and forms. All CodeComponents extend Temple classes and there they
	 * have all there features.
	 * 
	 * <p>CodeComponents can be styled by changing the properties in the CodeStyle class. This must be done before the
	 * component is created. Components which are already created before the properties of the CodeStyle class are
	 * changed won't be affected.</p>
	 * 
	 * @see temple.ui.buttons.CodeButton
	 * @see temple.ui.form.components.CodeCheckBox
	 * @see temple.ui.form.components.CodeInputField
	 * @see temple.ui.scroll.CodeScrollBar
	 * @see temple.ui.slider.CodeSlider
	 * @see temple.ui.slider.CodeStepSlider
	 * @see temple.ui.style.CodeStyle
	 * 
	 * @author Thijs Broerse
	 */
	public final class CodeComponents
	{
		/**
		 * The name of the CodeComponents
		 */
		public static const NAME:String = "CodeComponents";
		
		/**
		 * The current version of the CodeComponents
		 */
		public static const VERSION:String = "0.0.1";
		
		/**
		 * Build on this version of the Temple. The CodeComponents are build and tested on this version of the
		 * Temple. Therefore you should combine CodeComponents only with this version. Other version might not
		 * work properly.
		 */
		public static const TEMPLE_VERSION:String = "2.8.0";
		
		/**
		 * The Authors of the Temple
		 */
		public static const AUTHOR:String = "MediaMonks: Thijs Broerse";
		
		/**
		 * Last modified date of the CodeComponents
		 */
		public static const DATE:String = "2010-12-30";
		
		/**
		 * The official website of the Temple CodeComponents.
		 * <a href="http://code.google.com/p/templelibrary/" target="_blank">http://code.google.com/p/templelibrary/</a>
		 */
		public static const WEBSITE:String = "http://code.google.com/p/templelibrary/";

		/**
		 * Check the version of the CodeComponents with the version of the Temple and log a warning if versions don't match.
		 */
		public static function checkVersion():void
		{
			if (TEMPLE_VERSION != Temple.VERSION)
			{
				Log.warn("Temple version (" + Temple.VERSION + ") doens't match CodeComponents Temple version (" + TEMPLE_VERSION + ").", CodeComponents);
			}
		}
		
		public static function toString():String
		{
			return getClassName(CodeComponents);
		}
	}
}