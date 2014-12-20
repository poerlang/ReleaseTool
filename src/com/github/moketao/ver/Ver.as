package com.github.moketao.ver
{
	import com.github.moketao.fileutil.FileX;
	import com.hurlant.crypto.hash.MD5;
	import com.hurlant.util.Hex;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class Ver
	{
		public function Ver()
		{
		}
		
		public static function md5File(path:*):String
		{
			var b:ByteArray = FileX.FileToBytes(path);
			var md5:MD5 = new MD5();
			return Hex.fromArray(md5.hash(b));
		}
		public static function md5Dir(path:*,dic:Array=null):Array
		{
			if(dic==null) dic = [];
			var f:File = (path is String)? new File(path):path;
			if(f.isDirectory){
				var arr:Array = f.getDirectoryListing();
				for (var i:int = 0; i < arr.length; i++){
					var sub:File = arr[i] as File;
					if(sub.isDirectory){
						md5Dir(sub,dic);
					}else{
						save(sub);
					}
				}
				
			}else{
				save(f);
			}
			function save(subfile:File):void{
				var ob:Object = {};
				ob.md5 = md5File(subfile);
				ob.time = subfile.modificationDate.time;
				ob.name = subfile.nativePath;
				dic.push(ob);
			}
			return dic;
		}
	}
}