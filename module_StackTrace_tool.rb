require "nokogiri"

module StackTrace
	module_function

	def GetStat(crash_directory, file)
		fpath = crash_directory + file
		html = File.open(fpath)

		doc = Nokogiri::HTML(html)

		tables = doc.xpath("//table")
		num = 0
		nth = 0	# now thread
		limth = 1	# limit number of using thread. if increase limth, need rewriting score_file_tool.rb
		fdhash = Hash.new
		while 1
			num += 1
			if tables[num] == nil
				next
			end

			if tables[num].xpath(".//th").text == "FrameModuleSignatureSource"
				nth += 1
				dst = -1
				tables[num].xpath(".//tr").each do |tbr|
					dst += 1
					tbrds = []
					tbrds = tbr.xpath(".//td")
					if tbrds.size == 4
						fname = tbrds[3].text.split(/\//)[-1].gsub(/:[0-9]+/,"").strip
						unless fdhash.key?(fname)
							fdhash[fname] = dst
						end
					end
				end
				if nth >= limth
					break
				end 
			end
		end
		return fdhash
	end
end