require "nokogiri"

$product = ARGV[0]	#target product
$version = ARGV[1]	#product's version
$cr_dir = ARGV[2]	#crash report directory

$dp_dir = Dir.home + "/DefectPredictor/"	#home directory of this tool
$smp_dir = $dp_dir + "sampling/"	#directory for sampling
$all_id_sig_file_p_v = $smp_dir + "all_ids_and_sigs_#{$product}_#{$version}.csv"
$smp_p_v = $smp_dir + "random_sampled_#{$product}_#{$version}"
$rslt_dir = $dp_dir + "result/"
$rslt_p_v = $rslt_dir + "result_#{$product}_#{$version}.csv"

require $dp_dir + "rand_for_tool.rb"
require $dp_dir + "score_file_tool.rb"

unless Dir.exist?($dp_dir)
	Dir.mkdir($dp_dir)
end

# unless Dir.exist?($dp_dir + "#{$product}_#{$version}")
# 	Dir.mkdir($dp_dir + "#{$product}_#{$version}")
# end

unless Dir.exist?($smp_dir)
	Dir.mkdir($smp_dir)
end

unless Dir.exist?($rslt_dir)
	Dir.mkdir($rslt_dir)
end

# call rand
rand()
# call score
score()