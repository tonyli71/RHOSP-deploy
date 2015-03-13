require 'facter/util/ip' 
module Puppet::Parser::Functions
    newfunction(:get_ip_from_network, :type => :rvalue, :doc => <<-EOS
This returns the ip associatd with the given network. 
                EOS
) do |arguments|
    Puppet::Parser::Functions.autoloader.loadall
    raise(Puppet::ParseError, "get_ip_from_network(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    the_network= arguments[0]
    ip = function_get_ip_from_nic([function_get_nic_from_network([the_network])])

    return ip
  end
end
