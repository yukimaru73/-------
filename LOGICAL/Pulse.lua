--Pulse(Toggle to Push)

--考え方
---なにか変数を作って、その変数に一つ前の状態を保存しておいてそれを現在の値と比較します。

--この例の場合の方針
---過去の値を保存する変数をPAST_STATEとします
---また、Pulseの動作モードをMODEとします
---MODEがtrueの場合はoff->on、falseの場合はon->offの動作をします



--例(Ch:1にそれぞれ入力信号、出力信号を割り当てる場合)
--グローバル変数の宣言
PAST_STATE = false --この変数に一つ前の状態を保存しておく
MODE = false --trueの場合はoff->on、falseの場合はon->offの動作

--onTick内の処理
function onTick()
	local inputSignal = input.getBool(1)
	local outputSignal = false
	if MODE then
		--off->onの場合の処理
		if inputSignal and not PAST_STATE then
			outputSignal = true
		end
	else
		--on->offの場合の処理
		if not inputSignal and PAST_STATE then
			outputSignal = true
		end
	end
	output.setBool(1, outputSignal)
end




--[上級者向け]お洒落な書き方(onTick内の処理を関数化)
--グローバル変数の宣言
PULSE =
{
	past_state = false,
	mode = false,
	update = function(self, input)
		local output = false
		if self.mode then
			if input and not self.past_state then
				output = true
			end
		else
			if not input and self.past_state then
				output = true
			end
		end
		self.past_state = input
		return output
	end
}
--onTick内の処理
function onTick()
	output.setBool(1, PULSE:update(input.getBool(1)))
end

--補足
---hoge.huga(hoge, 1)
---の関数は、
---hoge:huga(1)
---と書くこともできます
---お洒落な書き方では、この方法を使っています。