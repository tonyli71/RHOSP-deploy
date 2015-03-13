require 'facter/util/ip' 
module Puppet::Parser::Functions
  newfunction(:get_nic_from_ip, :type => :rvalue, :doc => <<-EOS
This returns the nic associatd with the given ip.
EOS
  ) do |arguments|

    raise(Puppet::ParseError, "get_nic_from_ip(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    the_ip= arguments[0]
    ifaces = lookupvar("interfaces").split(",")

    our_nic = nil 

    ifaces.each do |interface|
        cur_ip = lookupvar("ipaddress_#{interface}")
        if (cur_ip == the_ip)
            our_nic = interface 
            break
        end 
    end 
    return our_nic 
  end 
end
