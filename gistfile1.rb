miceFile = File.open("/dev/input/mice", "r")

mouseClickActions = { 0 => "- None\n\n",
					  1 => "- Left Mouse Button\n\n",
					  2 => "- Right Mouse Button\n\n" ,
					  3 => "- Left Mouse Button\n- Right Mouse Button\n\n",
					  4 => "- Middle Mouse Button\n\n",
					  5 => "- Left Mouse Button\n- Middle Mouse Button\n\n",
					  6 => "- Right Mouse Button\n- Middle Mouse Button\n\n",
					  7 => "- Left Mouse Button\n- Right Mouse Button\n- Middle Mouse Button\n\n" }

def decomposeMouseAction(bytes)
	output = ""
	output << "Buttons Pressed:\n"
	buttonBaseValue = 0
	direction = ""
	if bytes[1] == 0 && bytes[2] == 0 #still
		buttonBaseValue = 8
		direction = "Still"
	end
	if bytes[1] == 1 && bytes[2] == 0 #moving right
		buttonBaseValue = 8
		direction = "Right"
	end
	if bytes[1] == 0 && bytes[2] == 1 #moving up
		buttonBaseValue = 8
		direction = "Up"
	end
	if bytes[1] == 255 && (bytes[2] == 0 || bytes[2] == 1) #moving left
		buttonBaseValue = 24
		direction = "Left"
	end
	if (bytes[1] == 0 || bytes[1] == 1) && bytes[2] == 255 #moving down
		buttonBaseValue = 40
		direction = "Down"
	end
	case bytes[0]
	when buttonBaseValue + 0
		output << "- None\n"
	when buttonBaseValue + 1
		output << "- Left Mouse Button\n"
	when buttonBaseValue + 2
		output << "- Right Mouse Button\n" 
	when buttonBaseValue + 3
		output << "- Left Mouse Button\n- Right Mouse Button\n"
	when buttonBaseValue + 4
		output << "- Middle Mouse Button\n"
	when buttonBaseValue + 5
		output << "- Left Mouse Button\n- Middle Mouse Button\n"
	when buttonBaseValue + 6
		output << "- Right Mouse Button\n- Middle Mouse Button\n"
	when buttonBaseValue + 7
		output << "- Left Mouse Button\n- Right Mouse Button\n- Middle Mouse Button\n"
	end
	output << "Mouse Moving:\n#{direction}\n\n"
	return output
end

loop do
	bytes = [miceFile.getbyte, miceFile.getbyte, miceFile.getbyte]
	byteString = "#{bytes[0]} #{bytes[1]} #{bytes[2]}"
	puts "Byte combination: #{byteString}\n#{decomposeMouseAction(bytes)}"
	STDOUT.flush
end