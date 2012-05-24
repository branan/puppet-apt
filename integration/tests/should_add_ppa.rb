test_name "ppas"

ubuntus = hosts.select { |host| host['platform'] =~ /ubuntu/ }
ppa = 'ppa:chris-lea/node.js'
ppa_file = '/etc/apt/sources.list.d/chris-lea-node_js-precise.list'

step "add a PPA using puppet"
apply_manifest_on(ubuntus, "class {'apt': }  apt::ppa { '#{ppa}': }")

step "verify the expected file exists"
on ubuntus, "test -f #{ppa_file}"

step "cleanup after the test run"

if ubuntus.empty?
  skip_test "Skipping PPA test since there are no Ubuntus in the cluster"
end
