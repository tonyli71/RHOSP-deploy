module Puppet::Parser::Functions
  newfunction(:map_params, :type => :rvalue, :doc => <<-EOS
This returns the value of an included params, so the user does not have to have the fully qualified module listed everywhere in the manifest.
EOS
  ) do |arguments|

    raise(Puppet::ParseError, "map_params(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    string = arguments[0]

    unless string.is_a?(String)
      raise(Puppet::ParseError, 'map_params(): Requires a ' +
        'string to work with')
    end

    result = lookupvar("::quickstack::pacemaker::params::#{string}")
    return result
  end

end
