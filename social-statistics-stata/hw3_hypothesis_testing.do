*****實習課作業三*****
*（一）使用資料
    *1. 使用資料
    use "tscs2021q2_with_age.dta"
	
	*2. log檔
	log using hw3_b10208038.log
	
	*3. 註解
	*平時作業三 陳允杰 地理三 B10208038
	
	*4. cd
	cd "."

*（二）信賴區間
    *1. 算出台灣民眾的 BMI(e5a, e5b, kg/m2)
	tab e5a
	tab e5a, nolab
	tab e5b
	tab e5b, nolab
	recode e5a (997 998=.),gen(height_cm)
	gen height_m2 = (height_cm/100)*(height_cm/100)
	recode e5b (997 998=.),gen(weight_kg)
	gen BMI = weight_kg/height_m2 if height_m2!=. & weight_kg!=.

	*2. 臺灣民眾 BMI 的平均數是多少？
	sum BMI
	*BMI平均數=24.21694
	
	*3. 臺灣民眾 BMI 的 90%信賴區間
	ci means BMI, level(90)
	*CI=[24.04553, 24.38834]
	
	*4. 說明此 90%信賴區間的意義
	*有90%的信心水準，台灣人的BMI會包含在這個區間
	*或 重複從台灣人中抽取100次樣本，會有90次母體參數包含在這個區間
	
	*5. 用指令分別建構出男性女性 BMI 的95%信賴區間（請自行搜尋性別的變項，重新編碼並貼上適當的標籤）
	tab a1 
	tab a1, nolab
	recode a1 (1=0)(2=1),gen(female)
	label var female "女性"
	label define female_lab 1"女性"0"男性"
	label value female female_lab
	
	ci means BMI if female==1
	*女性CI=[22.96789, 23.52172]
	
	ci means BMI if female==0
	*男性CI=[25.00281, 25.56948]

	*6. 男性女性 BMI 的 95%信賴區間的圖表
	ciplot BMI, by(female)
	
*（三）單一母體假設檢定
	*1. 平均來說，是不是年輕女生（年輕=30 歲以下）家裡都只有一個人。還是會比一個人多？（已知母體變異數）
		*a. 創造變項
		lookfor 家
		tab j20
		tab j20, nolab
		recode j20 (98=.), gen(people_in_home)
		
		*b. 列出虛無假設、對立假設
		*u=年輕女生家裡有的平均人數（包含自己）
		*H0: u=1
		*H1: u>1
		
		*c. 指令（假設檢定）
		ztest people_in_home = 1 if age <=30 & female==1
		
		*d. 說明是否拒絕虛無假設，以及為什麼你做出這樣的判斷
		*拒絕虛無假設，因為Ha: mean>1的P值<顯著水準（或信賴區間為[3.160893, 3.536354]不包含1）

	*2. 他覺得他是少數，大家平均來說至少一個禮拜會有四天在家裡吃飯?（母體變異數未知）
		*a. 創造變項
		lookfor 外面
		tab e9 
		tab e9, nolab 
		recode e9 (92=.), gen(eat_out)
		gen eat_home = 7 - eat_out if eat_out !=. 
		
		*b. 列出虛無假設、對立假設
			*Scene 1: u=在家吃飯平均天數
			*H0: u >= 4
			*H1: u < 4
			
			*Scene 2: u=在外吃飯平均天數
			*H0: u <= 3
			*H1: u > 3
		
		*c. 指令（假設檢定）
			*Scene 1
			ttest eat_home = 4 
			
			*Scene 2
			ttest eat_out = 3

		*d. 說明是否拒絕虛無假設，以及為什麼你做出這樣的判斷
			*Scene 1
			*無法拒絕虛無假設，因為Ha: mean < 4的P值大於顯著水準（或信賴區間為[5.477782, 5.678799]不包含4）
			
			*Scene 2
			*無法拒絕虛無假設，因為Ha: mean > 3的P值大於顯著水準（或信賴區間為[1.321201, 1.522218]不包含3)
		
	*3. 他還是相信大部分人是值得信任的。請幫助他看看他講的是不是平均的狀況。
		*a. 創造變項：將「總是可以信任」、「大部分時候可以信任」編碼為 1
		lookfor 信任
		tab g1
		tab g1, nolab
		recode g1 (1 2 = 1)(3 4 = 0)(97 = .), gen(trust_ppl)
		
		*b. (超過六成）列出虛無假設、對立假設
		*p = 可以信任的平均比例
		*H0: p <= 0.6
		*H1: p > 0.6
		
		*c. 指令（假設檢定）
		prtest trust_ppl = 0.6
		
		*d. 說明是否拒絕虛無假設，以及為什麼你做出這樣的判斷
		*無法拒絕虛無假設，因為Ha: mean > 0.6的P值大於顯著水準，且信賴區間為[.4312221, .4800279]
		
*(四) 雙母體假設檢定
	*1. 檢定男性女性在家吃晚飯的天數是否有顯著差異（母體變異數未知）
		*a. 適用的情境？並說明理由
		*適用的情境是雙母體獨立假設檢定，因為男性和女性是本質上不同的兩個母體
		
		*b. 請先檢測上述兩群體的母體變異數是否相同，請以顯著水準 5%
		sdtest eat_home, by(female) 
		*不相同
		
		*c. 對立假設為「男性與女性一週在家吃晚餐的天數有差異」
		*u1: 男生平均在家吃飯天數
		*u2: 女生平均在家吃飯天數
		*H0: u1=u2
		*H1: u1!=u2
		
		*d. 指令（假設檢定）
		ttest eat_home, by (female) unequal
		
		*e. 解讀報表，請說明 t 統計值的數值、自由度、p-value。
		*t-value=  -5.5236
		*自由度= 1480.64
		*雙尾檢定，因此p-value為 0.0000
		
		*f. 說明是否拒絕虛無假設，以及為什麼你做出這樣的判斷
		*拒絕虛無假設，因為Ha: diff != 0的P值小於顯著水準，且diff的信賴區間[-.7688627, -.3658837]不包含0
		
	*2. 請使用 c7a、c7b
		*a. 將原變數反向編碼，使 1 代表「一點都不信任」，5代表「完全信任」
		tab c7a 
		tab c7a, nolab
		recode c7a (5=1)(4=2)(3=3)(2=4)(1=5)(94 = .), gen(trust_hlth)
		tab c7b
		tab c7b, nolab
		recode c7b (5=1)(4=2)(3=3)(2=4)(1=5)(94 97 = .), gen(trust_edu)

		*b. 適用的情境？並說明理由
		*雙母體相依樣本假設檢定，因為他是問同一群人（台灣民眾），對兩件事物的看法
		
		*c. 對立假設為「比起臺灣的醫療保健系統，民眾更不信任教育系統」。
		*u1 = 台灣民眾平均而言對醫療保健系統的信賴程度
		*u2 = 台灣民眾平均而言對教育系統的信賴程度
		*uD = u1 - u2
		*H0: uD <= 0
		*H1: uD > 0 

		*d. 指令（假設檢定）
		ttest trust_hlth = trust_edu
		
		*e. 解讀報表，請說明 t 統計值的數值、自由度、p-value。
		*t-value = 22.9979
		*自由度 = 1545
		*根據對立假設，p-value = 0.0000
		
		*f. 說明是否拒絕虛無假設，以及為什麼你做出這樣的判斷
		*拒絕虛無假設，因為Ha: mean(diff) > 0的P值小於顯著水準，且diff的信賴區間[.5165209, .6128452]不包含0但大於0
		
		
		

