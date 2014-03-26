@dir = "/home/tomorrow/Code/active/cadenza/"
worker_processes 1
working_directory @dir

timeout 30

listen "#{@dir}tmp/sockets/unicorn.sock", backlog: 64

pid "#{@dir}tmp/pids/unicorn.pid"
