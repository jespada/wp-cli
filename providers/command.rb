action :execute do
  args = new_resource.args
  command = new_resource.command
  stdin = new_resource.stdin

  args_str = args_to_s(args)

  execute "wp-cli #{command}#{args_str}" do
    command "#{node['wp-cli']['bin']} #{command}#{args_str}#{stdin}"
    cwd new_resource.cwd
    user new_resource.user
  end
end

def args_to_s(args = {})
  args_str = ''
  args.each { |k,v|
    next if v.nil?
    key = "--#{k.to_s.shellescape}" if [String,Symbol].include? k.class
    arg = v.to_s.shellescape unless v === ''
    equal = '=' if key && arg
    args_str +=" #{key}#{equal}#{arg}"
  }
  args_str
end
