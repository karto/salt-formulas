vim:
  pkg.installed:
    {% if grains['os'] == 'RedHat' %}
    - name: vim-minimal
    {% else %}
    - name: vim
    {% endif %}


