/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2012 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *	
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
		 * Returns a FileFiler for images
		 */
		public static function get IMAGES():FileFilter
		{
			return FileFilterTypes._IMAGES ||= new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
		}

		/**
		 * Returns a FileFiler for text files
		 */
		public static function get TEXT():FileFilter
		{
			return FileFilterTypes._TEXT ||= new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf");
		}

		/**
		 * Returns a FileFiler for SWF files
		 */
		public static function get SWF():FileFilter
		{
			return FileFilterTypes._SWF ||= new FileFilter("Flash Applications (*.swf)", "*.swf");
		}

		/**
		 * Returns a FileFiler for SWF files
		 */
		public static function get VIDEO():FileFilter
		{
			return FileFilterTypes._VIDEO ||= new FileFilter("Videos (*.mov, *.mpeg, *.mp4, *.wmv)", "*.mov;*.mpeg;*.mp4;*.wmv");
		}

		/**
		 * Returns a FileFiler for SWF files
		 */
		public static function get FLASH_VIDEO():FileFilter
		{
			return FileFilterTypes._VIDEO ||= new FileFilter("Videos (*.flv, *.f4v, *.mp4)", "*.flv;*.f4v;*.mp4");
		}

		/**
		 * Returns a FileFiler for SWF files
		 */
		public static function get COMPRESSED():FileFilter
		{
			return FileFilterTypes._COMPRESSED ||= new FileFilter("Compressed (*.gz, *.tar, *.zip)", "*.gz;*.tar;*.zip");
		}

		/**
		 * Returns a FileFiler for SWF files
		 */
		public static function get SOUNDS():FileFilter
		{
			return FileFilterTypes._SOUNDS ||= new FileFilter("Sounds (*.mp3)", "*.mp3");
		}
	}
}
