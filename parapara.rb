require "open3"
require "fileutils"

file = ARGV[0]
output_path = ARGV[1]
rate = ARGV[2] || 3

tmpdir = File.join("/tmp", "parapara_#{Time.now.to_i}")
FileUtils.mkdir_p(tmpdir)
cmd = "ffmpeg -ss 0 -i #{file} -vsync 2 -r #{rate} -an -f image2 '#{File.join(tmpdir, "%04d.png")}'"
_output, _error, _status = Open3.capture3(cmd)

Dir.glob(File.join(tmpdir, "*.png")) do |filepath|
  output_base_name = File.basename(filepath).gsub("png", "jpg")
  outout_file_path = File.join(output_path, output_base_name)
  Open3.capture3("convert #{filepath} -resize 960x540 #{outout_file_path}")
  File.delete(filepath)
end
Dir.rmdir(tmpdir)

exit 0
