server {
	listen      directIP:80 default_server;
	server_name _;
	access_log  off;
	error_log   /dev/null;
	return      444;
}

server {
	listen              directIP:443 default_server ssl;
	listen              directIP:443 quic reuseport default_server;
	server_name         _;
	access_log          off;
	error_log           /dev/null;
	ssl_certificate     /etc/nginx/ssl/default/cert.pem;
	ssl_certificate_key /etc/nginx/ssl/default/privkey.pem;
	return              444;
}
