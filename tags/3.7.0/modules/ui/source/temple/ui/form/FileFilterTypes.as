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

package temple.ui.form 
{
	import flash.net.FileFilter;

	/**
	 * Class with predefined FileFilters for common used files.
	 * 
	 * <p>This classes uses getters instead of const to prefend creating unused filters.</p>
	 * 
	 * @author Thijs Broerse
	 */
	public class FileFilterTypes 
	{
		private static var _IMAGES:FileFilter; 
		private static var _TEXT:FileFilter; 
		private static var _SWF:FileFilter; 
		private static var _VIDEO:FileFilter; 
		private static var _COMPRESSED:FileFilter; 
		private static var _SOUNDS:FileFilter; 

		/**
		 * Returns a FileFilter for images
		 */
		public static function get IMAGES():FileFilter
		{
			return FileFilterTypes._IMAGES ||= new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
		}

		/**
		 * Returns a FileFilter for text files
		 */
		public static function get TEXT():FileFilter
		{
			return FileFilterTypes._TEXT ||= new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf");
		}

		/**
		 * Returns a FileFilter for SWF files
		 */
		public static function get SWF():FileFilter
		{
			return FileFilterTypes._SWF ||= new FileFilter("Flash Applications (*.swf)", "*.swf");
		}

		/**
		 * Returns a FileFilter for video files
		 */
		public static function get VIDEO():FileFilter
		{
			return FileFilterTypes._VIDEO ||= new FileFilter("Videos (*.mov, *.mpeg, *.mp4, *.wmv)", "*.mov;*.mpeg;*.mp4;*.wmv");
		}
		
		/**
		 * Returns a FileFilter for video files
		 */
		public static function get VIDEO_EXTENDED():FileFilter
		{
			return FileFilterTypes._VIDEO ||= new FileFilter("Videos (*.mov, *.mpeg, *.mp4, *.wmv, *.flv, *.f4v, *.3gp, *.avi)", "*.mov;*.mpeg;*.mp4;*.wmv;*.flv;*.f4v;*.3gp;*.avi");
		}

		/**
		 * Returns a FileFilter for Flash video files
		 */
		public static function get FLASH_VIDEO():FileFilter
		{
			return FileFilterTypes._VIDEO ||= new FileFilter("Videos (*.flv, *.f4v, *.mp4)", "*.flv;*.f4v;*.mp4");
		}

		/**
		 * Returns a FileFilter for Flash video files
		 */
		public static function get FLASH_VIDEO_FLV():FileFilter
		{
			return FileFilterTypes._VIDEO ||= new FileFilter("Videos (*.flv)", "*.flv");
		}

		/**
		 * Returns a FileFilter for compressed files
		 */
		public static function get COMPRESSED():FileFilter
		{
			return FileFilterTypes._COMPRESSED ||= new FileFilter("Compressed (*.gz, *.tar, *.zip)", "*.gz;*.tar;*.zip");
		}

		/**
		 * Returns a FileFilter for sound files
		 */
		public static function get SOUNDS():FileFilter
		{
			return FileFilterTypes._SOUNDS ||= new FileFilter("Sounds (*.mp3)", "*.mp3");
		}
	}
}
