# 选择textgrid文件并获取区段数
selectObject: "TextGrid harmonics"
num_labels = Get number of intervals: 1

# 清空报表栏
clearinfo

# 打印表头
printline 'interval' 'h1' 'h2' 'h1-h2'

for i_label from 1 to num_labels 
	selectObject: "TextGrid harmonics"
	
	#获取区段名
	label$ = Get label of interval: 1, i_label
	
	# 若区段名不为空
	if label$ <> ""
		# 获取区段起始和终结时间
		start_time = Get start time of interval: 1, i_label
      	end_time = Get end time of interval: 1, i_label

		# 以起始和终结时间为准抽取音频文件
		selectObject: "Sound harmonics"
		Extract part: start_time, end_time, "rectangular", 1, "no"

		# 以抽取出来的音频文件为基础抽取音高对象
		soundpart_ID = selected("Sound")

		# 抽取极品对象
		To Pitch (ac): 0, 75, 15, "no", 0.03, 0.45, 0.01, 0.35, 0.14, 300
		pitch_ID = selected("Pitch")

		# H1即基频，所以抽取出来的基频就是H1的频率
		select 'pitch_ID'
		
		# 数字0和0表示从整个音高对象抽取基频平均值
		h1_hz = Get mean: 0, 0, "Hertz"
		# 第二谐波即基频乘以2
		h2_hz = h1_hz*2

		# 获取一个上下浮动10%的频率范围方便我们抽取不同频率上的振幅
		h1_hza = h1_hz-(h1_hz/10)
		h1_hzb = h1_hz+(h1_hz/10)

		h2_hza = h2_hz-(h2_hz/10)
		h2_hzb = h2_hz+(h2_hz/10)

		# 以抽取出来的音频文件为基础抽取Ltas对象（Long-Term Average Spectrum）
		select 'soundpart_ID'
		To Ltas: 50
		ltas_ID = selected("Ltas")
		
		# 获取H1和H2的振幅		
		h1_db = Get mean: h1_hza, h1_hzb, "dB"
		h2_db = Get mean: h2_hza, h2_hzb, "dB"
		# 计算H1-H2
		h1h2 = h1_db-h2_db
		
		printline 'label$' 'h1_hz'Hz 'h2_hz'Hz 'h1h2'
	endif
endfor
