if File.exist? '/usr/sbin/pcs'
  def pcs_nodes
    status = Facter::Util::Resolution.exec('/usr/sbin/pcs status 2>/dev/null')
    status.lines.find {|l| l =~ /^Online:/}.match(/\[([^\]]*)\]/)[1].split rescue []
  end

  def properties_for_node(node)
    props = Facter::Util::Resolution.exec("/usr/sbin/pcs property show #{node} 2>/dev/null")
    props.lines.last.split()[-1].split(',')
  end

  cluster_size = pcs_nodes.size
  service = {}

  pcs_nodes.each do |node|
    props = properties_for_node(node)

    Facter.add("pcs_props_#{node}") do
      setcode do
        props.join(',')
      end
    end

    props.each do |prop|
      if service.has_key? prop
        service[prop] += 1
      else
        service[prop] = 1
      end
    end
  end

  service.each_pair do |name,count|
    Facter.add("pcs_setup_#{name}") do
      setcode do
        if count == cluster_size
          true
        else
          false
        end
      end
    end
  end
end
