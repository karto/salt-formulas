{%- macro statesource(formula, name) -%}
  {% for environment in pillar.get('environments', []) %}
  - salt://{{ environment }}/{{ formula }}/{{ grains.host }}/{{ grains['os'] }}/{{ name }}
  - salt://{{ environment }}/{{ formula }}/{{ grains.host }}/{{ name }}
  {% for cluster in pillar.get('clusters', []) %}
  - salt://{{ environment }}/{{ formula }}/{{ cluster }}/{{ grains['os'] }}/{{ name }}
  - salt://{{ environment }}/{{ formula }}/{{ cluster }}/{{ name }}
  {% endfor %}
  - salt://{{ environment }}/{{ formula }}/{{ grains['os'] }}/{{ name }}
  - salt://{{ environment }}/{{ formula }}/{{ name }}
  {% endfor %}
  - salt://{{ formula }}/files/{{ grains['os'] }}/{{ name }}
  - salt://{{ formula }}/files/{{ name }}
{%- endmacro %}