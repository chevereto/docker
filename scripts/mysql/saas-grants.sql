-- Allow tenant database provisioning in SaaS development.
-- This extends the default MYSQL_USER bootstrap grants from the MySQL image.
GRANT CREATE ON *.* TO 'chevereto'@'%';
GRANT ALL PRIVILEGES ON `chevereto\_%`.* TO 'chevereto'@'%';
FLUSH PRIVILEGES;
