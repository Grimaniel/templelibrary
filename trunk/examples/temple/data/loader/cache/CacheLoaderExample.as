/**
 * @exampleText
 * 
 * <p>This is an example about the CacheLoader.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/loader/cache/CacheLoaderExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/loader/cache/CacheLoaderExample.swf</a></p>
 */
package  
{
	import flash.net.URLRequest;
	import temple.utils.StageSettings;
	import temple.data.loader.cache.CacheLoader;
	import temple.core.CoreSprite;

	public class CacheLoaderExample extends CoreSprite 
	{
		private static const _URL:String = "http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/loader/cache/image.jpg";
		
		public function CacheLoaderExample()
		{
			super();
			
			new StageSettings(this);
			
			// create a new CacheLoader
			var loader:CacheLoader = new CacheLoader();
			this.addChild(loader);
			loader.scale = .2;
			loader.load(new URLRequest(_URL));
			
			// create an other CacheLoader and load the same URL. The image is only loaded once.
			loader = new CacheLoader();
			this.addChild(loader);
			loader.scale = .2;
			loader.x = 300;
			loader.load(new URLRequest(_URL));
		}
	}
}
