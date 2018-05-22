##运行说明  

###运行环境  	
	裸机虚拟机  
###虚拟机配置  
	内存：	512M  
	处理器：1  
	硬盘：	2GB  
	CD/DVD：自动检测  
	网络适配器：NAT  
###运行方法  
	将code.zip中的ostest.img加载到裸机的软盘中  
###程序功能  
```
	一、程序开始，提示：  
	（1）继续测试
	（2）跳到Main中
	若输入1，继续进行；若输入2，直接跳到第三步
	二、Entry.asm中的测试：
	（1）小写转大写测试：
		先输出原字符串，再输出转为大写的字符串。
	（2）最大值最小值测试：
		需要你输入4个数字（范围为0~2^31-1）,然后会输出四个数字中的最大值和最小值
	三、Main.c中的测试：
	程序一开始会提示你输入选项：
	c: 清屏：
		清屏后光标移到最前，并输出菜单。
	t: 输入测试：
		第一次输入是非阻塞且不回显的，但处于一个无限循环之中，只有输入字符才可退出循环，输入的字符会留在缓冲区。
		第二次输入是阻塞且回显的，但你无需输入，因为它会读取第一次输入留在缓冲区的字符。
		第三次输入是非阻塞但回显的，但处于一个无限循环之中，只有输入字符才可退出循环，输入的的字符回显并留在缓冲区。
		第四次输入是阻塞但不回显的，你无需输入，因为它会读取第三次输入留在缓冲区的字符。
	j: 装载子程序并运行：
		第一个子程序的功能是，输入两个数（0~65535），输出它们的和（和的范围也必须是0~65535）
		第二个子程序的功能是，输入一个数（0~65535），输出小于等于该数的所有质数
		第三个子程序的功能是，在屏幕上显示一个“HELLO”的图形
		每个子程序在结束后按Esc都可以回到测试程序（回到第一步）
		（并没有做加载其他程序并运行的功能，只支持自带的三个子程序）
	l: 打印当前所有文件的名字
	q: 退出测试：
		退出后不再进行测试，也无法输入，需手动关机。
```


##编译说明  

###编译环境
	Ubuntu16.04.2_i386
	(建议编译和移动子程序到软盘均在Ubuntu虚拟机中进行)  
###编译步骤  
```
	保证当前目录下有code.zip中的所有.asm文件、.c文件、.lds文件、.sh文件及makefile
	1、在终端输入输入make
		(这一步若出现错误，建议在makefile文件的CFLAGS变量后面加上 -fno-pie选项(注意开头有空格中间无空格)
	2、进入root状态
	3、输入./test.sh
		(这一步之前需要chmod +x tesh.sh为test.sh赋予可执行权限)
		(需要保证ubuntu中有软盘部分，一开始需找到系统或虚拟机中的软盘目录，并用软盘目录代替tesh.sh中的"/media/floppy0")
		(建议不要直接拖动.bin文件到软盘，可能会出现莫名其妙的错误)
	(在这一步后可以输入"mount ostest.img 你的软盘目录"将ostest.img再次加载进软盘查看其中的文件项）
	最终得到的ostest.img文件即可装载到裸机虚拟机上运行  
```


