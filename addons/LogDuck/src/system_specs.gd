extends LogDuckSettings
class_name LogDuckSystemSpecs


func output():
	var str : String = "\n" 
	str += get_specs_startup()
	
	LogDuck.d(str)


func add_header(header) -> String:
	if not show_specs_headers:
		return ""
	if print_rich:
		return specs_header_format_rich % [header]
	else:
		return specs_header_format % [header]


func add_line(key, value) -> String:
	if print_rich:
		return specs_format_rich % [key, value]
	else:
		return specs_format % [key, value]


## Adjust the information you'd like to include at startup by commenting out / 
## commenting the respective lines
func get_specs_startup() -> String:
	var str : String = ""
	str += get_date()
	str += get_specs_hardware()
	str += get_specs_video()
	str += get_specs_audio()
	str += get_specs_display()
	str += get_specs_engine()
	str += get_specs_input()
	str += get_specs_localization()
	str += get_specs_mobile()
	str += get_specs_software()
	return str


## Returns a comprehensive string of system specs, useful for assembling bug-reports
func get_all_specs(remove_bbcode = true) -> String:
	var str : String = ""
	str += get_date()
	str += get_specs_hardware()
	str += get_specs_video()
	str += get_specs_audio()
	str += get_specs_display()
	str += get_specs_engine()
	str += get_specs_input()
	str += get_specs_localization()
	str += get_specs_mobile()
	str += get_specs_software()
	return str


func get_specs_display() -> String:
	var str = ""
	str += add_header("Display")
	str += add_line("Screen count", DisplayServer.get_screen_count())
	str += add_line("DPI", DisplayServer.screen_get_dpi())
	str += add_line("Scale factor", DisplayServer.screen_get_scale())
	str += add_line("Maximum scale factor", DisplayServer.screen_get_max_scale())
	str += add_line("Startup screen position", DisplayServer.screen_get_position())
	str += add_line("Startup screen size", DisplayServer.screen_get_size())
	str += add_line("Startup screen refresh rate", ("%f Hz" % DisplayServer.screen_get_refresh_rate()) if DisplayServer.screen_get_refresh_rate() > 0.0 else "")
	str += add_line("Usable (safe) area rectangle", DisplayServer.get_display_safe_area())
	str += add_line("Screen orientation", [
		"Landscape",
		"Portrait",
		"Landscape (reverse)",
		"Portrait (reverse)",
		"Landscape (defined by sensor)",
		"Portrait (defined by sensor)",
		"Defined by sensor",
	][DisplayServer.screen_get_orientation()])
	return str


func get_specs_audio() -> String:
	var str = ""
	str += add_header("Audio")
	str += add_line("Mix rate", "%d Hz" % AudioServer.get_mix_rate())
	str += add_line("Output latency", "%f ms" % (AudioServer.get_output_latency() * 1000))
	str += add_line("Output device list", ", ".join(AudioServer.get_output_device_list()))
	str += add_line("Capture device list", ", ".join(AudioServer.get_input_device_list()))
	return str


func get_specs_engine() -> String:
	var str = ""
	str += add_header("Engine")
	str += add_line("Version", Engine.get_version_info()["string"])
	str += add_line("Command-line arguments", str(OS.get_cmdline_args()))
	str += add_line("Is debug build", OS.is_debug_build())
	# str += add_line("Executable path", OS.get_executable_path())
	# str += add_line("User data directory", OS.get_user_data_dir())
	str += add_line("Filesystem is persistent", OS.is_userfs_persistent())
	return str


func get_specs_hardware() -> String:
	var str = ""
	str += add_header("Hardware")
	str += add_line("Model name", OS.get_model_name())
	str += add_line("Processor name", OS.get_processor_name())
	str += add_line("Processor count", OS.get_processor_count())
	return str


func get_specs_input() -> String:
	var str = ""
	str += add_header("Input")
	str += add_line("Device has touch screen", DisplayServer.is_touchscreen_available())
	var has_virtual_keyboard = DisplayServer.has_feature(DisplayServer.FEATURE_VIRTUAL_KEYBOARD)
	str += add_line("Device has virtual keyboard", has_virtual_keyboard)
	if has_virtual_keyboard:
		add_line("Virtual keyboard height", DisplayServer.virtual_keyboard_get_height())
	return str


func get_specs_localization() -> String:
	var str = ""
	str += add_header("Localization")
	str += add_line("Locale", OS.get_locale())
	return str


func get_specs_mobile() -> String:
	var str = ""
	str += add_header("Mobile")
	str += add_line("Granted permissions", OS.get_granted_permissions())
	return str


func get_specs_software() -> String:
	var str = ""
	str += add_header("Software")
	str += add_line("OS name", OS.get_name())
	return str


func get_specs_video() -> String:
	var str = ""
	str += add_header("Video")
	str += add_line("Adapter name", RenderingServer.get_video_adapter_name())
	str += add_line("Adapter vendor", RenderingServer.get_video_adapter_vendor())
	str += add_line("Adapter type", [
		"Other (Unknown)",
		"Integrated",
		"Discrete",
		"Virtual",
		"CPU",
	][RenderingServer.get_video_adapter_type()])
	str += add_line("Adapter graphics API version", RenderingServer.get_video_adapter_api_version())

	var video_adapter_driver_info = OS.get_video_adapter_driver_info()
	if video_adapter_driver_info.size() > 0:
		str += add_line("Adapter driver name", video_adapter_driver_info[0])
	if video_adapter_driver_info.size() > 1:
		str += add_line("Adapter driver version", video_adapter_driver_info[1])
	return str


static func scan_midi_devices():
	OS.open_midi_inputs()
	var devices = ", ".join(OS.get_connected_midi_inputs())
	OS.close_midi_inputs()
	return devices


## Select the way time is shown, by uncommenting / commenting out the corresponding line
func get_date() -> String:
	var str = ""
	str += add_header("Date")
	# str += add_line("Date and time (local)", Time.get_datetime_string_from_system(false, true))
	# str += add_line("Date and time (UTC)", Time.get_datetime_string_from_system(true, true))
	# str += add_line("Date (local)", Time.get_date_string_from_system(false))
	# str += add_line("Date (UTC)", Time.get_date_string_from_system(true))
	# str += add_line("Time (local)", Time.get_time_string_from_system(false))
	# str += add_line("Time (UTC)", Time.get_time_string_from_system(true))
	# str += add_line("Timezone", Time.get_time_zone_from_system())
	# str += add_line("UNIX time", Time.get_unix_time_from_system())
	return str
