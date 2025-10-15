require 'socket'
require 'securerandom'

# Optional dependency: system-getifaddrs provides native network interface enumeration
# If not available (e.g., compilation issues on newer macOS/Ruby), we fall back to
# a pure Ruby implementation that still provides accurate local IP detection
# Try to load system/getifaddrs, fallback to mock implementation if not available
begin
  require 'system/getifaddrs'
rescue LoadError
  # Fallback System module implementation when system-getifaddrs is not available
  # This provides compatible functionality using standard Ruby socket methods
  module System
    def self.get_ifaddrs
      # Fallback implementation using standard Ruby socket methods
      begin
        # Try to get local IP by connecting to a remote address
        UDPSocket.open do |s|
          s.connect "8.8.8.8", 1
          local_ip = s.addr.last
          return [{
            name: 'fallback',
            inet_addr: local_ip,
            netmask: '255.255.255.0',
            flags: ['UP', 'RUNNING']
          }]
        end
      rescue
        # Final fallback to localhost
        return [{
          name: 'lo0',
          inet_addr: '127.0.0.1',
          netmask: '255.0.0.0',
          flags: ['UP', 'LOOPBACK', 'RUNNING']
        }]
      end
    end

    def self.get_all_ifaddrs
      get_ifaddrs
    end
  end
end

module Quaff

module Utils #:nodoc:
def Utils.local_ip
  addrs = System.get_ifaddrs
  if addrs.empty?
    "0.0.0.0"
  elsif (addrs.size == 1)
    addrs[0][:inet_addr]
  else
    addrs.select {|k, v| k != :lo}.shift[1][:inet_addr]
  end
end

def Utils.pid
    Process.pid
end

def Utils.new_branch
    "z9hG4bK#{SecureRandom::hex[0..5]}"
end

def Utils.paramhash_to_str params
  params.collect {|k, v| if (v == true) then ";#{k}" else ";#{k}=#{v}" end}.join("")
end

end
end
