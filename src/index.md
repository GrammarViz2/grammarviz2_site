---
layout: default
title: Home
---

<<<<<<< HEAD
=======
<div class="breadcrumb-bar">
  <div class="container">
    <ol class="breadcrumb">
        {% if site.morea_head_breadcrumb_link %}
          <li><a href="{{ site.morea_head_breadcrumb_link }}">{{ site.morea_head_breadcrumb_label }}</a></li>
          {% endif %}
      <li class="active">{{ page.title }}</li>
    </ol>
  </div>
</div>

<div class="container">
>>>>>>> core/master
{% if site.morea_home_page %}
  {{ site.morea_home_page.content | markdownify }}
{% else %}
  No home page content supplied.
{% endif %}
<<<<<<< HEAD
=======
</div>
>>>>>>> core/master

