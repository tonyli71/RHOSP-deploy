require 'facter/util/ip' 
module Puppet::Parser::Functions
  newfunction(:get_nic_from_network, :type => :rvalue, :doc => <<-EOS
This returns the nic associatd with the given network.
EOS
  ) do |arguments|

    raise(Puppet::ParseError, "get_nic_from_network(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    the_network= arguments[0]
    ifaces = lookupvar("interfaces").split(",")

    our_nic = nil 

    ifaces.each do |interface|
        cur_network = lookupvar("network_#{interface}")
        if (cur_network == the_network)
            our_nic = interface 
            break
        end 
    end 
    return our_nic 
  end 
end
