require $dp_dir + "module_StackTrace_tool.rb"
include Math

def score()
	nfbhash = Hash.new{|hash,key| hash[key] = Hash.new{0}}
	bfhash = Hash.new{|hash,key| hash[key] = Hash.new{0}}
	dsthash = Hash.new{|hash,key| hash[key] = Hash.new{0}}

	# read sampling file list
	sigfhash = Hash.new{|hash,key| hash[key] = Hash.new{}}
	File.open($smp_p_v) do |io|
		while line = io.gets
			line.chomp!
			items = line.split(/\t/)

			if items[2] == nil || items[2] == ""
				next
			end

			sig = items[0]
			file = items[2]
			sigfhash[sig][file] = 1
		end
	end

	# analyze sampled files
	sigfhash.each_key do |sig|
		sigfhash[sig].each_key do |file|

			fdhash = StackTrace.GetStat($cr_dir, file)

			fdhash.each do |fname, dst|
				if fname == "" || fname == nil
					next
				end
				nfbhash[sig][fname] += 1
				bfhash[fname][sig] = 1
				dsthash[sig][fname] += dst
			end
		end
	end

	# scoring
	scrhash = Hash.new{|hash,key| hash[key] = Hash.new{0}}
	nfbhash.each_key do |sig|
		nfbhash[sig].each do |fname, nfb|
			nb = sigfhash[sig].size
			ff = nfb / nb.to_f
			shb = sigfhash.size
			shbf = bfhash[fname].size

			ibf = log10((shb/shbf.to_f) + 1)

			sdst = dsthash[sig][fname]
			iad = nfb / (1 + sdst).to_f

			scrhash[sig][fname] = ff * ibf * iad
		end
	end

	# output result of scoring
	rslf = File.open($rslt_p_v,"w")
	scrhash.each_key do |sig|
		rslf.print "#{sig}"
		scrhash[sig].sort{|(k1, v1), (k2, v2)| v2 <=> v1 }.each do |fname, scr|
			rslf.print "\t#{fname}\t#{scr}\n"
		end
	end
	rslf.close
end