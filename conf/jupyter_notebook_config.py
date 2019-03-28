
c.ServerProxy.servers = {
    'webserver-port-80': {
        'command': ['/opt/tinyproxy/tinyproxy.sh', '{port}', '80'],
        'absolute_url': False
    }
}

c.NotebookApp.kernel_manager_class = 'coursewarekernelmanager.CoursewareKernelManager'
c.CoursewareKernelManager.max_kernels = 10
