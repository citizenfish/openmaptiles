# Config for local server

1) create database openmaptiles
2) create user

```sql
CREATE USER openmaptiles WITH PASSWORD 'wibble55';
GRANT ALL PRIVILEGES ON database openmaptiles to openmaptiles;
```