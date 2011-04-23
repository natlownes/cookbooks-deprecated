# see https://gist.github.com/raw/845500/ed27ccba9ec0091a8a17788ebb61655dec0d3e28/haproxy-reverse.json for an example of the attributes
template "/etc/haproxy/haproxy.cfg" do
  source "haproxy-reverse.cfg.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "haproxy")
end
