require 'tempfile'

def remove_file_lines(filename, start, num)
  tmp = Tempfile.open("tmp-rails-builder") do |fp|
    File.foreach(filename) do |line|
      if $. >= start and num > 0
        num -= 1
      else
        fp.puts line
      end
    end
    fp
  end
  puts "Warning: End of file encountered before all lines removed" if num > 0
  FileUtils.copy(tmp.path, filename)
  tmp.unlink
end

def find_line_for(filename, text)
  matching_line = nil
  File.foreach(filename) do |line|
    if line.include?(text)
      matching_line = $.
    end
  end

  matching_line
end
