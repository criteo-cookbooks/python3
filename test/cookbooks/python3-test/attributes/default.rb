default['python3_test']['pythons'] = [
  { name: node['python3']['name'],
    version: node['python3']['version'],
    binary_name: node['python3']['binary_name'],
    pip_binary_name: node['python3']['pip']['binary_name'] }
]
