# Meta-state to fully install php.fpm
{% from 'php/ng/map.jinja' import php with context %}

include:
  - php.ng.fpm.config
  - php.ng.fpm.service
  - php.ng.fpm.pools

extend:
  php_fpm_service:
    service:
      - watch:
        {% set ini_file_managed = php.fpm.config.ini.get("managed", True) %}
        {% if ini_file_managed == True %}
        - file: php_fpm_ini_config
        {% endif %}

        - file: php_fpm_conf_config
      - require:
        - sls: php.ng.fpm.config
  {% if php.fpm.config.ini.get("managed", True) == True %}
  php_fpm_ini_config:
    file:
      - require:
        - pkg: php_install_fpm
  {% endif %}
  php_fpm_conf_config:
    file:
      - require:
        - pkg: php_install_fpm
