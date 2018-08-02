# author Nidhi Hegde
# test to check 8080 accepts taffic
describe iptables do
  it { should have_rule('-A INPUT -p tcp -m tcp --dport 8080 -j ACCEPT') }
end
