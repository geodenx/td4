# Porting TD4 to CPLD
毎日コミュニケーションズ『CPUの創り方』の中で製作される TD4 (Toriaezu Dousasurudakeno 4bit-CPU) を CPLD で実装しました。  
CPLD は DesignWave 2003年1月号の付録である Altera EPM7256ATC100-10 を利用しました。
![EPM7256A PCB](https://github.com/geodenx/td4/wiki/epm7256a.jpg)

『CPUの創り方』では、汎用ロジック IC (74HC) を用いて TD4 を作っていきます。
74 で作ると半田付けが面倒なので CPLD という選択をしました。
74 で作る雰囲気を味わうために、74 のライブラリを組み合わせて回路図を書き、合成させようと試みました。
しかし、マウスで回路図すべてを描くのは骨が折れるので、結局 RTL (Register Transfer Level) 記述の Verilog-HDL で設計しました。

当初、Quartus II を利用して RTL から合成、フィッティング、JTAG ダウンロードまでしようとしましたが、 Quartus II は MAX7000A のような古いデバイスはサポートしていませんでした。
そこで、レガシーデバイスに対応している MAX+plus II を利用しました。
フリー版の MAX+plus II では RTL を合成するライセンスがないです。
そこで、他社の合成ツールを利用して RTL を EDIF (Electronic Design Interchange Format) に変換し、 EDIF を MAX+plusII でフィッティング、JTAG ダウンロードまで行ないました。

# TD4 Specification
Item                 | Value
-------------------- | -------------
General register     | 4 bit * 2
Address space        | 4 bit (16 byte)
Program counter	     | 4 bit
Flag register        | 1 bit (carry)
Arithmthic operation | 4 bit add
Clock                | 10 MHz
Logic cells          | 9/256 (3%) (チャタリング除去回路含む)

# Block Diagram
![Block Diagram](https://github.com/geodenx/td4/wiki/td4.png)

# Instruction Set (opcode)
* arithmetic  
ADD_A_Im 0x0, ADD_B_Im 0x5
* move  
MOV_A_Im 0x3, MOV_B_Im 0x7, MOV_A_B 0x1, MOV_B_A 0x4
* jump  
JMP_Im 0xF
* branch  
JNC_Im 0xE
* Port IN  
IN_A 0x2, IN_B 0x6
* Port OUT  
OUT_B 0x9, OUT_Im 0xB

# Mother Board
手元に 3.3V で動作するクロックがなかったので、トグルスイッチを使って手動クロックを発生することにしました。  
プッシュスイッチだとチャタリング除去にアナログ素子 (R,C,74HC14?) あるいは、タイマ(クロック)が必要ですが、
トグルスイッチだと2つの NAND ゲートでチャタリング除去ができてマクロセルの少ない CPLD では手頃です。
![Mother board schematic](https://github.com/geodenx/td4/wiki/td4.ce2.png)

# Register Transfer Level (RTL)
* td4/alu.v: ALU (Arithmetic Logic Unit)
* td4/decoder.v: opcode decoder
* td4/epm7256a.v: mother board top module
* td4/mux.v: MUX (multiplexer) module
* td4/opcode.v: opcode header file
* td4/pc.v: PC (Program Counter) module
* td4/register.v: register module
* td4/rom.v: ROM module
* td4/td4.v: TD4 CPU top module

# How to make
## license setup  
MAX+plus II のライセンスセットアップを行ないます。
## import EDIF  
RTLから合成ツールを用いてEDIFを生成し、*.edf と名付けます。
MAX+plus IIの [File] - [Project] - [Name] で *.edf を選択します。
## assign device  
MAX+plus II では、GUIでEPM725ATC100-10を選択できません。
とりあえず、[Assign] - [Device]で、EPM7256AETC100-10 を選択し、*.acf を編集します。
```
CHIP *
BEGIN
 DEVICE = EPM7256ATC100-10;
END
GLOBAL_PROJECT_SYNTHESIS_ASSIGNMENT_OPTIONS
BEGIN
 DEVICE_FAMILY = MAX7000A;
END;
```
## prefit  
[MAX+plus II] - [Compile] compiler window で [Start]
## pin assign  
[Assing] - [Pin/Location/Chip...] で Node Name, Pin, Pin Type を設定するか、
または、*.acf を直接編集します。
```
CHIP *
BEGIN
 |RESET : INPUT_PIN = 98;
 |LED0 : OUTPUT_PIN = 40;
 |LED1 : OUTPUT_PIN = 42;
 |LED2 : OUTPUT_PIN = 46;
 |LED3 : OUTPUT_PIN = 50;
 |TSW0 : INPUT_PIN = 78;
 |TSW1 : INPUT_PIN = 80;
END
```
## postfit  
compiler window で [Start]
## download  
ByteBlasterMV などをプリンタポートに接続します。
[Option] - [Hardware Setup] で設定を確認します。
(Windows2000/XP では予めデバイスドライバ Altera ByteBlaster を設定する必要があります。)
[MAX+plus II] - [Programmer] で [Program]

# References
1. 毎日コミュニケーションズ 『CPUの創り方』
2. CQ出版 『DesignWave』 2003年1月号
3. Altera MAX 7000 Programmable Logic Device Family Data Sheet
