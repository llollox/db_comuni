module ApplicationHelper
	def command_label icon, label
		"<i class='#{icon} icon-white'></i> <span class='command-label'>&nbsp;#{label}</span>".html_safe
	end

	def separate_comma(number)
  	number.to_s.chars.to_a.reverse.each_slice(3).map(&:join).join(".").reverse
	end

	def separate_comma_decimals(number)
		number = number.to_s.split(".")
  	separate_comma(number[0]) + "," + number[1]
	end

end
