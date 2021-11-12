require 'net/ftp'
require "fileutils"

years = (2013..2021).to_a
host = 'open.iub.gov.lv'
ftp = Net::FTP.new(host)
ftp.login

years.each do |year|
  local_dir = "files/#{year}"
  FileUtils.mkdir_p local_dir
  Dir.chdir(local_dir) do
    ftp.chdir("/#{year}")
    month_dirs = ftp.nlst
    month_dirs.each do |month_dir|
      ftp.chdir("/#{year}/#{month_dir}")
      ftp.nlst.each do |file|
        if File.file?(file) && File.size(file) > 0
          puts "#{Time.now} Already downloaded #{file}"
          next
        end

        puts "#{Time.now} Downloading #{file}"
        retries = 3
        while retries > 0
          begin
            Timeout.timeout(5) { ftp.getbinaryfile file }
            break
          rescue => e
            retries -= 1
            if retries > 0
              puts "#{Time.now} Exception #{e.class.name}: #{e.message} - retrying ..."
              ftp.close rescue nil
              ftp = Net::FTP.new(host)
              ftp.login
              ftp.chdir("/#{year}/#{month_dir}")
            else
              puts "#{Time.now} Failed downloading #{file}"
              FileUtils.rm_f file
              ftp.close rescue nil
              raise
            end
          end
        end
      end
    end
  end
end
