package com.github.moketao.ver
{
	import flash.display.Sprite;
	
	public class Ver_test extends Sprite
	{
		public function Ver_test()
		{
			trace("=========下面演示单文件md5的hash操作==================================");
			var md5:String = Ver.md5File("c:/c/c.txt");
			trace(md5);
			
			trace("\n");
			
			
			trace("=========下面演示目录md5的hash操作==================================");
			var dic:Array = Ver.md5Dir("c:/c");
			for (var i:int = 0; i < dic.length; i++){
				var ob:Object = dic[i];
				trace(ob.md5,ob.time,ob.name);
			}
		}
	}
}