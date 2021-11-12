require "fileutils"

years = Dir.chdir("files"){Dir["*"]}.grep(/\d{4}/)

years.each do |year|
  local_dir = "data/#{year}"
  FileUtils.mkdir_p local_dir
  files = Dir["files/#{year}/*.tar.gz"].map{|f| File.expand_path f}
  Dir.chdir(local_dir) do
    files.each do |file|
      `tar xzvf #{file}`
      unless $?.success?
        "Extract failed with #{$?.inspect}"
      end
    end
  end
end
