package com.github.moketao.jiami
{
	import com.github.moketao.fileutil.FileX;
	
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	public class JiaMi_test extends Sprite
	{
		public function JiaMi_test()
		{
			//要加密的内容
			var src:String = "//此地无银三百两 var a:function = function():void{ trace(123);}";
			trace("原文:\n"+src);
			
			//要加密的内容（二进制格式）
			var b:ByteArray = new ByteArray();
			b.writeUTFBytes(src);
			
			
			//加密模块jm
			var jm:JiaMi = new JiaMi("http://moketao.github.io");//设置密码（密匙）
			
			
			trace("\n=============下面演示加密 字符串========================");
			var encode:String = jm.encodeString(src);//加密
			trace(encode);
			var decode:String = jm.decodeString(encode);//解密
			trace(decode);
			
			trace("\n");
			
			
			jm.setSeed("34wer.7#923wrwy");//改变seed，密码不变
			trace("改变seed，密码不变，再加密，密文会不同，但仍可还原明文:");
			var encode2:String = jm.encodeString(src);//加密
			trace(encode2);
			var decode2:String = jm.decodeString(encode2);//解密
			trace(decode2);
			
			
			
			trace("\n=============下面演示加密 二进制========================");
			var b2:ByteArray = jm.encodeByte(b);//加密
			trace(b2.readUTFBytes(b2.bytesAvailable));
			var b3:ByteArray = jm.decodeByte(b2);//解密
			trace(b3.readUTFBytes(b3.bytesAvailable));
			
			
			trace("\n=============下面演示加密 文件========================");
			FileX.stringToFile(src,"c:/c.txt");
			jm.encodeFile("c:/c.txt","c:/c2.txt");
			jm.decodeFile("c:/c2.txt","c:/c3.txt");
			
		}
	}
}