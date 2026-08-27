//1.
log using hw1b10208038.smcl 
//創造一個 log檔
//2.
//平時作業一 陳允杰B10208038地理四
//3.
 cd "C:\Users\user\Desktop\統計作業"
//4.
import excel "C:\Users\user\Desktop\統計作業\ntu_gender_110.xls", sheet("Sheet
> 1") firstrow clear
//5.
save "C:\Users\user\Desktop\統計作業\ntu_gender_110_excel.dta"
//6.
clear
//7.
cd "C:\Users\user\Desktop\統計作業"
 use ntu_gender_110.dta
//8.
log off
//9.
describe
//A:obs:55
//A:vars:19
//10.
//A: 研究單位與觀察單位皆為「科系」。從 describe 結果可知資料共有 55 筆觀察值、19 個變數，每一列代表一個系所層級的彙整資料（如該系男性教師人數、男性預期薪資等），而非個別學生的資料。
//11.
//A:系所名稱:中文系，外文系
//男性教師人數:19人(中文系)，32人(外文系)
//男性預期薪資:30085元(中文系)，38727元(物理系)
//12.
 lookfor 大學
 lookfor 女性
//A:可以看出大學部女性比例是可以呼應以上現象的變數
//13.
log on
//14.
sum p_b_f, detail
//A:平均數:0.4484535
//標準差:0.1903938
//最大值:0.8023256
//最小值:0.1058394
//第25百分位數:0.2649254
//中位數:0.487395
//第75百分位數:0.5764706
//15.
sort p_b_f
 list dep in 1/5
 list p_b_f in 1/5
//A:物理(0.1058394)，數學(0.1317073)，電機(0.1402878)，工海(0.1414634)，資工(0.1581633)
list dep in -5/l
list p_b_f in -5/l
//A:醫檢(0.7066666)，護理(0.7309942)，日文(0.7418033)，圖資(0.7548077)，職治(0.8023256)
list dep if p_b_f == 0.487395
list dep in 28
//A:因為我們知道中位數是0.487395，是第28個，所以我們知道中位數的科系是植微系
//16.
log close



