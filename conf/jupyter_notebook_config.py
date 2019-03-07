
c.ServerProxy.servers = {
    'webserver-port-30000': {
        'command': ['/opt/tinyproxy/tinyproxy.sh', '{port}', '30000'],
        'absolute_url': False
    }
}
