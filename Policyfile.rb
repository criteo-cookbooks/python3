name 'python3'

run_list ['python3']

named_run_list :test, run_list + ['recipe[python3-test]']

cookbook 'python3', path: '.'
cookbook 'python3-test', path: 'test/cookbooks/python3-test'
