#!/usr/bin/env python3

if __name__ == '__main__':
    from os import path,environ
    from mapproxy.wsgiapp import make_wsgi_app
    from flup.server.fcgi import WSGIServer
    from logging.config import fileConfig
    import logging
    
    logging.config.fileConfig(r'/srv/mapproxy/config/log.ini', {'here': path.dirname(__file__)})

    if environ.get('DEBUG') == '1':
        logging.getLogger().setLevel(logging.DEBUG)
        logging.getLogger('mapproxy.source.request').setLevel(logging.DEBUG)

    application = make_wsgi_app(r'/srv/mapproxy/config/mapproxy.yaml')
    WSGIServer(application).run()