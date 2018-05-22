extern void print_string(char *str);
extern void print_char(char chr);
extern char key_detect_simple();
extern void print_str(char *str);
extern void clr_screen();
extern char key_detect(int echo, int block);
extern void read_floppy_2(int cylinder, int disk, int seg, int num, void* addr);
extern void write_floppy_2(int cylinder, int disk, int seg, int num, void* addr);
extern void jump_to_user(int cylinder, int disk, int seg, int num);

void print_str(char *str){
    char *p = str;
    while(*p != '\0'){
        print_char(*p);
        p++;
    }
}

void showInfo(char *message){
    print_string(message);
}

int min(int a, int b){
    return a<b?a:b;     // 得到最小值
}

int max(int a, int b){
    return a>b?a:b;     // 得到最大值
}

// 打印数字
void print_num(int a){
    if(a<10){
        print_char(a+'0');
        return;
    }
    print_num(a/10);
    print_char(a%10+'0');
}

void print_num_enter(int a){
    print_num(a);
    print_string("\r\n");
}

// 计算柱面号、磁头号和物理扇区号由C实现
void read_floppy(int segStart, int segNum, void* addr){
    // 柱面号=逻辑扇区号/36
    // 磁头号=(逻辑扇区号%36)/18
    // 物理扇区号=(逻辑扇区号%36)%18
    read_floppy_2(segStart/36, (segStart%36)/18, (segStart%36)%18+1, segNum, addr);
}

// 将addr中的内容写入扇区
void write_floppy(int segStart, int segNum, void* addr){
    write_floppy_2(segStart/36, (segStart%36)/18, (segStart%36)%18+1, segNum, addr);
}

void choose(int a, int b, int c, int d){
    print_string("Min:   ");
    int minn = min(min(min(a,b),c),d);  // 返回四个值中的最小值
    print_num_enter(minn);
    print_string("Max:   ");
    int maxn = max(max(max(a,b),c),d);  // 返回四个值中的最大值
    print_num_enter(maxn);
}

int input_num(){
    char chr = key_detect(1,1);
    int num = 0;
    while(chr>='0'&&chr<='9'){
        num = num*10+(chr-'0');
        chr = key_detect(1,1);
    }
    print_string("\r\n");
    return num;
}

void print_str_uppercase(char *str){
    char *p = str;
    while((*p)!='\0'){
        if((*p)>=97&&(*p)<=122){    // 若为小写字母
            (*p)-=32;   // 转化为大写字母
        }
        p++;
    }
}

// 打印文件名和扩展名
void print_hex_name(unsigned char *str){
    unsigned char *p=str;
    for(int i = 0;i < 8;++i){
        if(!(i%2)){
            for(int i = 0;i < 11;++i){
                if(*(p+i)!=0x20){
                    print_char(*(p+i));
                }
                if(i==7)print_char('.');
            }
            print_string("\r\n");
        }
        p += 32;// 忽略后32bytes
    }
}

int get(int a){
    return a<2?a:3-a;
}

void jump_user(int segStart, int segNum){
    jump_to_user(segStart/36, (segStart%36)/18, (segStart%36)%18+1, segNum);
}

void main(){
    int chr;
    showInfo("\r\nMyOs:\r\nc:   CLEAR\r\nt:   INPUT TEST\r\nj:   JUMP TO USER\r\nl:   LIST\r\nq:   QUIT\r\n");
    while(1){
        chr = key_detect_simple();
        if( chr == 'c' ){
            clr_screen();
            showInfo("\r\nMyOs:\r\nc:   CLEAR\r\nt:   INPUT TEST\r\nj:   JUMP TO USER\r\nl:   LIST\r\nq:   QUIT\r\n");
        }
        else if( chr == 't' ){
            showInfo("First test:   Noshow,Unblock\r\n");
            showInfo("Second test:   Show,Block\r\n");
            showInfo("Third test:   Show,Unblock\r\n");
            showInfo("Fourth test:   Noshow,Block\r\n");
            for(int i=0;i<4;++i){
                print_string("Test");
                print_char(i+1+'0');
                chr = key_detect(get(i),i%2);
                if(!(i%2)){
                    while(1){
                        chr = key_detect(get(i),i%2);
                        if(chr)break;
                    }
                    print_string(":Unblock\r\n");
                }
                else{
                    print_string(":Block\r\n");
                }
            }
        }
        else if( chr == 'l' ){
            unsigned char buffer[256];
            showInfo("List Name.\r\n");
            read_floppy(19, 1, buffer);
            print_hex_name(buffer);
        }
        else if( chr == 'q' ){
            print_string("Will quit.\r\n");
            break;
        }
        else if( chr == 'j' ){
            unsigned char buffer[256];
            int start = 0, val = 0;
            read_floppy(19, 1, buffer);  // 读取文件目录项表
            showInfo("Jump to user.\r\n1.Add\r\n2.Prime\r\n3.Hello\r\n");
            int num = input_num();
            if(num==1){
                clr_screen();
                start = 31 + buffer[90];  // 起始扇区号
                val = buffer[93] / 2;   // 扇区数
                jump_user(start, val);
            }
            else if(num==2){
                clr_screen();
                start = 31 + buffer[154];
                val = buffer[157] / 2;
                jump_user(start, val);
            }
            else if(num==3){
                clr_screen();
                start = 31 + buffer[218];
                val = buffer[221] / 2;
                jump_user(start, val);
            }
        }
        else{
            print_char(chr);
            print_string("\r\n");
        }
    }
}
