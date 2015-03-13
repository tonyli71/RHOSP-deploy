module Puppet::Parser::Functions
  newfunction(:str2bool_i, :type => :rvalue, :doc => <<-EOS
This converts a string to a boolean. This attempt to convert strings that
contain things like: y, 1, t, true to 'true' and strings that contain things
like: 0, f, n, false, no to 'false'. The matching is case-insensitive.
EOS
  ) do |arguments|

    raise(Puppet::ParseError, "str2bool_i(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    string = arguments[0]

    # If string is already Boolean, return it
    if !!string == string
      return string
    end

    unless string.is_a?(String)
      raise(Puppet::ParseError, 'str2bool_i(): Requires either ' +
        'string to work with')
    end

    # We consider all the yes, no, y, n and so on too ...
    result = case string
      #
      # This is how undef looks like in Puppet ...
      # We yield false in this case.
      #
      when /^$/, '' then false # Empty string will be false ...
      when /^(1|t|y|true|yes)$/i then true
      when /^(0|f|n|false|no)$/i then false
      when /^(undef|undefined)$/i then false # This is not likely to happen ...
      else
        raise(Puppet::ParseError, 'str2bool_i(): Unknown type of boolean given')
    end

    return result
  end
end
