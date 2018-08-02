# # encoding: utf-8

# Inspec test for recipe REAN-jenkins::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe user('jenkins') do
  it { should exist }
end

describe port(8080) do
  it { should be_listening }
end
