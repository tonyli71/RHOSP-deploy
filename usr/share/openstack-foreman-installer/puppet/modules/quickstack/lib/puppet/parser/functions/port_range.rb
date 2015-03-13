module Puppet::Parser::Functions
  newfunction(:port_range, :type => :rvalue,
    :doc => "Return an array of ports from first port to interval size") do |args|

    start = args[0].to_i
    count = args[1].to_i
    ports = (start...(start + count)).to_a
    ports.map {|port_num| port_num.to_s }
  end
end
