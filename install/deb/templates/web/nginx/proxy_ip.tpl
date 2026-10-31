server {
	listen %ip%:%proxy_port% default_server;
	server_name _;
	access_log off;
	error_log /dev/null;
	return 301 https://$host$request_uri;
}

server {
	listen %ip%:%proxy_ssl_port% default_server ssl;
	listen %ip%:%proxy_ssl_port% quic reuseport default_server;
	server_name _;
	access_log off;
	error_log /dev/null;

	ssl_certificate     /etc/nginx/ssl/default/cert.pem;
	ssl_certificate_key /etc/nginx/ssl/default/privkey.pem;

	http2      on;
	http3      on;
	quic_retry on;
	add_header Alt-Svc 'h3=":443"; ma=86400' always;

	return 444;
}
