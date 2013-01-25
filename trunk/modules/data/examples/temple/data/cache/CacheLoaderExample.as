/**
 * @exampleText
 * 
 * <a name="CacheLoader"></a>
 * <h1>CacheLoader</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/data/doc/temple/data/cache/CacheLoader.html">CacheLoader</a>.
 * The CacheLoader stores the data (as ByteArray) in the <a href="http://templelibrary.googlecode.com/svn/trunk/doc/temple/data/cache/LoaderCache.html" name="doc">LoaderCache</a> with the url as key.
 * The next time a CacheLoader needs to load the same url it gets the data directly from the LoaderCache.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/data/examples/temple/data/cache/CacheLoaderExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/data/examples/temple/data/cache/CacheLoaderExample.as" target="_blank">View source</a></p>
 */
package  
{
	import temple.data.cache.CacheLoader;
	import flash.net.URLRequest;

	// This class extends the DocumentClassExample, which handles some default Temple settings. This class can be found in directory '/examples/templates/'
	public class CacheLoaderExample extends DocumentClassExample 
	{
		private static const _URL:String = "image.jpg";
		
		public function CacheLoaderExample()
		{
			super("Temple - CacheLoaderExample");
			
			// create a new CacheLoader
			var loader:CacheLoader = new CacheLoader();
			addChild(loader);
			loader.scale = .2;
			loader.load(new URLRequest(_URL));
			
			// create an other CacheLoader and load the same URL. The image is only loaded once.
			loader = new CacheLoader();
			addChild(loader);
			loader.scale = .2;
			loader.x = 300;
			loader.load(new URLRequest(_URL));
		}
	}
}
