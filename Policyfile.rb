name 'python3'

run_list ['python3']

cookbook 'python3', path: '.'
cookbook 'python3-test', path: 'test/cookbooks/python3-test'
