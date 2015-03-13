Facter.add("kvm_capable") do
  setcode do
    File.readlines("/proc/cpuinfo").grep(/(vmx|svm)/).any?
  end
end
