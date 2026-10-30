server {
	listen %ip%:%proxy_port% default_server;
	server_name _;
	access_log off;
	error_log /dev/null;
	return 444;
}

server {
	listen %ip%:%proxy_ssl_port% default_server ssl;
	listen %ip%:%proxy_ssl_port% quic;
	server_name _;
	access_log off;
	error_log /dev/null;

	ssl_certificate     /etc/nginx/ssl/default/cert.pem;
	ssl_certificate_key /etc/nginx/ssl/default/privkey.pem;

	return 444;
}
