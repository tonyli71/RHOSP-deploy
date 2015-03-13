require 'facter/util/ip' 
module Puppet::Parser::Functions
    newfunction(:find_nic, :type => :rvalue, :doc => <<-EOS
This returns the nic associated with the given network or ip. 
                EOS
) do |arguments|
    Puppet::Parser::Functions.autoloader.loadall
    raise(Puppet::ParseError, "find_nic(): Wrong number of arguments " +
      "given (#{arguments.size} for 3)") if arguments.size < 3

    the_network= arguments[0] ||= ''
    the_nic = arguments[1] ||= ''
    the_ip = arguments[2] ||= ''

    if (the_network != '')
      function_get_nic_from_network([the_network])
    elsif (the_ip != '')
      function_get_nic_from_ip([the_ip])
    else
      the_nic
    end
  end
end
