module Nic
  class BMC < Managed

    PROVIDERS = %w(IPMI)
    validates :provider, :presence => true, :inclusion => { :in => PROVIDERS }

    def proxy
      # try to find a bmc proxy in the same subnet as our bmc device
      proxy   = SmartProxy.with_features("BMC").joins(:subnets).where(['dhcp_id = ? or tftp_id = ?', subnet_id, subnet_id]).first if subnet_id
      proxy ||= SmartProxy.with_features("BMC").first
      raise Foreman::Exception.new(N_('Unable to find a proxy with BMC feature')) if proxy.nil?
      ProxyAPI::BMC.new({ :host_ip  => ip,
                          :url      => proxy.url,
                          :user     => username,
                          :password => password })
    end

  end
end
