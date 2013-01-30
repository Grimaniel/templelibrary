/*
 *	Temple Library for ActionScript 3.0
 *	Copyright © MediaMonks B.V.
 *	All rights reserved.
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	1. Redistributions of source code must retain the above copyright
 *	   notice, this list of conditions and the following disclaimer.
 *	2. Redistributions in binary form must reproduce the above copyright
 *	   notice, this list of conditions and the following disclaimer in the
 *	   documentation and/or other materials provided with the distribution.
 *	3. All advertising materials mentioning features or use of this software
 *	   must display the following acknowledgement:
 *	   This product includes software developed by MediaMonks B.V.
 *	4. Neither the name of MediaMonks B.V. nor the
 *	   names of its contributors may be used to endorse or promote products
 *	   derived from this software without specific prior written permission.
 *	
 *	THIS SOFTWARE IS PROVIDED BY MEDIAMONKS B.V. ''AS IS'' AND ANY
 *	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *	DISCLAIMED. IN NO EVENT SHALL MEDIAMONKS B.V. BE LIABLE FOR ANY
 *	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 */

package temple.facebook.api
{
	
	/**
	 * This API contains some methods for the canvas of your app inside Facebook. 
	 * 
	 * <p>Apps on Facebook are loaded into a Canvas Page. A Canvas Page is quite literally a blank canvas within
	 * Facebook on which to run your app.</p>
	 * 
	 * @see ../../../../readme.html Read me
	 * 
	 * @see temple.facebook.api.IFacebookAPI#canvas
	 * @see temple.facebook.api.FacebookAPI#canvas
	 * 
	 * @see http://developers.facebook.com/docs/guides/canvas/
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookCanvasAPI
	{
		/**
		 * A Boolean which indicates if the canvas calls are available.
		 */
		function get available():Boolean
		
		/**
		 * Returns an IFacebookCanvasPageInfoData object containing information about your app's canvas page. The value
		 * returned is old based on the last time it was fetched. You can provide a callback with the API, in which case
		 * we will fetch the new value and return with the callback.
		 * 
		 * Note: callback must accept one, and only one, argument of type <code>IFacebookCanvasPageInfoData</code>.
		 * 
		 * @see temple.facebook.data.vo.IFacebookCanvasPageInfoData
		 * @see http://developers.facebook.com/docs/reference/javascript/FB.Canvas.getPageInfo/
		 */
		function getPageInfo(callback:Function):void

		/**
		 * Note: this method is only enabled when Canvas Height is set to "Settable (Default: 800px)" in the 
		 * <code>Developer App.</code>
		 * 
		 * <p>Tells Facebook to scroll to a specific location of your canvas page. This should be used in conjunction with
		 * <code>FB.Canvas.setSize and FB.Canvas.setAutoResize.</code></p>
		 * 
		 * @see http://developers.facebook.com/docs/reference/javascript/FB.Canvas.scrollTo/
		 */
		function scrollTo(x:int, y:int):void;
		
		/**
		 * @see http://developers.facebook.com/docs/reference/javascript/FB.Canvas.setAutoGrow/
		 */
		function setAutoGrow():void;

		/**
		 * Tells Facebook to resize your iframe. If you do not specific any parameters Facebook will attempt to
		 * determine the height of the Canvas app and set the iframe accordingly. If you would like to set the dimension
		 * explicitly pass in an object with height and width properties.
		 * 
		 * Note: this method is only enabled when Canvas Height is set to "Settable (Default: 800px)" in the App
		 * Dashboard.
		 * 
		 * If the Canvas Width toggle in set to "Fixed (760px)" in the App Dashboard the max width is 760 pixels. There
		 * is no max height.
		 * 
		 * When passing NaN as value Facebook will attempt to determine the size of the Canvas app content and set the
		 * height automatically.
		 * 
		 * @param width Desired width. Max is app width.
		 * @param height Desired height.
		 */
		function setSize(width:Number = NaN, height:Number = NaN):void;
	}
}
