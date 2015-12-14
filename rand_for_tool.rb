require "nokogiri"

def rand()
	aisf = File.open($all_id_sig_file_p_v,"w")
	Dir::foreach($cr_dir) do |file|
		if file =~ /^\./
			next
		end

		fpath = $cr_dir + file

		unless File.exist?(fpath)
			print "No such file in #{fpath}\n"
			exit(1)
		end

		# begin
			html = File.open(fpath)

			doc = Nokogiri::HTML(html)

			tables = doc.xpath("//table")
			tbzrs = tables[0].xpath(".//tr")

			unless tbzrs[0].xpath(".//th").text == "Signature"
				next
			end

			unless tbzrs[7].xpath(".//td").text == $product
				next
			end

			unless tbzrs[8].xpath(".//td").text == $version
				next
			end

			signature = tbzrs[0].xpath(".//td").text.split(/\n/).map{|item| item.strip}.reject(&:empty?)
			signature.delete("More Reports")
			signature.delete("Search")
			crsig = signature.join("")

			uuid = tbzrs[1].xpath(".//td").text

			aisf.print "#{crsig}\t#{uuid}\t#{file}\n"
		# rescue
		# 	p "rescue!!"
		# 	next
		# end
	end
	aisf.close


	randhash = Hash.new{|hash,key| hash[key] = Hash.new{}}
	File.open($all_id_sig_file_p_v) do |io|
		while line = io.gets
			line.chomp!
			items = line.split(/\t/)

			crsig = items[0]
			uuid = items[1]
			file = items[2]

			randhash[crsig][uuid] = file
		end
	end

	smpf = File.open($smp_p_v,"w")
	randhash.each_key do |crsig|
		if randhash[crsig].size > 100
			randoms = randhash[crsig].keys.sample(100)
			randoms.each do |uuid|
				file = randhash[crsig][uuid]
				smpf.print "#{crsig}\t#{uuid}\t#{file}\n"
			end
		else
			randhash[crsig].each_key do |uuid|
				file = randhash[crsig][uuid]
				smpf.print "#{crsig}\t#{uuid}\t#{file}\n"
			end
		end
	end
	smpf.close
end